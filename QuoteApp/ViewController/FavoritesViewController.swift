//
//  FavoritesViewController.swift
//  QuoteApp
//
//  Created by Kevin Tito on 7/5/18.
//  Copyright © 2018 Kevin Tito. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

private let reuseIdentifier = "Cell"

class FavoriteCell: UICollectionViewCell {
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var catLabel: UILabel!
    
    
    func updateView(from quote: Quote){
        authorLabel.text = quote.author
        catLabel.text = quote.cat
        
    }
}

class FavoritesViewController: UICollectionViewController {
    var quotes: [Quote] = []
    
    @IBOutlet weak var noFavoritesLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        noFavoritesLabel.isHidden = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return quotes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FavoriteCell
    
        // Configure the cell
        cell.updateView(from: quotes[indexPath.row])
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    override func viewDidAppear(_ animated: Bool) {
        updateData()
    }
    
    func updateData() {
        let store = iQuoteStore()
        let favoriteQuotes = store.favoriteQuoteAsString()
        if favoriteQuotes.isEmpty {
            self.quotes  = []
            collectionView!.reloadData()
            noFavoritesLabel.isHidden = false
            return
        }
        Alamofire.request(QuoteApi.getHundredQuotes)
            .validate()
            .responseJSON(completionHandler: {response in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    //let error = json["status"].stringValue
                    if response.response?.statusCode == 200 {
                        //print(response.value as Any)
                        self.quotes = Quote.buildAll(from: JSON(value).arrayValue)
                        //let quote = Quote.buildAll(from: json.arrayValue)
                        //let quote = Quote.build(from: JSON(value).arrayValue)
                        // print("Found \(quote.count) Quotes")
                        self.collectionView?.reloadData()
                    }
                case .failure(let error):
                    print("Networking Error: \(error.localizedDescription)" )
                }
                
            })
    }

}

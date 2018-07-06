//
//  ViewController.swift
//  QuoteApp
//
//  Created by Kevin Tito on 7/5/18.
//  Copyright © 2018 Kevin Tito. All rights reserved.
//

import UIKit

class AboutQuoteViewController: UIViewController {
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    var isFavorite: Bool = false
    
    var quote : Quote? {
        didSet {
            print("Set \(quote!.quote)")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let quote = quote{
            quoteLabel.text = quote.quote
            isFavorite = quote.isFavorite()
            setFavoriteImage()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func toggleFavorite() {
        isFavorite = !isFavorite
        if let quote = quote {
            quote.setFavorite(isFavorite: isFavorite)
            let store = iQuoteStore()
            print("Favorite: \(store.favoriteQuoteAsString())")
        }
        setFavoriteImage()
    }
    
    func setFavoriteImage(){
        let name = isFavorite ? "favorite-black" : "favorite-border"
        favoriteButton.setImage(UIImage(named: name), for: .normal)
    }
    

    @IBAction func favoriteAction(_ sender: UIButton){
        toggleFavorite()
    }
    
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }


}


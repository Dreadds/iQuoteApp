//
//  iQuoteStore.swift
//  QuoteApp
//
//  Created by Kevin Tito on 7/6/18.
//  Copyright © 2018 Kevin Tito. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class iQuoteStore {
    init() {
    }
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    func save() {
        delegate.saveContext()
    }
    
    func setFavorite(_ isFavorite: Bool, for quote: Quote) {
        if self.isFavorite(quote: quote) == isFavorite {
            return
        }
        if self.isFavorite(quote: quote) {
            deleteFavorite(for: quote)
        } else {
            addFavorite(for: quote)
        }
    }
    
    func deleteFavorite(for quote: Quote) {
        let favorite = findFavoriteByAuthor(for: quote)
        if let favorite = favorite{
            context.delete(favorite)
            save()
        }
    }
    
    func addFavorite(for quote: Quote) {
        let favoriteEntity = NSEntityDescription.entity(forEntityName: "Favorite", in: context)
        let newFavorite = NSManagedObject(entity: favoriteEntity!, insertInto: context)
        newFavorite.setValue(quote.author, forKey: "author")
        newFavorite.setValue(quote.quote, forKey: "quote")
        newFavorite.setValue(quote.cat, forKey: "cat")
        newFavorite.setValue(Date(), forKey: "createdAt")
        save()
    }
    
    func findFavoriteByAuthor(for quote: Quote) -> NSManagedObject? {
        let predicate = NSPredicate(format: "author = %@", quote.author)
        return findFavoriteBy(predicate: predicate, for: quote)
    }
    
    func findFavoriteBy(predicate: NSPredicate, for quote: Quote) -> NSManagedObject? {
        let favoriteEntity = NSEntityDescription.entity(forEntityName: "Favorite", in: context)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: favoriteEntity!.name!)
        request.predicate = predicate
        do {
            let result = try context.fetch(request)
            if let favorite = result.first as? NSManagedObject{
                return favorite
            }
        } catch (let error){
            print("Error: \(error.localizedDescription)")
        }
        return nil
    }
    
    func findAllFavorites() -> [NSManagedObject]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        do {
            let result = try context.fetch(request)
            return result as? [NSManagedObject]
        } catch let error {
            print("Query Error: \(error.localizedDescription)")
        }
        return nil
    }
    
    func isFavorite(quote: Quote) -> Bool {
        return findFavoriteByAuthor(for: quote) != nil
    }
    func favorite(quote: Quote) {
        setFavorite(true, for: quote)
    }
    func unFavorite(quote: Quote) {
        setFavorite(false, for: quote)
    }
    
    func favoriteQuoteAsString() -> String {
        let favorites = findAllFavorites()
        
        if let favorites = favorites {
            print("All Favorites count: \(favorites.count)")
            return favorites
            .map({$0.value(forKey: "author") as! String})
            .filter({!$0.isEmpty})
            .prefix(5)
            .joined(separator: ",")
        }
        return ""
    }
}

//
//  Quote.swift
//  QuoteApp
//
//  Created by Kevin Tito on 7/5/18.
//  Copyright © 2018 Kevin Tito. All rights reserved.
//

import Foundation
import SwiftyJSON

class Quote {
    
    var quote: String
    var author: String
    var cat: String
    
    init(quote: String, author: String, cat: String) {
        self.quote = quote
        self.author = author
        self.cat = cat
    }
    
    convenience init (jsonQuote: JSON) {
        self.init(quote: jsonQuote["quote"].stringValue,
                  author: jsonQuote["author"].stringValue,
                  cat: jsonQuote["cat"].stringValue)
    }
    
    func isFavorite() ->Bool {
        let store = iQuoteStore()
        return store.isFavorite(quote: self)
    }
    
    func setFavorite(isFavorite: Bool){
        let store = iQuoteStore()
        store.setFavorite(isFavorite, for: self)
    }
    
    static func buildAll (from jsonQuotes: [JSON]) -> [Quote] {
        var quotes: [Quote] = []
        let count = jsonQuotes.count
        for i in 0 ..< count {
            quotes.append(Quote(jsonQuote: JSON(jsonQuotes[i])))
        }
        return quotes
    }
    
    
}

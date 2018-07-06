//
//  QuoteApi.swift
//  QuoteApp
//
//  Created by Kevin Tito on 7/5/18.
//  Copyright © 2018 Kevin Tito. All rights reserved.
//

import Foundation

class QuoteApi {
    static let baseurl = "https://talaikis.com/api"
    
    public static var getQuote: String {
        return "\(baseurl)/quotes/random/"
    }
    
    public static var getHundredQuotes: String {
        return "\(baseurl)/quotes/"
    }
}


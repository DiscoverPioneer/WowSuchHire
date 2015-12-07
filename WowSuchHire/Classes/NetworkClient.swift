//
//  NetworkClient.swift
//  WowSuchHire
//
//  Created by Phil Scarfi on 12/5/15.
//  Copyright © 2015 Pioneer Mobile Applications. All rights reserved.
//

import Foundation

public struct NetworkClient {

    ///Retrieve all quotes with no search criteria
    public func fetchAllQuotes(completion: (quotes:[Quote]?) -> Void) {
        let query = PFQuery(className: QuoteClassName)
        query.findObjectsInBackgroundWithBlock { objects, error in
            if let objects = objects {
                var quotes = [Quote]()
                for object in objects {
                    quotes.append(Quote(parseObject: object))
                }
                completion(quotes: quotes)
            } else {
                completion(quotes: nil)
            }
        }
    }

    ///Add a new quote to the database with a given string and return a quote object
    public func addQuote(quoteString: String, completion:(success: Bool, quote: Quote) -> Void) {
        let quoteObject = PFObject(className: QuoteClassName)
        quoteObject.setObject(quoteString, forKey: QuoteString)
        quoteObject.saveInBackgroundWithBlock { success, error in
            completion(success: success, quote:Quote(parseObject: quoteObject))
        }
    }
}

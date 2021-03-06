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
        quoteObject.setObject(quoteString, forKey: QuoteStringKey)
        quoteObject.saveInBackgroundWithBlock { success, error in
            completion(success: success, quote:Quote(parseObject: quoteObject))
        }
    }
    
    ///Add a new image as a quote object
    public func addImage(image: UIImage, completion:(success: Bool, quote: Quote?) -> Void) {
        var PhotoBackgroundTaskID:UIBackgroundTaskIdentifier?

         PhotoBackgroundTaskID = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({ () -> Void in
            UIApplication.sharedApplication().endBackgroundTask(PhotoBackgroundTaskID!)
        })

        let quoteObject = PFObject(className: QuoteClassName)
        
        guard let photoData = image.compressedImage() else {
            completion(success: false, quote: nil)
            return
        }
        let photoFile = PFFile(data: photoData)
        
        quoteObject[QuotePhotoFileKey] = photoFile
        
        quoteObject.saveInBackgroundWithBlock { (success, error) -> Void in
            if !success {
                print(error)
            }
            UIApplication.sharedApplication().endBackgroundTask(PhotoBackgroundTaskID!)
            let quote = Quote(parseObject: quoteObject)
            completion(success: success, quote: quote)
        }
    }
    
    ///Search for a quote containing a given string
    public func searchForQuote(quoteString: String, completion:(success: Bool, quotes: [Quote]) -> Void) {
        let query = PFQuery(className: QuoteClassName)
        query.whereKey(QuoteStringKey, containsString: quoteString)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            var quotes = [Quote]()
            if let objects = objects {
                for object in objects {
                    quotes.append(Quote(parseObject: object))
                }
                completion(success: true, quotes:quotes)
            } else {
                completion(success: false, quotes:quotes)
            }
        }
    }
    
    ///Delete a given quote from the database
    public func deleteQuote(quote: Quote, completion:(success: Bool) -> Void) {
        quote.parseObject.deleteInBackgroundWithBlock { (success, error) -> Void in
            completion(success: success)
        }
    }
}

//
//  Quote.swift
//  WowSuchHire
//
//  Created by Phil Scarfi on 12/5/15.
//  Copyright © 2015 Pioneer Mobile Applications. All rights reserved.
//

import Foundation

public let QuoteClassName = "Quote"
public let QuoteStringKey = "quoteString"
public let QuotePhotoFileKey = "photoFile"

public class Quote {
    
    public var quoteString: String? {
        get {
            return parseObject[QuoteStringKey] as? String
        }
    }
    
    public var dateCreated: NSDate? {
        get {
            return parseObject.createdAt
        }
    }
    
    public var squadQuote: String? {
        get {
            if var quote = quoteString {
                quote = quote.lowercaseString
                quote = quote.stringByReplacingOccurrencesOfString("squad", withString: "#squad")
                return quote
            }
            return nil
        }
    }
    
    public var hasPhoto: Bool {
        get {
            return parseObject[QuotePhotoFileKey] != nil
        }
    }
    
    private var photo: UIImage?
    
    public let parseObject: PFObject
    
    public init(parseObject: PFObject) {
        self.parseObject = parseObject
    }
    
    public func photo(completion:(photo: UIImage?) -> Void) {
        if let photo = self.photo {
            completion(photo: photo)
        } else if let file = parseObject[QuotePhotoFileKey] as? PFFile {
            file.getDataInBackgroundWithBlock({ (data, error) -> Void in
                if let data = data, image = UIImage(data: data) {
                    self.photo = image
                }
                completion(photo: self.photo)
            })
        } else {
            completion(photo: self.photo)
        }
    }
}

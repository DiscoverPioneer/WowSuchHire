//
//  Quote.swift
//  WowSuchHire
//
//  Created by Phil Scarfi on 12/5/15.
//  Copyright © 2015 Pioneer Mobile Applications. All rights reserved.
//

import Foundation

public let QuoteClassName = "Quote"
public let QuoteString = "quoteString"

public struct Quote {
    
    public var quoteString: String? {
        get {
            return parseObject[QuoteString] as? String
        }
    }
    
    public var dateCreated: NSDate? {
        get {
            return parseObject.createdAt
        }
    }
    
    public let parseObject: PFObject
    
    public init(parseObject: PFObject) {
        self.parseObject = parseObject
    }
}
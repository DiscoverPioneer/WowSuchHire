//
//  WowSuchHireTests.swift
//  WowSuchHireTests
//
//  Created by Phil Scarfi on 12/7/15.
//  Copyright © 2015 Pioneer Mobile Applications. All rights reserved.
//

import XCTest
@testable import WowSuchHire
import UIKit

class WowSuchHireTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTextFieldIsEmpty() {
        let emptyString = ""
        let textField = UITextField()
        textField.text = emptyString
        print("Hey")
        XCTAssertTrue(textField.isEmpty())
    }
    
    func testTextFieldIsNotEmpty() {
        let notEmptyString = "NotEmpty"
        let textField = UITextField()
        textField.text = notEmptyString
        XCTAssertFalse(textField.isEmpty())
    }
    
    func testQuoteHasNoPhoto() {
        let parseObj = PFObject(className: "Quote")
        parseObj[QuoteStringKey] = "WowSuchTests"
        let quote = Quote(parseObject: parseObj)
        XCTAssertFalse(quote.hasPhoto)
    }
    
    func testQuoteHasPhoto() {
        let parseObj = PFObject(className: "Quote")
        parseObj[QuotePhotoFileKey] = PFFile(data: NSData())
        let quote = Quote(parseObject: parseObj)
        XCTAssertTrue(quote.hasPhoto)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}

//
//  TextField+FieldChecking.swift
//  WowSuchHire
//
//  Created by Phil Scarfi on 12/6/15.
//  Copyright © 2015 Pioneer Mobile Applications. All rights reserved.
//

import Foundation
import UIKit

public extension UITextField {
    
    public func isEmpty() -> Bool {
        return text?.characters.count == 0
    }
}
//
//  BordedTextField.swift
//  WowSuchHire
//
//  Created by Phil Scarfi on 9/3/15.
//  Copyright (c) 2015 Pioneer Mobile Applications. All rights reserved.
//

import UIKit

public enum BorderTextFieldSides {
    case Left
    case Right
    case Top
    case Bottom
}

public class BorderTextField: UITextField {

    var sides = [BorderTextFieldSides.Bottom]
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.whiteColor().CGColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width:  frame.size.width, height: frame.size.height)
        
        border.borderWidth = width
        layer.addSublayer(border)
        layer.masksToBounds = true
    }
}

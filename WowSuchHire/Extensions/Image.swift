//
//  Image.swift
//  WowSuchHire
//
//  Created by Phil Scarfi on 8/20/15.
//  Copyright (c) 2015 Pioneer Mobile Applications. All rights reserved.
//

import Foundation

public extension UIImage {
    
    public func compressedImage() -> NSData? {
        let maxHeight: CGFloat = 500
        let maxWidth: CGFloat = 500
        
        var actualHeight = size.height
        var actualWidth = size.width
        
        var imageRatio = actualWidth/actualHeight
        let maxRatio = maxWidth / maxHeight
        
        if imageRatio != maxRatio {
            if imageRatio < maxRatio {
                imageRatio = maxHeight / size.height
                actualWidth = imageRatio * actualWidth
                actualHeight = maxHeight
            } else {
                imageRatio = maxWidth / size.width
                actualHeight = imageRatio * actualHeight
                actualWidth = maxWidth
            }
        }
        
        let rect = CGRectMake(0, 0, actualWidth, actualHeight)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        drawInRect(rect)
        let updatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImagePNGRepresentation(updatedImage)
    }
    
}
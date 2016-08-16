//
//  UIImageExtension.swift
//  iPose
//
//  Created by 王振宇 on 16/8/16.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import Foundation


extension UIImage {
    func normalizedImage() -> UIImage {
        
        print("\(imageOrientation.rawValue)")
        
        if imageOrientation == .Up { return self }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        drawInRect(CGRect(x: 0, y: 0 , width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
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

extension UIImage
{
    //棕褐色复古滤镜（老照片效果）
    func sepiaTone() -> UIImage?
    {
        let imageData = UIImagePNGRepresentation(self)
        let inputImage = CoreImage.CIImage(data: imageData!)
        let context = CIContext(options:nil)
        let filter = CIFilter(name:"CISepiaTone")
        filter!.setValue(inputImage, forKey: kCIInputImageKey)
        filter!.setValue(0.8, forKey: "inputIntensity")
        if let outputImage = filter!.outputImage {
            let outImage = context.createCGImage(outputImage, fromRect: outputImage.extent)
            return UIImage(CGImage: outImage)
        }
        return nil
    }
}

extension UIImage
{
    //黑白效果滤镜
    func noir() -> UIImage?
    {
        let imageData = UIImagePNGRepresentation(self)
        let inputImage = CoreImage.CIImage(data: imageData!)
        let context = CIContext(options:nil)
        let filter = CIFilter(name:"CIPhotoEffectNoir")
        filter!.setValue(inputImage, forKey: kCIInputImageKey)
        if let outputImage = filter!.outputImage {
            let outImage = context.createCGImage(outputImage, fromRect: outputImage.extent)
            return UIImage(CGImage: outImage)
        }
        return nil
    }
}

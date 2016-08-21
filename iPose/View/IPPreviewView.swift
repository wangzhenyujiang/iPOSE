//
//  IPPreviewView.swift
//  iPose
//
//  Created by 王振宇 on 16/8/19.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import UIKit
import AVFoundation

class IPPreviewView: UIView {
    var session: AVCaptureSession {
        set {
            let previewLayer = layer as! AVCaptureVideoPreviewLayer
            return previewLayer.session = newValue
        }
        get {
            let previewLayer = layer as! AVCaptureVideoPreviewLayer
            return previewLayer.session
        }
    }
    
    override class func layerClass() -> AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}

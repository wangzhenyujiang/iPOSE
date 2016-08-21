//
//  IPCameraViewController.swift
//  iPose
//
//  Created by 王振宇 on 16/8/19.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

enum IPCamSetupResult {
    case Success
    case NotAuthorized
    case Failed
}

class IPCameraViewController: UIViewController {
    @IBOutlet weak var previewView: IPPreviewView!
    
    //Session Management
    var sessionQueue: dispatch_queue_t!
    var session: AVCaptureSession!
    var videoDeviceInput: AVCaptureDeviceInput!
    var stillImageOutput: AVCaptureStillImageOutput!
    
    var sessionRunning: Bool = false
    var setupResult: IPCamSetupResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        dispatch_async(sessionQueue) { 
            if self.setupResult == .Success {
                self.session.startRunning()
                self.sessionRunning = true
            }
        }
    }
    override func viewDidDisappear(animated: Bool) {
        dispatch_async(sessionQueue) {
            if self.setupResult == .Success {
                self.session.stopRunning()
                self.sessionRunning = false
            }
        }
        super.viewDidDisappear(animated)
    }
}

//MARK: IBAction
extension IPCameraViewController {
    @IBAction func snapImage(sender: AnyObject) {
        snapStillImage()
    }
}

//MARK: Private
extension IPCameraViewController {
    private func commonInit() {
        session = AVCaptureSession()
        previewView.session = session
        sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL)
        setupResult = .Success
        
        switch AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) {
        case .Authorized:
            print("")
        case .NotDetermined:
            dispatch_suspend(sessionQueue)
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo) { granted in
                if !granted {
                    self.setupResult = .NotAuthorized
                }
                dispatch_resume(self.sessionQueue)
            }
        default:
            setupResult = .Failed
        }
        dispatch_async(sessionQueue) {
            if self.setupResult != .Success { return }
            let videoDevice = IPCameraViewController.device(AVMediaTypeVideo, position: .Back)
            guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
            self.session.beginConfiguration()
            if self.session.canAddInput(videoDeviceInput) {
                self.session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
                dispatch_async(dispatch_get_main_queue(), {
                    let statusBarOrientation = UIApplication.sharedApplication().statusBarOrientation
                    var initialVideoOrientation = AVCaptureVideoOrientation.Portrait
                    if ( statusBarOrientation.rawValue != UIInterfaceOrientation.Unknown.rawValue ) {
                        initialVideoOrientation = AVCaptureVideoOrientation(rawValue: statusBarOrientation.rawValue)!
                    }
                    let previewLayer = self.previewView.layer as! AVCaptureVideoPreviewLayer
                    previewLayer.connection.videoOrientation = initialVideoOrientation
                })
            }else {
                self.setupResult = .Failed
            }
            let stillOutput = AVCaptureStillImageOutput()
            if self.session.canAddOutput(stillOutput) {
//                self.stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
                self.session.addOutput(stillOutput)
                self.stillImageOutput = stillOutput
            }else {
                self.setupResult = .Failed
            }
            self.session.commitConfiguration()
        }
    }
    private func snapStillImage() {
        dispatch_async(sessionQueue) { 
            let connection = self.stillImageOutput.connectionWithMediaType(AVMediaTypeVideo)
            let previewLayer = self.previewView.layer as! AVCaptureVideoPreviewLayer
            
            connection.videoOrientation = previewLayer.connection.videoOrientation
            IPCameraViewController.setup(AVCaptureFlashMode.Off, device: self.videoDeviceInput.device)
            self.stillImageOutput.captureStillImageAsynchronouslyFromConnection(connection, completionHandler: { dataBuffer, error in
                guard let buffer = dataBuffer else { return }
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                PHPhotoLibrary.requestAuthorization({ status in
                    if status == PHAuthorizationStatus.Authorized {
                        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                            PHAssetCreationRequest.creationRequestForAsset().addResourceWithType(PHAssetResourceType.Photo, data: imageData, options: nil)
                            }, completionHandler: { success, error in
                        })
                    }
                })
            })
        }
    }
}

//MARK: Class Func
extension IPCameraViewController {
    class func device(mediaType: String, position: AVCaptureDevicePosition) -> AVCaptureDevice {
        let devices = AVCaptureDevice.devicesWithMediaType(mediaType)
        var captureDevice = devices.first
        for device in devices {
            if device.position == position {
                captureDevice = device
            }
        }
        return captureDevice as! AVCaptureDevice
    }
    class func setup(falshMode: AVCaptureFlashMode, device: AVCaptureDevice) {
        if device.hasFlash && device.isFlashModeSupported(falshMode) {
            do {
                try device.lockForConfiguration()
                device.flashMode = falshMode
                device.unlockForConfiguration()
            }catch let error {
                print("Could not lock device for configuration\(error)")
            }
        }
    }
}

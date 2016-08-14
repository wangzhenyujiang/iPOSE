//
//  CameraViewController.swift
//  iPose
//
//  Created by 王振宇 on 16/8/13.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import UIKit
import Kingfisher

class CameraViewController: UIViewController {

    @IBOutlet var cameraView: CameraSessionView!
    @IBOutlet weak var poseImageView: UIImageView!
    
    var poseItem: PoseItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCamera()        
        poseImageView.kf_setImageWithURL(NSURL(string: poseItem!.poseImage)!)
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    @IBAction func click(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func captureImage(sender: AnyObject) {
        cameraView.captureShutter()
    }
    
}

//MARK: CACameraSessionDelegate
extension CameraViewController: CACameraSessionDelegate {
    func didCaptureImage(image: UIImage!) {
        poseImageView.image = image
    }
}

//MARK: Private
extension CameraViewController {
    private func commonInit() {
        navigationController?.setToolbarHidden(true, animated: false)
    }
    private func addCamera() {
        cameraView.delegate = self
        cameraView.hideFlashButton()
        cameraView.hideDismissButton()
        cameraView.hideCameraToggleButton()
        cameraView.setTopBarColor(UIColor.clearColor())
    }
}

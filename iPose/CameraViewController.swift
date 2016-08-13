//
//  CameraViewController.swift
//  iPose
//
//  Created by 王振宇 on 16/8/13.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {

    @IBOutlet var cameraView: CameraSessionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCamera()
    }
}

//MARK: CACameraSessionDelegate
extension CameraViewController: CACameraSessionDelegate {
    
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

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
    @IBOutlet weak var collectionViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var poseItem: PoseItem {
        get {
            return dataSource[currentIndexPath.row]
        }
    }
    
    var currentIndexPath: NSIndexPath!
    var dataSource: [PoseItem] = []
    var isPoseViewHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCamera()
        commonInit()
        
        poseImageView.kf_setImageWithURL(NSURL(string: poseItem.poseImage)!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func prefersStatusBarHidden() -> Bool { return true }
    @IBAction func click(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func captureImage(sender: AnyObject) {
        cameraView.captureShutter()
    }
    @IBAction func poseItemsViewButtonClick(sender: AnyObject) {
        collectionViewHeightConstraints.constant = isPoseViewHidden ? 0 : 100
        UIView.animateWithDuration(0.25) { 
            self.view.layoutIfNeeded()
        }
        isPoseViewHidden = !isPoseViewHidden
    }
}

//MARK: CACameraSessionDelegate
extension CameraViewController: CACameraSessionDelegate {
    func didCaptureImage(image: UIImage!) {
        guard let controller  = storyboard?.instantiateViewController(FilterImageViewController) else { return }
        controller.image = image
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: Private
extension CameraViewController {
    private func commonInit() {
        navigationController?.setToolbarHidden(true, animated: false)
        collectionView.register(PoseImageCollectionCell)
        collectionView.backgroundColor = UIColor.clearColor()
    }
    private func addCamera() {
        cameraView.delegate = self
        cameraView.hideFlashButton()
        cameraView.hideDismissButton()
        cameraView.hideCameraToggleButton()
        cameraView.setTopBarColor(UIColor.clearColor())
    }
    private func configLayout() {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        flowLayout.minimumInteritemSpacing = Space
        flowLayout.minimumLineSpacing = Space
    }
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension CameraViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PoseImageCollectionCell
        cell.fillData(dataSource[indexPath.row])
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        currentIndexPath = indexPath
        poseImageView.kf_setImageWithURL(NSURL(string: poseItem.poseImage)!)
    }
}

//
//  CameraViewController.swift
//  iPose
//
//  Created by 王振宇 on 16/8/13.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import UIKit
import Kingfisher

private let itemWH: CGFloat = 80

class CameraViewController: IPViewController {
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.alpha = 0
            scrollView.delegate = self
        }
    }
    @IBOutlet weak var pageControl: UIPageControl! {
        didSet {
            pageControl.numberOfPages = 3
            pageControl.currentPage = Int(pageControl.numberOfPages) / 2
        }
    }
    @IBOutlet var cameraView: CameraSessionView!
    @IBOutlet weak var preImageView: UIImageView! {
        didSet {
            preImageView.kf_showIndicatorWhenLoading = true
        }
    }
    @IBOutlet weak var borderImageView: UIImageView! {
        didSet {
            borderImageView.kf_showIndicatorWhenLoading = true
        }
    }
    @IBOutlet weak var collectionViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var poseItem: PoseModelType {
        get {
            return dataSource[currentIndexPath.row]
        }
    }
    
    var currentIndexPath: NSIndexPath!
    var dataSource: [PoseModelType] = []
    var isPoseViewHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCamera()
        commonInit()

    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.setContentOffset(CGPoint(x: ScreenWidth, y: 0), animated: false)
        UIView.animateWithDuration(0.25) { 
            self.scrollView.alpha = 1
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func prefersStatusBarHidden() -> Bool { return true }
}

//MARK: IBAction
extension CameraViewController {
    @IBAction func camaeraClick(sender: AnyObject) {
        cameraView.captureToggle()
    }
    @IBAction func flashClick(sender: AnyObject) {
    }
    @IBAction func click(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func captureImage(sender: AnyObject) {
        cameraView.captureShutter()
    }
    @IBAction func poseItemsViewButtonClick(sender: AnyObject) {
        collectionViewHeightConstraints.constant = isPoseViewHidden ? 100 : 0
        UIView.animateWithDuration(0.25) {
            self.view.layoutIfNeeded()
        }
        isPoseViewHidden = !isPoseViewHidden
        updateCollectionViewOffset()
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
        collectionView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        preImageView.kf_setImageWithURL(NSURL(string: poseItem.preview)!)
        borderImageView.kf_setImageWithURL(NSURL(string: poseItem.poseImage)!)
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
        flowLayout.itemSize = CGSize(width: itemWH, height: itemWH)
        flowLayout.minimumInteritemSpacing = Space
        flowLayout.minimumLineSpacing = Space
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: Space, bottom: 10, right: Space)
    }
    private func updateCollectionViewOffset() {
        if CGFloat(currentIndexPath.row) * itemWH  > ScreenWidth {
            collectionView.contentOffset = CGPoint(x: CGFloat(currentIndexPath.row) * (itemWH + Space), y: 0)
        }
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
        preImageView.kf_setImageWithURL(NSURL(string: poseItem.poseImage)!)
    }
}

//MARK: UIScrollView
extension CameraViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            pageControl.currentPage = Int(scrollView.contentOffset.x / view.bounds.width)
        }
    }
}
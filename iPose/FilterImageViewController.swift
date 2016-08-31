//
//  FilterImageViewController.swift
//  iPose
//
//  Created by 王振宇 on 16/8/14.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import UIKit
import GPUImage
import CoreImage

private let itemW: CGFloat = 60
private let itemH: CGFloat = 100

class FilterImageViewController: IPViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var image: UIImage!
    
    var picture:PictureInput!
    var titles: [String] = ["朦胧", "黑白"]
    var filters: [() -> UIImage?] = [UIImage().sepiaTone, UIImage().noir]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

//MARK: Public
extension FilterImageViewController {
    
}

//MARK: Private 
extension FilterImageViewController {
    private func commonInit() {
        guard let temp = image else { return }
        imageView.image = temp.resize(CGSize(width: imageView.bounds.width * scale, height: imageView.bounds.height * scale))
        imageView.image = UIImage.fixOrientation(imageView.image)
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
//            if let image = self.imageView.image?.noir() {
//                dispatch_async(dispatch_get_main_queue(), {
//                    print("\(image.imageOrientation.rawValue)")
//                    self.imageView.image = image
//                })
//            }
//        }
        saveButton.backgroundColor = MainColor
        saveButton.border()
        saveButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        shareButton.backgroundColor = MainColor
        shareButton.border()
        shareButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        collectionView.register(FilterControllerCell)
        collectionView.backgroundColor = UIColor.clearColor()
        configLayout()
        title = "添加滤镜"
    }
    private func configLayout() {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: itemW, height: itemH)
        flowLayout.minimumInteritemSpacing = Space
        flowLayout.minimumLineSpacing = Space
    }
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension FilterImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as FilterControllerCell
        if indexPath.row == 0 {
            if let image = UIImage.fixOrientation(imageView.image).noir(){
                cell.imageView.image = image
            }
        }else if indexPath.row == 1 {
            if let image = UIImage.fixOrientation(imageView.image).sepiaTone(){
                cell.imageView.image = image
            }
        }
        cell.label.text = titles[indexPath.row]
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            if let image = UIImage.fixOrientation(imageView.image).noir(){
                imageView.image = image
            }
        }else if indexPath.row == 1 {
            if let image = UIImage.fixOrientation(imageView.image).sepiaTone(){
                imageView.image = image
            }
        }
    }
}

//MARK: IBAction
extension FilterImageViewController {
    @IBAction func shareActionClick() {
        let message = WXMediaMessage()
        
        let object = WXImageObject()
        object.imageData = UIImagePNGRepresentation(image!)
        message.mediaObject = object
        
        let request = SendMessageToWXReq()
        request.bText = false
        request.message = message
        request.scene = 1
        WXApi.sendReq(request)
    }
}

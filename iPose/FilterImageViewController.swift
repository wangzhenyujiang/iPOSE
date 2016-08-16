//
//  FilterImageViewController.swift
//  iPose
//
//  Created by 王振宇 on 16/8/14.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import UIKit
import GPUImage

private let itemWH: CGFloat = 100

class FilterImageViewController: IPViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    
    var picture:PictureInput!
    var filter:MonochromeFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        
        let tview: RenderView = RenderView(frame: self.view.bounds)
        view.addSubview(tview)
        picture = PictureInput(image:image!.normalizedImage())
        filter = MonochromeFilter()
        picture --> filter --> tview
        picture.processImage()
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
        imageView.image = temp
        title = "添加滤镜"
        collectionView.register(PoseImageCollectionCell)
        collectionView.backgroundColor = UIColor.clearColor()
        configLayout()
    }
    private func configLayout() {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: itemWH, height: itemWH)
        flowLayout.minimumInteritemSpacing = Space
        flowLayout.minimumLineSpacing = Space
    }
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension FilterImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PoseImageCollectionCell
        if let image = image {
            cell.imageView.image = image
        }
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
}

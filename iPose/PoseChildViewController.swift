//
//  PoseChildViewController.swift
//  iPose
//
//  Created by 王振宇 on 16/8/11.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

let Space: CGFloat = 8

protocol PoseChildViewControllerDelegate {
    func poseItemSelected(indexPath: NSIndexPath, poseList: [PoseModelType], controllerIndex: Int)
}

class PoseChildViewController: UIViewController {
    @IBOutlet weak var collection: UICollectionView! {
        didSet {
            collection.delegate = self
            collection.dataSource = self
        }
    }

    var index: Int = 0
    var dataSource = [PoseModelType]()
    
    var delegate: PoseChildViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

//MARK: Private 
extension PoseChildViewController {
    private func setupUI() {
        collection.register(PoseImageCollectionCell)
        view.backgroundColor = UIColor.whiteColor()
        collection.backgroundColor = UIColor.clearColor()
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        configLayout()
    }
    private func configLayout() {
        let flowLayout = collection.collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = (ScreenWidth - 4 * Space) / 3
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        flowLayout.minimumInteritemSpacing = Space
        flowLayout.minimumLineSpacing = Space
        flowLayout.sectionInset = UIEdgeInsets(top: Space, left: Space, bottom: 0, right: Space)
    }
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension PoseChildViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PoseImageCollectionCell
        cell.fillData(dataSource[indexPath.row])
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return dataSource.count
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.poseItemSelected(indexPath, poseList: dataSource,controllerIndex: index)
    }
}

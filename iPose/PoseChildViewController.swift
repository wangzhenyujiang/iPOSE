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
    var requestHelper: RequestHelperType!
    var index: Int = 0
    var dataSource = [PoseModelType]()
    var delegate: PoseChildViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

//MARK: Public 
extension PoseChildViewController {
    func getDataWith(requestHelper helper: RequestHelperType) {
        requestHelper = helper
        Alamofire.request(requestHelper.method, requestHelper.requestUrl, parameters: requestHelper.param, encoding: .URL, headers: nil).responseJSON { [weak self] response in
            guard let `self` = self else  { return }
            switch response.result {
            case .Success:
                guard let value = response.result.value else { return }
                self.dataSource = self.requestHelper.parserModel(JSON(value))
                self.collection.reloadData()
            case .Failure(let error):
                print(error)
            }
        }
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
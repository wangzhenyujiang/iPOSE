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

class PoseChildViewController: UIViewController {
    @IBOutlet weak var collection: UICollectionView!
    var dataSource = [PoseItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        Alamofire.request(.GET, "http://nahaowan.com/api/v2/haowan/pose/list").responseJSON {[weak self] response in
            guard let strongSelf = self else  { return }
            switch response.result {
            case .Success:
                guard let value = response.result.value else { return }
                for (_,subJson):(String, JSON) in JSON(value)["data"]["list"] {
                    guard let item = PoseItem(subJson) else { continue }
                    strongSelf.dataSource.append(item)
                }
                strongSelf.collection.reloadData()
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
        configLayout()
    }
    private func configLayout() {
        let flowLayout = collection.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
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
}

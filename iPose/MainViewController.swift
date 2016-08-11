//
//  ViewController.swift
//  iPose
//
//  Created by 王振宇 on 16/8/10.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SwiftyJSON

let Titles = ["推荐", "一人", "两人", "多人"]

class MainViewController: IPViewController {
    
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        Alamofire.request(.GET, "http://nahaowan.com/api/v2/haowan/pose/list").responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("JSON: \(json)")
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CategoryLabelCollectionCell
        cell.titleLabel.text = Titles[indexPath.row]
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Titles.count
    }
}

//MARK: Private 
extension MainViewController {
    private func setupUI() {
    }
}


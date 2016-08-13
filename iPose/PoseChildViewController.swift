//
//  PoseChildViewController.swift
//  iPose
//
//  Created by 王振宇 on 16/8/11.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import UIKit

class PoseChildViewController: UIViewController {
    @IBOutlet weak var collection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension PoseChildViewController {
    private func setupUI() {
        collection.register(PoseImageCollectionCell)
        view.backgroundColor = UIColor.blueColor()
        collection.backgroundColor = UIColor.clearColor()
        configLayout()
    }
    private func configLayout() {
        let flowLayout = collection.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: 100, height: 50)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
    }
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension PoseChildViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PoseImageCollectionCell
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return 10
    }
}

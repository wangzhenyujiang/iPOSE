//
//  ViewController.swift
//  iPose
//
//  Created by 王振宇 on 16/8/10.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

let Titles = ["推荐", "一人", "两人", "多人", "景色"]

class MainViewController: IPViewController {
    
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var controllers: [PoseChildViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        displayControllers()
    }
}

//MARK: PoseChildViewControllerDelegate
extension MainViewController: PoseChildViewControllerDelegate {
    func poseItemSelected(poseItem: PoseItem, controllerIndex: Int) {
        
    }
}

//MARK: UIScrollViewDelegate
extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let topContentSize = topCollectionView.contentSize
        let contentScrollViewSize = scrollView.contentSize
        var x = scrollView.contentOffset.x / contentScrollViewSize.width * topContentSize.width
        if abs(x) >= MainViewTopTitleItemViewWidth * CGFloat(Titles.count) {
            x = topContentSize.width
        }
        topCollectionView.contentOffset = CGPoint(x: x, y: 0)
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
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        showChildControllerByIndex(indexPath.row)
    }
}

//MARK: Private 
extension MainViewController {
    private func setupUI() {
        setupCollectionViewLatout()
    }
    private func displayControllers() {
        let contentSize = CGSize(width: ScreenWidth * CGFloat(Titles.count), height: scrollView.frame.height)
        scrollView.contentSize = contentSize
        
        var i: Int = 0
        var x: CGFloat = 0
        for _ in Titles {
            x = CGFloat(i) * ScreenWidth
            guard let controller = storyboard?.instantiateViewController(PoseChildViewController) else { return }
            addChildViewController(controller)
            controller.view.frame = CGRect(x: x, y: 0, width: ScreenWidth, height: scrollView.frame.height)
            scrollView.addSubview(controller.view)
            controller.didMoveToParentViewController(self)
            controller.index = i
            controller.delegate = self
            i = i + 1
        }
    }
    private func setupCollectionViewLatout() {
        let flowLayout = topCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: 100, height: 50)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
    }
    private func currentShowControllerIndex() -> Int {
        let contentOffset = scrollView.contentOffset
        let index = Int(contentOffset.y / ScreenWidth)
        return index
    }
    private func showChildControllerByIndex(index: Int) {
        if index == currentShowControllerIndex() { return }
        UIView.animateWithDuration(0.25) {
            self.scrollView.contentOffset = CGPoint(x: CGFloat(index) * ScreenWidth , y: 0)
        }
    }
}




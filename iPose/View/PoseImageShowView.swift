//
//  PoseImageShowView.swift
//  iPose
//
//  Created by 王振宇 on 16/8/27.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import UIKit

let PoseImageShowViewNotification = "PoseImageShowViewNotifications"

class PoseImageShowView: UIView {
    private static let shareInstance = PoseImageShowView()
    
    private var view: UIView!
    private var showing: Bool = false
    private var currentShowIndexPath: NSIndexPath?
    private var dataSource = [PoseModelType]() {
        didSet {
            guard let collection = collectionView else { return }
            collection.reloadData()
        }
    }
    
    @IBOutlet private weak var buttomView: UIView! {
        didSet {
            buttomView.backgroundColor = UIColor.clearColor()
        }
    }
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.showsVerticalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.backgroundColor = UIColor.clearColor()
            collectionView.pagingEnabled = true
            collectionView.register(PoseImageCollectionCell)
        }
    }

    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight))
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        configCollectionLayout()
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        PoseImageShowView.hide()
    }
}

//MARK: Public
extension PoseImageShowView  {
    class func show(currentIndex: NSIndexPath, items: [PoseModelType]) {
        if shareInstance.showing || items.count == 0 {
            PoseImageShowView.hide()
            return
        }
        shareInstance.alpha = 0
        UIView.animateWithDuration(0.25, animations: {
            shareInstance.alpha = 1
            shareInstance.dataSource = items
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue()) {
                shareInstance.collectionView.scrollToItemAtIndexPath(currentIndex, atScrollPosition: .CenteredHorizontally, animated: false)
            }
        })
        UIApplication.sharedApplication().keyWindow?.addSubview(shareInstance)
        shareInstance.showing = true
        shareInstance.currentShowIndexPath = currentIndex
    }
    class func hide() {
        if !shareInstance.showing { return }
        UIView.animateWithDuration(0.25, animations: {
            shareInstance.alpha = 0
            }) { finished in
                shareInstance.removeFromSuperview()
                shareInstance.alpha = 1
                shareInstance.showing = false
                shareInstance.currentShowIndexPath = nil
        }
    }
}

//MARK: Private
extension PoseImageShowView {
    private func commonInit() {
        backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        let contentFrame = CGRectMake(0, 0, ScreenWidth, ScreenWidth * 4 / 3)
        view = NSBundle.mainBundle().loadNibNamed(String(PoseImageShowView), owner: self, options: nil).first as! UIView
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        view.frame = contentFrame
        view.center = center
        view.backgroundColor = UIColor.clearColor()
        addSubview(view)
    }
    private func configCollectionLayout() {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .Horizontal
        flowLayout.itemSize = CGSize(width: bounds.width - 2 * Space, height: bounds.height)
        flowLayout.minimumInteritemSpacing = 2 * Space
        flowLayout.minimumLineSpacing = 2 * Space
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: Space, bottom: 0, right: Space)
    }
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension PoseImageShowView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PoseImageCollectionCell
        cell.fillData(dataSource[indexPath.row])
        return cell
    }
}

//MARK: UIScrollViewDelegate
extension PoseImageShowView: UIScrollViewDelegate {
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let index = collectionView.indexPathForItemAtPoint(collectionView.convertPoint(center, fromView: self))
            guard let indexPath = index else { return }
            currentShowIndexPath = indexPath
        }
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = collectionView.indexPathForItemAtPoint(collectionView.convertPoint(center, fromView: self))
        guard let indexPath = index else { return }
        currentShowIndexPath = indexPath
    }
}

//MARK: IBAction
extension PoseImageShowView {
    @IBAction private func crameaButtonClick(sender: AnyObject) {
        guard let index = currentShowIndexPath else { return }
        PoseImageShowView.hide()
        let arr = dataSource.map() {item in
            return item.preview
        }
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: PoseImageShowViewNotification, object: nil, userInfo: ["indexPath": index, "dataList": arr]))
    }
    @IBAction private func saveButtonClick(sender: AnyObject) {
        
    }
}
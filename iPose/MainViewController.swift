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

let Titles = ["推荐", "个人", "双人", "小团体", "大团体"]

class MainViewController: IPViewController {
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let requestHelpers: [RequestHelperType] = [MyHotRequestHelpers(), SinRequestHelper(), DouRequestHelper(), SmaRequestHelper(), BigRequestHelper()]
    
    var dataSource = [PoseModelType]()
    var controllers: [PoseChildViewController] = []
    
    var locService: BMKLocationService!
    var searcher: BMKGeoCodeSearch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addObsever()
        
        locService = BMKLocationService()
        locService.delegate = self
        locService.startUserLocationService()
       
        searcher = BMKGeoCodeSearch()
        searcher.delegate = self
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        locService.delegate = self
        searcher.delegate = self
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        locService.delegate = nil
        searcher.delegate = nil
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        displayControllers()
    }
    deinit {
        removeOberver()
    }
}

//MARK: IBAction
extension MainViewController {
    @IBAction func mainViewCaptureButtonAction(sender: AnyObject) {
        let wxReq = SendMessageToWXReq()
        wxReq.text = "iPOSE 分享"
        wxReq.bText = true
        wxReq.scene = 1
        WXApi.sendReq(wxReq)
    }
}

//MARK: BMKLocationServiceDelegate
extension MainViewController: BMKLocationServiceDelegate {
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        locService.delegate = nil
        
        let pt = CLLocationCoordinate2D(latitude: userLocation.location.coordinate.latitude, longitude: userLocation.location.coordinate.longitude)
        let reserseGeoCodeSearchOption = BMKReverseGeoCodeOption()
        reserseGeoCodeSearchOption.reverseGeoPoint = pt
        let flag = searcher.reverseGeoCode(reserseGeoCodeSearchOption)
        if flag {
            print("反 GEO 检索发送成功")
        }else {
            print("反 GEO 检索发送失败")
        }
    }
}

//MARK: BMKGeoCodeSearchDelegate
extension MainViewController: BMKGeoCodeSearchDelegate {
    func onGetReverseGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if error == BMK_SEARCH_NO_ERROR {
            print(result.address)
            title = result.address
        }else {
            print("Sorrt no result founded")
        }
    }
}

//MARK: PoseChildViewControllerDelegate
extension MainViewController: PoseChildViewControllerDelegate {
    func poseItemSelected(indexPath: NSIndexPath, poseList: [PoseModelType],controllerIndex: Int) {
        PoseImageShowView.show(indexPath,items: poseList)
    }
}

//MARK: UIScrollViewDelegate
extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == self.scrollView {
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
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        showChildControllerByIndex(indexPath.row)
    }
}

//MARK: Private 
extension MainViewController {
    private func setupUI() {
        setupCollectionViewLatout()
        automaticallyAdjustsScrollViewInsets = false
    }
    private func displayControllers() {
        if controllers.count > 0 { return }
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
            controllers.append(controller)
            i = i + 1
        }
        showChildControllerContent()
    }
    private func showChildControllerContent() {
        var index = 0
        for controller in controllers {
            controller.getDataWith(requestHelper: requestHelpers[index])
            index += 1
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
        UIView.animateWithDuration(0.25) {
            self.scrollView.contentOffset = CGPoint(x: CGFloat(index) * ScreenWidth , y: 0)
        }
    }
    private func addObsever() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(poseViewCallback(_:)), name: PoseImageShowViewNotification, object: nil)
    }
    private func removeOberver() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

//MARK: Selector
extension MainViewController {
    @objc private func poseViewCallback(notification: NSNotification) {
        guard let controller = storyboard?.instantiateViewController(CameraViewController) else { return }
        let dic = notification.userInfo! as NSDictionary
        controller.currentIndexPath = dic["indexPath"] as! NSIndexPath
        controller.dataSource = dataSource
        let nav = UINavigationController(rootViewController: controller)
        presentViewController(nav, animated: true, completion: nil)
    }
}
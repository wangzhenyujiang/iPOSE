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

let Titles = ["推荐", "附近","自拍", "双人", "团体", "收藏"]

class MainViewController: IPViewController {
   
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    private var segementView: XFSegementView!
    
    let requestHelpers: [RequestHelperType] = [HotRequestHelper(), LocationRequestHelper(), SinRequestHelper(), DouRequestHelper(), SmaRequestHelper(), SaveRequestHelper()]
    
    var dataSource = [PoseModelType]()
    var controllers: [PoseChildViewController] = []
    
    var locService: BMKLocationService!
    var searcher: BMKGeoCodeSearch!
    private var currentChildControllerIndex: Int = 0
    
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

//MARK: UIScrollViewDelegate
extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / ScreenWidth)
        if scrollView == self.scrollView && currentChildControllerIndex != index {
            currentChildControllerIndex = index
            segementView.selectLabelWithIndex(index)
        }
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

//MARK: TouchLabelDelegate
extension MainViewController: TouchLabelDelegate {
    func touchLabelWithIndex(index: Int) {
        if currentChildControllerIndex == index { return }
        currentChildControllerIndex = index
        showChildControllerByIndex(index)
    }
}

//MARK: BMKGeoCodeSearchDelegate
extension MainViewController: BMKGeoCodeSearchDelegate {
    func onGetReverseGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if error == BMK_SEARCH_NO_ERROR {
            print("\(result.address)")
        }else {
            print("Sorrt no result founded")
        }
    }
}

//MARK: PoseChildViewControllerDelegate
extension MainViewController: PoseChildViewControllerDelegate {
    func poseItemSelected(indexPath: NSIndexPath, poseList: [PoseModelType],controllerIndex: Int) {
        dataSource = poseList
        PoseImageShowView.show(indexPath,items: poseList)
    }
}

//MARK: Private 
extension MainViewController {
    private func setupUI() {
        setupSegementView()
        automaticallyAdjustsScrollViewInsets = false
    }
    private func setupSegementView() {
        segementView = XFSegementView(frame: CGRectMake(0, 0, ScreenWidth, 50))
        segementView.titleArray = Titles
        segementView.scrollLine.backgroundColor = MainColor
        segementView.titleSelectedColor = MainColor
        segementView.touchDelegate = self
        topView.addSubview(segementView)
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
            controller.index = i
            controller.delegate = self
            controller.requestHelper = requestHelpers[i]
            controllers.append(controller)
            addChildViewController(controller)
            controller.view.frame = CGRect(x: x, y: 0, width: ScreenWidth, height: scrollView.frame.height)
            scrollView.addSubview(controller.view)
            controller.didMoveToParentViewController(self)
            i = i + 1
        }
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(poseViewCallback(_:)), name: PoseImageShowViewCrameaButtonClickNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(poseViewSaveButtonCallback(_:)), name: PoseImageShowViewSaveButtonClickNotification, object: nil)
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
    @objc private func poseViewSaveButtonCallback(notification: NSNotification) {
       controllers.last?.startRequest()
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
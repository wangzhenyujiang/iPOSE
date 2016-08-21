//
//  AppDelegate.swift
//  iPose
//
//  Created by 王振宇 on 16/8/10.
//  Copyright © 2016年 王振宇. All rights reserved.
//

let weixinKey = "wx2ce113b555a78738"

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BMKGeneralDelegate {

    var window: UIWindow?
    var _mapManager: BMKMapManager?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        
        //WX
        WXApi .registerApp("wx2ce113b555a78738")
        
        //Baidu map
        _mapManager = BMKMapManager()
        let ret = _mapManager?.start("qNKq8qwjF6CPphYA1OuOxqijKqwdylyx", generalDelegate: self)
        if ret == false {
            print("Manager Start Failed")
        }
        return true
    }
}

//MARK: WXApiDelegate
extension AppDelegate: WXApiDelegate {
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return WXApi.handleOpenURL(url, delegate: self)
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        return WXApi.handleOpenURL(url, delegate: self)
    }
    func onReq(req: BaseReq!) {
        
    }
    func onResp(resp: BaseResp!) {
        
    }
}


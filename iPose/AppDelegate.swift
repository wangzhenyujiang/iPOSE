//
//  AppDelegate.swift
//  iPose
//
//  Created by 王振宇 on 16/8/10.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BMKGeneralDelegate {
    var window: UIWindow?
    var mapManager: BMKMapManager?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UINavigationBar.appearance().barTintColor = MainColor
        setupSDK()
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
}

//MARK: SDK
extension AppDelegate {
    private func setupSDK() {
        setupWXApi()
        setupBaiduMap()
    }
    private func setupBaiduMap() {
        mapManager = BMKMapManager()
        let ret = mapManager?.start(baiduMapKey, generalDelegate: self)
        if ret == false {
            print("Manager Start Failed")
        }
    }
    private func setupWXApi() {
        WXApi.registerApp(weixinKey)
    }
}
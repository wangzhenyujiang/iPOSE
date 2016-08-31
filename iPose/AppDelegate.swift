//
//  AppDelegate.swift
//  iPose
//
//  Created by 王振宇 on 16/8/10.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BMKGeneralDelegate {
    var window: UIWindow?
    var mapManager: BMKMapManager?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UINavigationBar.appearance().barTintColor = MainColor
        setupSDK()
        registerForPushNotifications(application)
        return true
    }
}

//MARK: APNs
extension AppDelegate {
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        print("Device Token:", tokenString)
        Alamofire.request(.POST, "http://iposeserverbae.duapp.com/reportid.do", parameters: ["devicesid": tokenString], encoding: .JSON, headers: nil).responseJSON { response in
            print("sdasdf")
            switch response.result {
            case .Success(let value):
                print("\(JSON(value))")
            case .Failure(let err):
                print("ERROR \(err)")
            }
        }
    }
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
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
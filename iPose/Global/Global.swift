//
//  Global.swift
//  iPose
//
//  Created by 王振宇 on 16/8/13.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import UIKit

let scale = UIScreen.mainScreen().scale

let MainColor = UIColor(red: 0.94, green: 0.33, blue: 0.32, alpha: 1)

let weixinKey = "wx2ce113b555a78738"
let baiduMapKey = "qNKq8qwjF6CPphYA1OuOxqijKqwdylyx"

let ScreenWidth = UIScreen.mainScreen().bounds.width
let ScreenHeight = UIScreen.mainScreen().bounds.height

let MainViewTopTitleItemViewWidth: CGFloat = 100

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}
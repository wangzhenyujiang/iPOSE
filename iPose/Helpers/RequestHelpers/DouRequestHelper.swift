//
//  DouRequestHelper.swift
//  iPose
//
//  Created by 王振宇 on 16/8/28.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import Foundation

class DouRequestHelper: GetPicsRequestHelper {
    override init() {
        super.init()
        self.param = ["peopleNumber": "dou"]
    }
}
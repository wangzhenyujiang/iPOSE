//
//  LocationRequestHelper.swift
//  iPose
//
//  Created by 王振宇 on 16/8/31.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import Alamofire

class LocationRequestHelper: GetPicsRequestHelper {
    override init() {
        super.init()
        self.encoding = Alamofire.ParameterEncoding.JSON
        self.param = ["location": "北京市海淀区知春路"]
        self.requestUrl = "http://iposeserverbae.duapp.com/GetLocationPic.do"
    }
}

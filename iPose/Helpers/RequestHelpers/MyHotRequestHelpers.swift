//
//  MyHotRequestHelpers.swift
//  iPose
//
//  Created by 王振宇 on 16/8/28.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyHotRequestHelpers: NSObject {
    var requestUrl: String = "http://nahaowan.com/api/v2/haowan/pose/list"
    var param: [String : AnyObject] = [:]
    var method: Alamofire.Method = .GET
}

extension MyHotRequestHelpers: RequestHelperType {
    func parserModel(json: JSON) -> [PoseModelType] {
        var dataSource = [PoseModelType]()
        for (_,subJson):(String, JSON) in json["data"]["list"] {
            guard let item = PoseModel(info: subJson) else { continue }
            dataSource.append(item)
        }
        return dataSource
    }
}
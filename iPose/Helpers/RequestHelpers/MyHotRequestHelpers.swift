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
    var encoding: ParameterEncoding = .JSON

}

extension MyHotRequestHelpers: RequestHelperType {
    func parserModel(json: JSON) -> [PoseModelType] {
        var dataSource = [PoseModelType]()
        for (_,subJson):(String, JSON) in json["data"]["list"] {
            guard let item = PoseItem(subJson) else { continue }
            dataSource.append(item)
        }
        return dataSource
    }
    func startRequest(complationHandler: (Bool, [PoseModelType]) -> Void) {
        Alamofire.request(method, requestUrl).responseJSON {[weak self] response in
            guard let `self` = self else  { return }
            switch response.result {
            case .Success:
                guard let value = response.result.value else { return }
                complationHandler(true, self.parserModel(JSON(value)))
            case .Failure( _):
                complationHandler(false, [])
            }
        }
    }
}
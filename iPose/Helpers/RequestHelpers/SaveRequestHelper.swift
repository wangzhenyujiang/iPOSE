//
//  SaveRequestHelper.swift
//  iPose
//
//  Created by 王振宇 on 16/8/29.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SaveRequestHelper {
    var requestUrl: String = "http://iposeserverbae.duapp.com/GetPics.do"
    var param: [String : AnyObject] = [:]
    var method: Alamofire.Method = .POST
    var encoding: ParameterEncoding = .URL
}

extension SaveRequestHelper: RequestHelperType {
    func parserModel(json: JSON) -> [PoseModelType] {
        return []
    }
    func startRequest(complationHandler: (Bool, [PoseModelType]) -> Void) {
        let arr = StoreupHelpers.saveModelArray()
        if arr.count > 0 {
            complationHandler(true, arr)
        }else {
            complationHandler(false, [])
        }
    }
}
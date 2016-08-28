//
//  SinRequestHelper.swift
//  iPose
//
//  Created by 王振宇 on 16/8/28.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class GetPicsRequestHelper: NSObject {
    var requestUrl: String = "http://iposeserverbae.duapp.com/GetPics.do"
    var param: [String : AnyObject] = [:]
    var method: Alamofire.Method = .POST
    var encoding: ParameterEncoding = .URL
}

//MARK: RequestHelpers 
extension GetPicsRequestHelper: RequestHelperType {
    func parserModel(json: JSON) -> [PoseModelType] {
        var dataSource = [PoseModelType]()
        for (_,subJson):(String, JSON) in json["pictures"] {
            guard let item = PoseModel(info: subJson) else { continue }
            dataSource.append(item)
        }
        return dataSource
    }
    func startRequest(complationHandler: (Bool, [PoseModelType]) -> Void) {
        Alamofire.request(method, requestUrl, parameters: param, encoding: encoding, headers: nil).responseJSON { [weak self] response in
            guard let `self` = self else  { return }
            switch response.result {
            case .Success:
                guard let value = response.result.value else { return }
                complationHandler(true, self.parserModel(JSON(value)))
            case .Failure(_):
                complationHandler(false, [])
            }
        }
    }
}
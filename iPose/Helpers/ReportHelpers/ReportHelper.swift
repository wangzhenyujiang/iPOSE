//
//  ReportHelper.swift
//  iPose
//
//  Created by 王振宇 on 16/8/31.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ReportHelper: NSObject {}

extension ReportHelper {
    class func reportDeviceToken(deviceToken: String) {
        Alamofire.request(.POST, "http://iposeserverbae.duapp.com/reportid.do", parameters: ["devicesid": deviceToken], encoding: .JSON, headers: nil).responseJSON { response in
            switch response.result {
            case .Success(let value):
                print("\(JSON(value))")
            case .Failure(let err):
                print("ERROR \(err)")
            }
        }
    }
    class func reportHotPictureId(pictureID: Int) {
        Alamofire.request(.POST, "http://iposeserverbae.duapp.com/HotReport.do", parameters: ["pictureID":"\(pictureID)"], encoding: .URL, headers: nil).responseJSON { response in
            switch response.result {
            case .Success(let value):
                print("\(JSON(value))")
            case .Failure(let err):
                print("ERROR \(err)")
            }
        }
    }
}
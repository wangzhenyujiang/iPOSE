//
//  RequestHelpers.swift
//  iPose
//
//  Created by 王振宇 on 16/8/28.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol RequestHelperType {
    var requestUrl: String { get set }
    var param: [String: AnyObject] { get set }
    var method: Alamofire.Method { get set }
    var encoding: ParameterEncoding { get set }
    func parserModel(json: JSON) -> [PoseModelType]
    func startRequest(complationHandler: (Bool, [PoseModelType]) -> Void) 
}
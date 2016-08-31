//
//  PoseModelType.swift
//  iPose
//
//  Created by 王振宇 on 16/8/27.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import Foundation

protocol PoseModelType {
    var pictureID: Int { get }
    var preview: String { get }
    var poseImage: String { get }
    var suoluetuurl: String { get }
}
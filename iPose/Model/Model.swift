//
//  Model.swift
//  iPose
//
//  Created by 王振宇 on 16/8/13.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PoseItem {
    let author: String
    let category: String
    let createTime: String
    let description: String
    let id: Int
    let name: String
    let poseHeight: Int
    let poseImage: String
    let poseOrientation: Int
    let poseWidth: Int
    let preview: String
    let tipsImage: String
    
    init?(_ info: JSON) {
        guard let author = info["author"].string else { return nil}
        guard let category = info["category"].string else { return nil }
        guard let createTime = info["create_time"].string else { return nil }
        guard let description = info["description"].string else { return nil }
        guard let id = info["id"].int else { return nil }
        guard let name = info["name"].string else { return nil }
        guard let poseHeight = info["pose_height"].int else { return nil }
        guard let poseImage = info["pose_image"].string else { return nil }
        guard let poseOrientation = info["pose_orientation"].int else { return nil }
        guard let poseWidth = info["pose_width"].int else { return nil }
        guard let preview = info["preview"].string else { return nil }
        guard let tipsImage = info["tips_image"].string else { return nil }
        self.author = author
        self.category = category
        self.createTime = createTime
        self.description = description
        self.id = id
        self.name = name
        self.poseHeight = poseHeight
        self.poseImage = poseImage
        self.poseOrientation = poseOrientation
        self.poseWidth = poseWidth
        self.preview = preview
        self.tipsImage = tipsImage
    }
}
//
//  ImageFilterable.swift
//  iPose
//
//  Created by 王振宇 on 16/8/30.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import Foundation
import GPUImage

protocol ImageFilterable {}

extension ImageFilterable {
    func filter(image: UIImage, filter: BasicOperation, completionHahdler: ((UIImage) -> ())? = nil) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let toonFilter = SmoothToonFilter()
            let filteredImage = image.filterWithOperation(toonFilter)
            dispatch_async(dispatch_get_main_queue(), {
                guard let hander = completionHahdler else { return }
                hander(filteredImage)
            })
        }
    }
}
//
//  StoryBoardExtension.swift
//  iPose
//
//  Created by 王振宇 on 16/8/13.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import UIKit

extension UIStoryboard {
    func instantiateViewController<T: UIViewController where T : ResuableView>(type: T.Type) -> T {
        let controller = instantiateViewControllerWithIdentifier(type.storyBoardID) as! T
        return controller
    }
}

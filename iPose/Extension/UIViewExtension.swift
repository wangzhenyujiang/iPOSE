//
//  UIViewExtension.swift
//  iPose
//
//  Created by 王振宇 on 16/9/1.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import Foundation

extension UIView {
    func border() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
}
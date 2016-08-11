//
//  UICollectionViewExtension.swift
//  iPose
//
//  Created by 王振宇 on 16/8/11.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell where T: ResuableView, T: NibLoadableView>(_: T.Type) {
        let Nib = UINib(nibName: T.NibName, bundle: nil)
        registerNib(Nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell where T: ResuableView>(forIndexPath indexPath: NSIndexPath) -> T {
        guard let cell = dequeueReusableCellWithReuseIdentifier(T.reuseIdentifier, forIndexPath: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}
//
//  PoseImageCollectionCell.swift
//  iPose
//
//  Created by 王振宇 on 16/8/11.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import UIKit
import Kingfisher

class PoseImageCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = UIColor.clearColor()
        imageView.backgroundColor = UIColor.clearColor()
        imageView.kf_showIndicatorWhenLoading = true
    }
}

extension PoseImageCollectionCell: ImageFilterable {}

extension PoseImageCollectionCell {
    func fillData(url: String) {
        guard let url = NSURL(string: url) else { return }
        imageView.kf_setImageWithURL(url)
    }
    func fillData(item: PoseModelType) {
        guard let url = NSURL(string: item.preview) else { return }
        imageView.kf_setImageWithURL(url)
    }
    func fillImage(image: UIImage) {
        imageView.image = image
    }
}
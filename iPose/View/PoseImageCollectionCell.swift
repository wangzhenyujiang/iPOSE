//
//  PoseImageCollectionCell.swift
//  iPose
//
//  Created by 王振宇 on 16/8/11.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import UIKit
import Kingfisher

private let placeholderImage = "placeholderImage"

class PoseImageCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = UIColor.clearColor()
        imageView.backgroundColor = UIColor.clearColor()
        imageView.kf_showIndicatorWhenLoading = true
    }
}

//MARK: Public
extension PoseImageCollectionCell {
    func fillData(url: String) {
        guard let url = NSURL(string: url) else { return }
        fillImageWith(url)
    }
    func fillData(item: PoseModelType) {
        guard let url = NSURL(string: item.suoluetuurl) else { return }
        fillImageWith(url)
    }
    func fillImage(image: UIImage) {
        imageView.image = image
    }
}

//MARK: Private
extension PoseImageCollectionCell {
    private func fillImageWith(url: NSURL) {
        imageView.kf_setImageWithURL(url, placeholderImage: nil, optionsInfo: [KingfisherOptionsInfoItem.Transition(ImageTransition.Fade(0.5))], progressBlock: nil, completionHandler: nil)
    }
}
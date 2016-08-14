//
//  FilterImageViewController.swift
//  iPose
//
//  Created by 王振宇 on 16/8/14.
//  Copyright © 2016年 王振宇. All rights reserved.
//

import UIKit

class FilterImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let temp = image else { return }
        imageView.image = temp
        title = "添加滤镜"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

//MARK: Public
extension FilterImageViewController {

}

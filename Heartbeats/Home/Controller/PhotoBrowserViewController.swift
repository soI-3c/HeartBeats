//
//  PhotoBrowserViewController.swift
//  Heartbeats
//
//  Created by iOS-3C on 16/3/20.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

//MARK: -- 首页图片游览器
class PhotoBrowserViewController: UIViewController {
    lazy var imgView: UIImageView = UIImageView()
    var showImage: UIImage? {
        didSet {
            if showImage != nil {
                imgView.image = showImage
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        setupUI()
    }
    private func setupUI() {
        view.addSubview(imgView)
        imgView.frame = view.bounds
        imgView.contentMode = UIViewContentMode.ScaleAspectFit
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

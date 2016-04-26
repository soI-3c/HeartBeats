//
//  DynamicCutOffImgController.swift
//  Heartbeats
//
//  Created by liaosenshi on 16/4/26.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

/* 截取图片 */
class DynamicCutOffImgController: UIViewController, UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        setUpUI()
    }
    
    func setUpUI() {
        imgScrollView.delegate = self
        view.addSubview(imgScrollView)
        imgScrollView.addSubview(imgView)
    }

   lazy var imgScrollView: UIScrollView = {
        let scroView = UIScrollView()
        scroView.minimumZoomScale = 1.0
        scroView.maximumZoomScale = 2.0
        scroView.frame = self.view.bounds
        return scroView
    }()
    
    lazy var imgView: UIImageView = {
       let imgV = UIImageView()
        imgV.contentMode = UIViewContentMode.ScaleAspectFit
        imgV.frame = self.imgScrollView.bounds
        imgV.image = self.img
        return imgV
    }()
    var img: UIImage? {
        didSet {
            imgScrollView.contentSize = img!.size
        }
    }
}

extension DynamicCutOffImgController {
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imgView
    }
    func scrollViewDidZoom(scrollView: UIScrollView) {
        var XCenter = scrollView.center.x
        var YCenter = scrollView.center.y
        XCenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width / 2 : XCenter
        YCenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height / 2 : YCenter
        imgView.center = CGPointMake(XCenter, YCenter)
    }
}

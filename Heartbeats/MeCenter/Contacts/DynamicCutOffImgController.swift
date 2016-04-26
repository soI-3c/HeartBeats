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

//    MARK : -- override
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        setUpUI()
    }
    
//    MARK: -- private func
   private func setUpUI() {
        view.addSubview(imgScrollView)
        imgScrollView.addSubview(imgView)
        view.addSubview(cuttOffView)
        view.addSubview(cuttOffBtn)
    
        view.backgroundColor = UIColor.blackColor()
        cuttOffView.frame = view.bounds
        cuttOffBtn.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(view).offset(-8)
            make.bottom.equalTo(view).offset(-8)
            make.height.width.equalTo(60)
        }
    }
    
    /// 重置 scrollView 的内容属性，因为缩放会影响到内容属性
    private func resetScrollView() {
        imgScrollView.contentSize = CGSizeZero
        imgScrollView.contentInset = UIEdgeInsetsZero
        imgScrollView.contentOffset = CGPointZero
    }
    
    /// 设置图像位置
    /**
        长短图
    
        如果图像缩放之后，没有屏幕高，显示在中间
        否则，显示在顶部，并且设置 contentSize 允许滚动
    */
    private func setImagePosition() {
        let size = displaySize(imgView.image!)
        imgView.frame = CGRect(origin: CGPointZero, size: size)
        // 短图
        if size.height < imgScrollView.bounds.height {
            let y = (imgScrollView.bounds.height - size.height) * 0.5
            // 设置边距的最大好处，缩放之后，能够自动调整 contentSize，能够保证滚动看到边界
            imgScrollView.contentInset = UIEdgeInsets(top: y, left: 0, bottom: 0, right: 0)
        } else {    // 长图
            
            imgScrollView.contentSize = size
        }
    }
    /// 按照 scrollView 的宽度，计算缩放后的比例
    private func displaySize(image: UIImage) -> CGSize {
        // 1. 图像宽高比
        let scale = image.size.height / image.size.width
        // 2. 计算高度
        let w = imgScrollView.bounds.width
        let h = w * scale
        return CGSize(width: w, height: h)
    }

//    MARK: -- getter / setter
    lazy var imgScrollView: UIScrollView = {
        let scroView = UIScrollView()
        scroView.delegate = self
        scroView.minimumZoomScale = 1.0
        scroView.maximumZoomScale = 4.0
        scroView.frame = CGRectMake(0, 0, screenMaimWidth, screenMaimheiht - 64)
        return scroView
    }()
    
    lazy var imgView: UIImageView = UIImageView()
    
    var img: UIImage? {
        didSet {
            // 重置 scrollView
//            resetScrollView()
            imgView.image = nil                 // 解决复用
            imgView.image = img
            setImagePosition()
        }
    }
    lazy var cuttOffView: UIView = {            // 剪裁框
        let view = UIView()
        view.userInteractionEnabled = false
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(rect: CGRectMake(2, (screenMaimheiht - 64 - screenMaimWidth) * 0.5, screenMaimWidth - 4, screenMaimWidth)).CGPath
        layer.fillColor = UIColor.clearColor().CGColor
        layer.strokeColor = UIColor.whiteColor().CGColor
        view.layer.addSublayer(layer)
        return view
    }()
    
    lazy var cuttOffBtn: UIButton = {
        let btn = UIButton()
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 60 / 2
        btn.backgroundColor = UIColor.whiteColor()
//        btn.setImage(UIImage(named: "camera"), forState: UIControlState.Normal)
        return btn
    }()
}

//MARK: -- delegate
extension DynamicCutOffImgController {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imgView
    }
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        // 调整 Y 值
        var offsetY = imgView.frame.origin.y - (screenMaimheiht - 64 - screenMaimWidth)
        // 调整 X 值
        var offsetX = (scrollView.bounds.width - imgView.frame.width) * 0.5
        let maxTopBottom = (screenMaimheiht - 64 - screenMaimWidth) * 0.5
        // 调整 offsetY 避免 < 0 之后，顶部内容看不到
        offsetY = (offsetY < 0) ? maxTopBottom : offsetY
        offsetX = (offsetX < 0) ? 0 : offsetX
        var offsetR = offsetX
        var offsetB = offsetY
        // 重新设置间距
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetB, right: offsetR)
    }
}

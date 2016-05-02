//
//  DynamicEditInfoController
//  Heartbeats
//
//  Created by iOS-3C on 16/4/30.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

/* 编辑图片, 添加文字..*/
class DynamicEditInfoController: UIViewController {
//    override
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        setUpUI()
    }
    
    private func setUpUI() {
        view.addSubview(imageView)                      // 图片
        view.addSubview(backImageView)                  // 背景的毛玻璃图片
        view.addSubview(imageFilterCollectionView)      // 滤镜图片
        view.addSubview(publicBtn)                      // 发布
        view.addSubview(feelView)                       // 表情
        
        imageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view)
            make.left.right.equalTo(self.view)
            make.height.equalTo(screenMaimWidth)
        }
        backImageView.frame = CGRectMake(0, screenMaimWidth, screenMaimWidth, screenMaimheiht - screenMaimWidth)
        
        imageFilterCollectionView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(imageView.snp_bottom)
            make.left.right.equalTo(backImageView)
            make.height.equalTo(92)
        }
        feelView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(imageFilterCollectionView.snp_bottom).offset(16)
            make.left.right.equalTo(imageFilterCollectionView).offset(CGPoint(x: 8, y: 0))
            make.height.equalTo(40)
        }
        publicBtn.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(view).offset(-8)
            make.bottom.equalTo(view).offset(-8)
            make.height.width.equalTo(60)
        }
        
//
        Tools.insertBlurView(backImageView, style: .ExtraLight)
    }
    
//    MARK:  -- private func
    func publicDynamic() {
        
    }
    
    
//    MARK: -- setter / getter
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .ScaleAspectFill
        return imgView
    }()
    private let backImageView: UIImageView = {                // 背景图片, 毛玻璃
        let backImageView = UIImageView()
        backImageView.image = placeholderImage
        return backImageView
    }()
    
    lazy var imageFilterCollectionView: ImageFilterCollectionView = {
        let imageFilterV = ImageFilterCollectionView()
        imageFilterV.selectImageFilter = {(name) -> Void in         // 对图片进行滤镜
            if name != self.imageFilterLastName {
                self.imageView.image = Tools().imgFilterEffect(self.image!, filterName: name)
                self.imageFilterLastName = name
            }
        }
        return imageFilterV
    }()
    var imageFilterLastName: String?           // 最后一次的滤镜名称, 如果重复的则不重复设置了(性能)
    
    lazy var publicBtn: UIButton = {           // 发布Btn
        let btn = UIButton()
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 60 / 2
        btn.setImage(UIImage(named: "u6"), forState: UIControlState.Normal)
        btn.addTarget(self, action: "publicDynamic", forControlEvents: .TouchUpInside)
        return btn
    }()
     var feelView = FeelingView()             // 表情View
}

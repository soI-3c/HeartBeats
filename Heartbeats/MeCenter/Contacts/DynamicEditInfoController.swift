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
        view.addSubview(imageView)
        view.addSubview(backImageView)
        view.addSubview(imageFilterCollectionView)
        view.addSubview(publicBtn)
        
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
        imageFilterV.selectImageFilter = {(name) -> Void in
            self.imageView.image = Tools().imgFilterEffect(self.image!, filterName: name)
        }
        return imageFilterV
    }()
    
    lazy var publicBtn: UIButton = {           // 发布Btn
        let btn = UIButton()
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 60 / 2
        btn.setImage(UIImage(named: "u6"), forState: UIControlState.Normal)
        btn.addTarget(self, action: "publicDynamic", forControlEvents: .TouchUpInside)
        return btn
    }()
}

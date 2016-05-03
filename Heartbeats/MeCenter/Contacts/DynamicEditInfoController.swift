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
        labelAddTap()
        setUpUI()
    }
    override func prefersStatusBarHidden() -> Bool {     // 隐藏状态栏
        return true
    }
//    MARK: -- private func
    private func labelAddTap() {
        contentTextBtn.userInteractionEnabled = true
        addressBtn.userInteractionEnabled = true
        contentTextBtn.addGestureRecognizer( UITapGestureRecognizer(target: self, action: "writeContentText"))
        addressBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "writeAddress"))
    }
    
    func writeContentText() {
        presentViewController(UINavigationController(rootViewController:DynamicWriteContentTextController()), animated: true, completion: nil)
    }
    func writeAddress() {
        
    }
    private func setUpUI() {
        view.addSubview(imageView)                      // 图片
        view.addSubview(backImageView)                  // 背景的毛玻璃图片
        view.addSubview(imageFilterCollectionView)      // 滤镜图片
        view.addSubview(publicBtn)                      // 发布
        view.addSubview(feelView)                       // 表情
        view.addSubview(contentTextBtn)                 // 内容
        view.addSubview(addressBtn)                     // 位置
        
        imageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view.snp_left)
            make.width.height.equalTo(screenMaimWidth)
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
        
        contentTextBtn.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp_left).offset(8)
            make.bottom.equalTo(view).offset(-8)
        }
        addressBtn.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentTextBtn.snp_right).offset(16)
            make.bottom.equalTo(contentTextBtn)
        }
        
        publicBtn.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(view).offset(-8)
            make.bottom.equalTo(view).offset(-8)
            make.height.width.equalTo(60)
        }
//
        Tools.insertBlurView(backImageView, style: .Light)
    }
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
        imgView.contentMode = .ScaleAspectFit
        return imgView
    }()
    private let backImageView: UIImageView = {                // 背景图片, 毛玻璃
        let backImageView = UIImageView()
        backImageView.image = placeholderImage
        return backImageView
    }()
    
    lazy var publicBtn: UIButton = {           // 发布Btn
        let btn = UIButton()
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 60 / 2
        btn.setImage(UIImage(named: "u6"), forState: UIControlState.Normal)
        btn.addTarget(self, action: "publicDynamic", forControlEvents: .TouchUpInside)
        return btn
    }()
    var feelView = FeelingView()             // 表情View
    
    lazy var contentTextBtn: UILabel = UILabel(title: " 文字 ", fontSize: 16, textColor: UIColor(white: 1.0, alpha: 1.0), backColor: UIColor.blackColor(), cornerRadius: 5)
    
    lazy var addressBtn: UILabel = UILabel(title: " 位置 ", fontSize: 16, textColor: UIColor(white: 1.0, alpha: 1.0), backColor: UIColor.blackColor(), cornerRadius: 5)

    var imageFilterLastName: String?           // 最后一次的滤镜名称, 如果重复的则不重复设置了(性能)
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
    
    lazy var writeContentTextControl: DynamicWriteContentTextController = {
        let writeContentTControl = DynamicWriteContentTextController()
        writeContentTControl.contentT = {(contentText) -> Void in
            
        }
        return writeContentTControl
    }()
}
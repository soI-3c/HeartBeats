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
        editDynamicInfo()
    }
    override func prefersStatusBarHidden() -> Bool {     // 隐藏状态栏
        return true
    }
    deinit {
        print("DynamicEditInfoController")
    }
    
//    MARK: -- private func
    private func labelAddTap() {
        contentTextBtn.userInteractionEnabled = true
        addressBtn.userInteractionEnabled = true
        contentTextBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "writeContentText"))
        addressBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "writeAddress"))
    }
    
    func writeContentText() {
        presentViewController(UINavigationController(rootViewController: writeContentTextControl), animated: true, completion: nil)
    }
    func writeAddress() {
        presentViewController(UINavigationController(rootViewController: writeAddressControl), animated: true, completion: nil)
    }
    func editDynamicInfo() {
        imageFilterCollectionView.selectImageFilter = {[weak self](name) -> Void in         // 对图片进行滤镜
            if name != self!.imageFilterLastName {
                self!.imageView.image = Tools().imgFilterEffect(self!.image!, filterName: name)
                self!.imageFilterLastName = name
            }
        }
        feelView.selectFeel = {[weak self](feelName) -> Void in                            // 心情
            self!.dynamic.feeling = feelName
        }
        writeContentTextControl.contentT = {[weak self](contentText) -> Void in            // 文字
            self!.dynamic.content = contentText
        }
        writeAddressControl.returnAddress = {[weak self](var addressString) -> Void in     // 地址
            addressString = addressString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            self!.addressBtn.text = addressString.characters.count > 0 ? addressString : "位置"
            self!.dynamic.address = addressString
        }
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
    
    // 发表
    func publicDynamic() {
        dynamic.user = HeartUser.currentUser()
        let dynamicImage = HBAVFile(name: "dynamicImage", data: UIImageJPEGRepresentation(image!, 1.0))
        dynamic.photos = dynamicImage
        dynamic.saveInBackgroundWithBlock { (b, error) -> Void in
            if error == nil {
                self.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            SVProgressHUD.showInfoWithStatus("发布失败..")
        }
    }
    
//    MARK: -- setter / getter
    let dynamic = Dynamic()                                                 // 要发布的动态对象
    
    let writeContentTextControl = DynamicWriteContentTextController()       // 填写文字控制器
    
    let writeAddressControl = DynamicAddressControl()                       // 填写位置控制器
    
    var feelView = FeelingView()                                            // 表情View
    
    var imageFilterCollectionView = ImageFilterCollectionView()             // 滤镜
    
    var image: UIImage? {
        didSet {
            imageView.image = image
            backImageView.image = image
        }
    }
    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .ScaleAspectFit
        return imgView
    }()
    private let backImageView: UIImageView = {                              // 背景图片, 毛玻璃
        let backImageView = UIImageView()
        return backImageView
    }()
    
    lazy var publicBtn: UIButton = {                                        // 发布Btn
        let btn = UIButton()
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 60 / 2
        btn.setBackgroundImage(UIImage(named: "public"), forState: .Normal)
        btn.addTarget(self, action: "publicDynamic", forControlEvents: .TouchUpInside)
        return btn
    }()
    
    lazy var contentTextBtn: UILabel = UILabel(title: " 文字 ", fontSize: 16, textColor: UIColor(white: 1.0, alpha: 1.0), backColor: UIColor.blackColor(), cornerRadius: 5)
    
    lazy var addressBtn: UILabel = UILabel(title: " 位置 ", fontSize: 16, textColor: UIColor(white: 1.0, alpha: 1.0), backColor: UIColor.blackColor(), cornerRadius: 5)

    var imageFilterLastName: String?          // 最后一次的滤镜名称, 如果重复的则不重复设置了(性能)
}
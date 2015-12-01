//
//  MeCenterHeadView.swift
//  Heartbeats
//
//  Created by iOS-3C on 15/11/15.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit

let screenMaimWidth = UIScreen.mainScreen().bounds.size.width
let screenMaimheiht = UIScreen.mainScreen().bounds.size.height
/**  个人中心头视图 */
class MeCenterHeadView: UIView {
    
// MARK : -- 懒加载 控件
    private lazy var userBackImg: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.text = nil
        btn.adjustsImageWhenHighlighted = false
        btn.setBackgroundImage(UIImage(named: "HeadBackImage"), forState: UIControlState.Normal)
        return btn;
    }()
    
    private lazy var userHeadImg: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.text = nil
        btn.snp_makeConstraints(closure: { (make) -> Void in
            make.width.height.equalTo(50)
            btn.layer.masksToBounds = true
            btn.layer.cornerRadius = 25
        })
        btn.addTarget(self, action: "changeUserHeadImg", forControlEvents: UIControlEvents.TouchUpInside)
        btn.adjustsImageWhenHighlighted = false
        btn.setBackgroundImage(UIImage(named: "HeadImage"), forState: UIControlState.Normal)
        return btn;
    }()
    
    private lazy var username : UILabel = {
        let lab = UILabel()
        lab.text  = "heartbeats"
        lab.font = UIFont(name: "Helvetica-Bold", size: 18)
        lab.textColor = UIColor.whiteColor()
        return lab
    }()
    
    private lazy var userIndividualityText : UILabel = {
        let lab = UILabel()
        lab.text  = "how how how how how how"
        lab.textAlignment = NSTextAlignment.Center
        lab.numberOfLines = 0
        lab.lineBreakMode = NSLineBreakMode.ByWordWrapping
        return lab
    }()
    
    private lazy var loginBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.text = "登陆"
        return btn;
    }()
    
    private lazy var registerBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.text = "注册"
        return btn;
    }()


    
//    MARK: -- 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
//   MARK: --  设置UI
    private func setupUI() {
        self.addSubview(userBackImg)
        self.userBackImg.addSubview(userHeadImg)
        self.userBackImg.addSubview(username)
        self.userBackImg.addSubview(userIndividualityText)
        self.userBackImg.addSubview(registerBtn)
        
        self.userBackImg.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self)
            make.edges.equalTo(self).offset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        userHeadImg.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(userBackImg)
            make.bottom.equalTo(userBackImg.snp_bottom).offset(-48)
        }
        username.snp_makeConstraints { (make) -> Void in
             make.centerX.equalTo(userHeadImg)
             make.top.equalTo(userHeadImg.snp_bottom).offset(3)
        }
        userIndividualityText.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(UIScreen.mainScreen().bounds.width - 80)
            make.centerX.equalTo(username)
            make.top.equalTo(username.snp_bottom).offset(3)
        }
    }
    
//    MARK: - 换头像点击事件
     @objc private func changeUserHeadImg() {
//        SMSSDK.getVerificationCodeByMethod("", phoneNumber: "18321655626", zone: "86", customIdentifier: "") { (NSError!) -> Void in
//            
//        }
    }
}

//
//  MeCenterHeadView.swift
//  Heartbeats
//
//  Created by iOS-3C on 15/11/15.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit
protocol MeCenterHeadViewDelegate : NSObjectProtocol {
    func chageUserHeaderImg(meCenterHeadView : MeCenterHeadView)
    func chageUserBackImg(meCenterHeadView : MeCenterHeadView)
}

/**  个人中心头视图 */
class MeCenterHeadView: UIView{

// MARK : -- 懒加载 控件
    weak var delegate: MeCenterHeadViewDelegate?
    var user: HeartUser? {
        didSet {
           if let user = user {
                NetworkTools.loadUserIconImageWithBackImage(user, imageName: HBUserIconImage
                    , finishedCallBack: {[weak self] (objs, error) -> () in
                    if error == nil {
                        if let user = objs!.first as? HeartUser {
                            if let url = user.iconImage?.url {
                                self!.userHeadImgView.sd_setBackgroundImageWithURL(NSURL(string: url), forState: .Normal)
                            }else {
                                self?.userHeadImgView.setBackgroundImage(UIImage(named: "u1"), forState: UIControlState.Normal)
                            }
                            if let url = user.backIconImage?.url {
                                self!.userBackImg.sd_setBackgroundImageWithURL(NSURL(string: url), forState: .Normal)
                            }else {
                                self?.userBackImg.setBackgroundImage(UIImage(named: "u1"), forState: .Normal)
                            }
                        }
                    }
                })
                username.text = user.username
                userIndividualityText.text = user.personality == nil ? "" : user.personality
                ageLabel.text = user.age == nil ? " 年龄 " : " \(user.age!) "
                sexLabel.text = user.sex == nil ? " 性别 " : " \(user.sex!) "
                heightLabel.text = user.height == nil ? " 身高 " : " \(user.height!) "
                academicLabel.text = user.academic == nil ? " 学历 " : " \(user.academic!) "
                addressLabel.text = user.address == nil ? " 地址 " : " \(user.address!) "
                incomeLabel.text = user.income == nil ? " 月收入 " : " \(user.income!) "
                carLabel.text = user.car == nil ? " 是否已购车 " : " \(user.car!) "
                houseLabel.text = user.house == nil ? " 是否已购房 " : " \(user.house!) "
            }
        }
    }
    
    lazy var userBackImg: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.text = nil
        btn.addTarget(self, action: #selector(MeCenterHeadView.changeUserBackImg), forControlEvents: .TouchUpInside)
        btn.adjustsImageWhenHighlighted = false
        btn.layer.masksToBounds = true
        btn.imageView?.contentMode = .ScaleAspectFill
        return btn;
    }()

     lazy var userHeadImgView: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.text = nil
        btn.addTarget(self, action: #selector(MeCenterHeadView.changeUserHeadImg), forControlEvents: .TouchUpInside)
        btn.adjustsImageWhenHighlighted = false
        btn.imageEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        btn.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        btn.layer.masksToBounds = true
        btn.imageView?.contentMode = .ScaleAspectFit
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.whiteColor().CGColor
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
        lab.textAlignment = NSTextAlignment.Left
        lab.font = UIFont(name: "Helvetica-Bold", size: 13)
        lab.numberOfLines = 0
        return lab
    }()
    private lazy var ageLabel : UILabel = UILabel(title: "年龄", fontSize: fontSize)
    private lazy var sexLabel : UILabel = UILabel(title: "性别", fontSize: fontSize)
    private lazy var addressLabel : UILabel = UILabel(title: "地址", fontSize: fontSize)
    private lazy var academicLabel : UILabel = UILabel(title: "学历", fontSize: fontSize)
    private lazy var incomeLabel : UILabel = UILabel(title: "收入", fontSize: fontSize)
    private lazy var heightLabel : UILabel = UILabel(title: "身高", fontSize: fontSize)
    private lazy var carLabel : UILabel = UILabel(title: "是否有车", fontSize: fontSize)
    private lazy var houseLabel : UILabel = UILabel(title: "是否有房", fontSize: fontSize)
        
//    MARK: -- 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setImgStyle()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setImgStyle()
    }
    
//   MARK: --  设置UI
    private func setupUI() {
        addSubview(userBackImg)
        userBackImg.addSubview(userHeadImgView)
        userBackImg.addSubview(username)
        userBackImg.addSubview(ageLabel)
        userBackImg.addSubview(sexLabel)
        userBackImg.addSubview(academicLabel)
        userBackImg.addSubview(heightLabel)
        userBackImg.addSubview(addressLabel)
        userBackImg.addSubview(incomeLabel)
        userBackImg.addSubview(carLabel)
        userBackImg.addSubview(houseLabel)
        
        userBackImg.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self)
            make.edges.equalTo(self).offset(UIEdgeInsets(top: zero, left: zero, bottom: zero, right: zero))
        }
        userHeadImgView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(userBackImg).offset(maxMArgins)
            make.bottom.equalTo(userBackImg.snp_bottom).offset(-30)
            make.width.height.equalTo(45)
        }
        username.snp_makeConstraints { (make) -> Void in
               make.leading.equalTo(userHeadImgView)
                make.top.equalTo(userHeadImgView.snp_bottom).offset(3)
        }
        sexLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(userHeadImgView).offset(minMargins)
            make.right.equalTo(userBackImg).offset(-maxMArgins)
        }
        
        ageLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(sexLabel)
            make.right.equalTo(sexLabel.snp_left).offset(-minMargins)
        }
        academicLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(ageLabel)
            make.right.equalTo(heightLabel.snp_left).offset(-minMargins)
        }
        heightLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(ageLabel)
            make.right.equalTo(ageLabel.snp_left).offset(-minMargins)
        }
        addressLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(ageLabel.snp_bottom).offset(minMargins)
            make.right.equalTo(userBackImg).offset(-maxMArgins)
        }
        incomeLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(addressLabel)
            make.right.equalTo(addressLabel.snp_left).offset(-minMargins)
        }
        carLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(incomeLabel.snp_bottom).offset(minMargins)
            make.right.equalTo(userBackImg).offset(-maxMArgins)
        }
        houseLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(carLabel)
            make.right.equalTo(carLabel.snp_left).offset(-minMargins)
        }
    }
    private func setImgStyle() {
        //设置头像圆角
        userHeadImgView.layer.cornerRadius = 45/2
        //设置遮盖额外部分,下面两句的意义及实现是相同的
        //imgV.clipsToBounds = true
        userHeadImgView.layer.masksToBounds = true
    }

//    MARK: - 换头像点击事件
    @objc private func changeUserHeadImg() {
        self.delegate?.chageUserHeaderImg(self)
     }
    @objc private func changeUserBackImg() {
        self.delegate?.chageUserBackImg(self)
    }
}

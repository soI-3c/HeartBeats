//
//  LoginRegisterMainViewController.swift
//  Heartbeats
//
//  Created by iOS-3C on 15/12/6.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit
import AVOSCloud

// MARK: --- 没有登陆进入的主页面. 处理登陆,注册事件
class LoginRegisterMainViewController: UIViewController, UIAlertViewDelegate {
    // MARK: --- 懒加载属性
    var changeViewController: changeRootViewControllerToMain?
    
    private lazy var backView: UIView = {
        let backView = UIView()
        return backView
    }()
    
    private lazy var backImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = placeholderImage
        return imgView
    }()
    
    private lazy var heartUser: HeartUser = {
        let user = HeartUser()
        return user
    }()
    
    private let loginBtn: HBButton = {
        let btn = HBButton()
        btn.setTitle("登陆", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.backgroundColor = UIColor.blackColor()
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.whiteColor().CGColor
        return btn
    }()
    
    private let registerBtn: HBButton = {
        let btn = HBButton()
        btn.setTitle("注册", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.backgroundColor = UIColor.blackColor()
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.whiteColor().CGColor
        return btn
    }()
    
    private lazy var logoLabel: UILabel = {
        let logo = UILabel()
        logo.text = "Heartbeats"
        logo.textAlignment = NSTextAlignment.Center
        logo.font = UIFont.systemFontOfSize(48)
        return logo
    }()
    
    private lazy var colorLayer: CAGradientLayer = {
        let colorLayer = CAGradientLayer()
        colorLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        colorLayer.colors = [UIColor.blackColor().CGColor, UIColor.whiteColor().CGColor, UIColor.blackColor().CGColor]
        colorLayer.locations = [0.01, 0.05, 0.09]
        colorLayer.startPoint = CGPoint(x: 0, y: 1)
        colorLayer.endPoint = CGPoint(x: 1, y: 1)
        return colorLayer
    }()
//    MARK: --- 初始化方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backView)
        backView.addSubview(backImageView)
        
        view.addSubview(loginBtn)
        view.addSubview(registerBtn)
        view.addSubview(logoLabel)
        view.layer.addSublayer(colorLayer)
        
        
        logoLabel.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self.view).offset(CGPoint(x: 0, y: -screenMaimheiht * 0.25))
            make.width.equalTo(self.view)
        }
        loginBtn.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(16)
            make.right.equalTo(registerBtn.snp_left).offset(-16)
            make.bottom.equalTo(self.view.snp_bottom).offset(-32)
            make.height.equalTo(40)
            make.width.equalTo(registerBtn)
        }
        registerBtn.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(self.view).offset(-16)
            make.top.equalTo(loginBtn)
            make.height.equalTo(loginBtn)
            make.width.equalTo(loginBtn)
        }
        backView.frame = view.bounds
        backImageView.frame = view.bounds
        Tools.insertBlurView(backImageView, style: .Dark)
        
        loginBtn.addTarget(self, action: "loginView:", forControlEvents: .TouchUpInside)
        registerBtn.addTarget(self, action: "registerView:", forControlEvents: .TouchUpInside)
    }
    override func viewWillAppear(animated: Bool) {
        let gradient =  CABasicAnimation(keyPath: "locations")
        gradient.fromValue = [0, 0.2, 0.3]
        gradient.toValue = [1, 1, 1]
        gradient.duration = 3.5
        gradient.repeatCount = HUGE
        colorLayer.addAnimation(gradient, forKey: nil)
        colorLayer.mask = logoLabel.layer
    }
    
    //    MARK: --- 加载登陆陆注册视图
    func loginView(sender: UIButton) {
        let loginViewController =  UIStoryboard(name: "LoginViewController", bundle: nil).instantiateInitialViewController()
        presentViewController(loginViewController!, animated: true, completion: nil)
    }
    
    func registerView(sender: UIButton) {
        let gstisterViewController =  UIStoryboard(name: "GetisterViewController", bundle: nil).instantiateInitialViewController()
        presentViewController(gstisterViewController!, animated: true, completion: nil)
    }
}

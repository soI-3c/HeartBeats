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
        let backView = UIView(frame: self.view.bounds)
        backView.backgroundColor = UIColor.grayColor()
        return backView
    }()
    
    private lazy var heartUser: HeartUser = {
        let user = HeartUser()
        return user
    }()
    
    private lazy var logoLabel: UILabel = {
        let logo = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 0.5, height: 200))
        logo.text = "HeartBeats"
        logo.center = self.view.center
        logo.textAlignment = NSTextAlignment.Center
        logo.font = UIFont.systemFontOfSize(35)
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
        view.layer.addSublayer(colorLayer)
        view.addSubview(backView)
        view.addSubview(logoLabel)
    }
    override func viewWillAppear(animated: Bool) {
        backView.alpha = 0.0
        let gradient =  CABasicAnimation(keyPath: "locations")
        gradient.fromValue = [0, 0.2, 0.3]
        gradient.toValue = [1, 1, 1]
        gradient.duration = 3.5
        gradient.repeatCount = HUGE
        colorLayer.addAnimation(gradient, forKey: nil)
        colorLayer.mask = logoLabel.layer
    
    }
    
    //    MARK: --- 加载登陆陆注册视图
    @IBAction func loginView(sender: UIButton) {
        let loginViewController =  UIStoryboard(name: "LoginViewController", bundle: nil).instantiateInitialViewController()
        presentViewController(loginViewController!, animated: true, completion: nil)
    }
    
    @IBAction func registerView(sender: UIButton) {
        let gstisterViewController =  UIStoryboard(name: "GetisterViewController", bundle: nil).instantiateInitialViewController()
        presentViewController(gstisterViewController!, animated: true, completion: nil)
    }
}

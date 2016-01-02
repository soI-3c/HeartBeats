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
    var changeViewController: changeRootViewController?
    
    private lazy var  loginView: LoginView? = {
        var loginView =  NSBundle.mainBundle().loadNibNamed("LoginView", owner: nil, options: nil).first as? LoginView
        return loginView!
    }()
    private lazy var  registerView: RegisterView? = {
        var registerView =  NSBundle.mainBundle().loadNibNamed("RegisterView", owner: nil, options: nil).first as? RegisterView
        return registerView!
    }()
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
        view.addSubview(loginView!)
        view.addSubview(registerView!)
        view.addSubview(logoLabel)
    }
    override func viewWillAppear(animated: Bool) {
        registerView!.alpha = 0.0
        loginView!.alpha = 0.0
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
        weak var weakSelf = self
        self.registerView?.removeFromSuperview()
        if loginView?.superview == nil {
            view.addSubview(loginView!)
            loginView?.phoneNumber.text = Tools.username()
        }
        loginView?.phoneNumber.text = Tools.username()
        self.loginView!.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self.view).offset(CGPoint(x: 0, y: -50))
            make.width.equalTo(self.view.frame.width)
            make.height.equalTo(210)
        }
        
        UIView.animateWithDuration(0.4, delay: 0, options: [.BeginFromCurrentState, .CurveEaseInOut], animations: {() -> Void in
            weakSelf?.backView.alpha = 0.9
            weakSelf?.loginView!.alpha = 1.0
            weakSelf?.loginView!.layer.setAffineTransform(CGAffineTransformMakeRotation(0))
            weakSelf?.loginView!.center = CGPoint(x: weakSelf!.view.center.x, y: weakSelf!.view.center.y)
            }) {(b) -> Void in
        }
    }
    
    @IBAction func registerView(sender: UIButton) {
        weak var weakSelf = self
        self.loginView?.removeFromSuperview()
        if registerView?.superview == nil {
            view.addSubview(registerView!)
        }
        
        self.registerView!.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self.view).offset(CGPoint(x: 0, y: -50))
            make.width.equalTo(self.view.frame.width)
            make.height.equalTo(160)
        }
        UIView.animateWithDuration(0.4, delay: 0, options: [.BeginFromCurrentState, .CurveEaseInOut], animations: {() -> Void in
            weakSelf?.backView.alpha = 0.9
            weakSelf?.registerView!.alpha = 1.0
            weakSelf?.registerView!.layer.setAffineTransform(CGAffineTransformMakeRotation(0))
            weakSelf?.registerView!.center = CGPoint(x: weakSelf!.view.center.x, y: weakSelf!.view.center.y)
            }) { (b) -> Void in
        }
    }
    
    //    MARK: --- touchesBegan点击事件.
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        let touch =  touches.first
        if (touch?.view?.isEqual(self.backView) == true) {
            missLoginRegisterView()
        }
    }
    //    MARK: -- 注册,获取短信验证, 登陆处理事件
    @IBAction func register(sender: UIButton) {
       let phoneNumber = registerView?.phoneNumber.text
        if phoneNumber == "" ||
            registerView!.passworld.text == "" {
                Tools.myAlertView("笨笨", message: "手机或 验证码或 密码不许空~", delegate: nil, canelBtnTitle: "-.-#¶")
                return
        }
        if Tools.phoneCheck(phoneNumber!) == false {
            Tools.myAlertView("笨笨", message: "猪吗? 手机填错啦~", delegate: nil, canelBtnTitle: "-.-#¶")
            return
        }
        heartUser.setObject(phoneNumber, forKey: "phone")
        heartUser.username = phoneNumber
        heartUser.password = registerView!.passworld.text
        heartUser.mobilePhoneNumber = phoneNumber
        self.heartUser.signUpInBackgroundWithBlock({ (success, error) -> Void in
            if success == true {
                HeartUser.currentUser()
                self.missLoginRegisterView()
               let alerView =  UIAlertView(title: "啦啦", message: "注册成功, heartBeats欢迎你~", delegate: self, cancelButtonTitle: "*.*")
                alerView.tag = 1
                alerView.delegate = self
                alerView.show()
                
            }else {
                 HeartUser.currentUser()
                 UIAlertView(title: "啊啊", message: "注册失败, heartBeats很 sorry", delegate: self, cancelButtonTitle: ".").show()
            }
       })
    }
    @IBAction func getPhoneMessCode(sender: UIButton) {
        let phoneNumber: String? = self.registerView?.phoneNumber.text
        HeartUser.verifyMobilePhone(phoneNumber) { (success, error) -> Void in
            if success == true {
                 Tools.myAlertView("啦啦", message: "验证成功~", delegate: nil, canelBtnTitle: ".")
            }else {
                  Tools.myAlertView("啦啦", message: "验证失败~", delegate: nil, canelBtnTitle: ".")
            }
        }
    }
    
    @IBAction func login(sender: UIButton) {
        
        if loginView?.passworld.text == "" {
            Tools.myAlertView("笨笨", message: "猪吗? 密码不许空~", delegate: nil, canelBtnTitle: "-.-#¶")
            return
        }
        let phoneNumber =  self.loginView?.phoneNumber.text
        let pass = self.loginView?.passworld.text
        HeartUser.logInWithUsernameInBackground(phoneNumber, password: pass) { (user, error) -> Void in
            if user != nil {
                self.missLoginRegisterView()
                HeartUser.currentUser()
                Tools.saveUsername(user.username)
                self.changeViewController?()
            }else {
                Tools.myAlertView("笨笨", message: "用户不存在, 去注册, heartBeats欢迎你~", delegate: nil, canelBtnTitle: "-.-#¶")
            }
        }
    }
    
    //    MARK: -- 登陆与注册View的隐藏
    private func missLoginRegisterView() {
        weak var weakSelf = self
        UIView.animateWithDuration(0.4, delay: 0, options: [.BeginFromCurrentState, .CurveEaseInOut], animations: { () -> Void in
            weakSelf?.backView.alpha = 0.0
            weakSelf?.loginView!.frame.origin.y = CGRectGetMaxY(self.view.frame)
            weakSelf?.registerView?.frame.origin.y =  CGRectGetMaxY(self.view.frame)
            }, completion: { (b) -> Void in
                weakSelf?.loginView?.phoneNumber.text = ""
                weakSelf?.loginView?.passworld.text = ""
                weakSelf?.registerView?.passworld.text = ""
                weakSelf?.registerView?.phoneNumber.text = ""
                self.loginView!.removeFromSuperview()
                self.registerView?.removeFromSuperview()
        })
    }
//  MARK:--- UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let showView = Tools.instantiateFromNib("SettingView", widthPercen: 0.85, hieghtPercen: 0.75) as! SettingView
        let window = UIApplication.sharedApplication().delegate?.window!
        let modal = PathDynamicModal.show(modalView: showView, inView: window!)
        showView.closeButtonHandler = {[weak modal] in
            modal?.closeWithLeansRandom()
            return
        }
        let user = HeartUser.currentUser()
        showView.bottomButtonHandler = {[weak modal](username, sex, birthDay, address, academic) -> Void in
            modal?.closeWithLeansRandom()
            user.birthday = birthDay
            user.sex = sex
            user.username = username
            user.address = address
            user.academic = academic
               user.saveInBackground()
            
            let carHouseIncomeView = Tools.instantiateFromNib("SettingView2", widthPercen: 0.85, hieghtPercen: 0.75) as! SettingView2
            let modal = PathDynamicModal.show(modalView: carHouseIncomeView, inView: window!)
           
            carHouseIncomeView.closeButtonHandler = {[weak modal] in
                modal?.closeWithLeansRandom()
                return
            }

            carHouseIncomeView.bottomButtonHandler = {[weak modal](height, income, house, car) -> Void in
               modal?.closeWithLeansRandom()
                user.height = height
                user.income = income
                user.house = house
                user.car = car
                user.saveInBackground()
                let personalityView = Tools.instantiateFromNib("PersonalityView", widthPercen: 0.65, hieghtPercen: 0.5) as! PersonalityView
                let modal = PathDynamicModal.show(modalView: personalityView, inView: window!)
                personalityView.closeButtonHandler = {[weak modal] in
                    modal?.closeWithLeansRandom()
                    return
                }
                personalityView.bottomButtonHandler = {[weak modal](personalityText) -> Void in
                    modal?.closeWithLeansRandom()
                    user.personality = personalityText
                    user.saveInBackground()
                    modal?.closeWithLeansRandom()
                    self.changeViewController?()
                }
            }
        }
    }
    //    MARK: -- 封闭UIA
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}

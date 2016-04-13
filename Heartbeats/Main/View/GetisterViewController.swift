//
//  LoginControllerViewController.swift
//  Heartbeats
//
//  Created by liaosenshi on 16/3/22.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

// 注册Controller
class LoginControllerView: UIViewController {
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passWorldTextField: UITextField!
    @IBOutlet weak var verifyCodeTextField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var getVerifyCode: UIButton!
    @IBOutlet weak var nothingBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewBorderWitdColor(registerBtn)
        setViewBorderWitdColor(getVerifyCode)
        setViewBorderWitdColor(nothingBtn)
    }

    @IBAction func backAction(sender: UIButton) {                   // 返回
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func getisterAction(sender: UIButton) {               // 注册
        if let verifyCode = verifyCodeTextField.text, let phoneNumer = phoneNumberTextField.text {
            if !Tools.verifyCodeCheck(verifyCode) {
                SVProgressHUD.showInfoWithStatus("验证码不正确")
                return
            }
            if Tools.phoneCheck(phoneNumer) {
                HeartUser.signUpOrLoginWithMobilePhoneNumberInBackground(phoneNumer, smsCode: verifyCode, block: { (user, error) -> Void in
                    if error != nil {
                        SVProgressHUD.showInfoWithStatus("注册失败")
                        return
                    }
                    HeartUser.currentUser()                             // 注册成功
                    // 发送通知切换视图控制器
                    NSNotificationCenter.defaultCenter().postNotificationName(HBRootViewControllerSwitchNotification, object: true)
                })
            }else {
                SVProgressHUD.showInfoWithStatus("请输入正确的手机号码")
            }

        }
    }
    @IBAction func getVerifyCode(sender: UIButton) {                // 获取 验证码
        if let phoneNumber = phoneNumberTextField.text {
            if Tools.phoneCheck(phoneNumber) {
                AVOSCloud.requestSmsCodeWithPhoneNumber(phoneNumber) { (success, error) -> Void in
                    if error != nil {
                        SVProgressHUD.showInfoWithStatus("发送验证码失败...")
                    }
                    SVProgressHUD.showInfoWithStatus("请注意查收...")
                }
            }else {
                SVProgressHUD.showInfoWithStatus("请输入正确的手机号码")
            }
        }
    }
    
    func setViewBorderWitdColor(view: UIView) {
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.whiteColor().CGColor
    }
}

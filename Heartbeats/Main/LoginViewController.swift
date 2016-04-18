//
//  GetisterViewController.swift
//  Heartbeats
//
//  Created by iOS-3C on 16/3/22.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

// 登陆controller
class LoginViewController: UIViewController {

    @IBOutlet weak var forgetBtn: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var nothingBtn: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewBorderWitdColor(loginBtn)
        setViewBorderWitdColor(nothingBtn)
    }
    @IBAction func backAction(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func loginAction(sender: UIButton) {
        if let phoneNumber = phoneNumberTextField.text, let password = passwordTextField.text {
            if Tools.phoneCheck(phoneNumber) {
               HeartUser.logInWithMobilePhoneNumberInBackground(phoneNumber, password: password, block: { (user, error) -> Void in
                    print(phoneNumber, password)
                    if error != nil {
                        SVProgressHUD.showInfoWithStatus("用户不存在")
                        return
                    }
                    if user != nil {
                        HeartUser.currentUser()
                        self.dismissViewControllerAnimated(false, completion: nil)
                        // 发送通知切换视图控制器
                        NSNotificationCenter.defaultCenter().postNotificationName(HBRootViewControllerSwitchNotification, object: true)
                        return
                    }
               })
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

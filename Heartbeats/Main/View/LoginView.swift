//
//  loginView.swift
//  Heartbeats
//
//  Created by liaosenshi on 15/12/8.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit

class LoginView: UIView {
    @IBOutlet weak var userImgHead: UIButton!

    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var passworld: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init  frame")
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if (HeartUser.currentUser() != nil) {
            phoneNumber.text =  HeartUser().mobilePhoneNumber
            userImgHead.imageView?.image = UIImage(named: "userImg")
        }
    }
}

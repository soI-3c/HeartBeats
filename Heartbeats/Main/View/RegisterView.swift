//
//  RegisterView.swift
//  Heartbeats
//
//  Created by liaosenshi on 15/12/8.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit

class RegisterView: UIView {
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var passworld: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    private func setupUI() {
        
//        phoneMessCode.layer.masksToBounds = true
//        phoneMessCode.layer.cornerRadius = 5
//        
//        phoneNumber.layer.masksToBounds = true
//        phoneNumber.layer.cornerRadius = 5
    }
}

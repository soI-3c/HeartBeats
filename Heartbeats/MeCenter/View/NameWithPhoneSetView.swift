//
//  NameWithPhoneSetView.swift
//  Heartbeats
//
//  Created by liaosenshi on 15/12/30.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit

// 修改用户名与手机号 View
class NameWithPhoneSetView: UIView {
    var changeHandler: ((String) -> Void)?
    var changeSaveActionHandler: (() ->Void)?
    var closeHandler: (() -> Void)?
    @IBOutlet weak var editTextField: UITextField!
    
    @IBAction func changeEdit(sender: UIButton) {
          changeHandler?(editTextField.text!)
            changeSaveActionHandler?()
    }
    @IBAction func closeAction(sender: UIButton) {
        closeHandler?()
    }
}

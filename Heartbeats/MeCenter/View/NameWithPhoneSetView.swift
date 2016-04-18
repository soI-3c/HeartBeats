//
//  NameWithPhoneSetView.swift
//  Heartbeats
//
//  Created by liaosenshi on 15/12/30.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit

// 修改用户名与手机号
class NameWithPhoneSetView: UIView, UITextFieldDelegate {
    var textNumber: Int?                            // 限制输入的长度
    var changeHandler: ((String) -> Void)?          //编辑block
    var changeSaveActionHandler: (() ->Void)?       // 改变保存数据block
    var closeHandler: (() -> Void)?                 // 取消block
    @IBOutlet weak var editTextField: UITextField!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 10
        //设置遮盖额外部分,下面两句的意义及实现是相同的
        //imgV.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    @IBAction func changeEdit(sender: UIButton) {
        if textNumber == 11 {                       //
            if !Tools.phoneCheck(editTextField.text!) {
                Tools.showSVPMessage("电话号码格式不正确")
               return
            }
        }
        changeHandler?(editTextField.text!)
        changeSaveActionHandler?()
    }
    @IBAction func closeAction(sender: UIButton) {
        closeHandler?()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        editTextField?.delegate = self
        editTextField?.becomeFirstResponder()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print(string)
        if (string == "") {
            return true
        }
        print(textNumber, textField.text?.characters.count)
        if textField.text?.characters.count >= textNumber {
            return false
        }
            return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        changeEdit(UIButton())
        editTextField.resignFirstResponder()
        return true
    }
    
}

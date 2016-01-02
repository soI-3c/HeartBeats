//
//  SettingView.swift
//  Heartbeats
//
//  Created by liaosenshi on 15/12/22.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit

class SettingView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    var sex: String = "男"
    
    @IBOutlet weak var userNameTextFile: UITextField!
    @IBOutlet weak var dateView: UIDatePicker!
    @IBOutlet weak var girlBtn: UIButton!
    @IBOutlet weak var bodyBtn: UIButton!
    @IBOutlet weak var adressPicker: UIPickerView!
    @IBOutlet weak var academicPicker: UIPickerView!

    private var address: String = "上海"           // 地址
    private var academic: String = "本科"    
    
    var bottomButtonHandler: ((String, String, String, String, String) -> Void)?
    var closeButtonHandler: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        adressPicker.delegate = self
        adressPicker.dataSource = self
        adressPicker.tag = 100
        
        academicPicker.delegate = self
        academicPicker.dataSource = self
        academicPicker.tag = 200
    }
    
    @IBAction func isBody(sender: UIButton) {
        sender.backgroundColor = UIColor.blueColor()
        girlBtn.backgroundColor = UIColor.blackColor()
        sex = "男"
    }
    @IBAction func isGirl(sender: UIButton) {
        sender.backgroundColor = UIColor.redColor()
        bodyBtn.backgroundColor = UIColor.blackColor()
        sex = "女"
    }
    
    @IBAction func handleCloseButton(sender: UIButton) {
        self.closeButtonHandler?()
    }
    
    @IBAction func handleBottomButton(sender: UIButton) {
        if userNameTextFile.text == "" {
            Tools.myAlertView("提示", message: "用户名不可以为空", delegate: nil, canelBtnTitle: "确定")
            return
        }
        let select = dateView.date
        let dateFormatter2 = NSDateFormatter()
        
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        // Date 转 String
        let dateAndTime = dateFormatter2.stringFromDate(select)
//        block回调性别与生日日期
        self.bottomButtonHandler?(userNameTextFile.text!, sex, dateAndTime, address, academic)
    }
    
//     MARK: --- UIPickerViewDelegate
     func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if pickerView.tag == 100 {
            return 2
        }
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 100 {
            if (component == 0) {//省份个数
                return provinceArray.count
            } else {//市的个数
                return cityArray.count
            }
        }
        return academicArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 100 {
            if component == 0 {
                return provinceArray[row]
            }else {
                return cityArray[row]
            }
        }
        return academicArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 100 {
            var address = provinceArray[row]
                address += cityArray[row]
            self.address = address
        }
        academic =  academicArray[row]
    }
}

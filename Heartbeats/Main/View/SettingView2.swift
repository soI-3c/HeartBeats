//
//  SettingView2.swift
//  Heartbeats
//
//  Created by liaosenshi on 15/12/23.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit

class SettingView2: UIView, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var heightPicker: UIPickerView!
    @IBOutlet weak var incomePicker: UIPickerView!

    @IBOutlet weak var housePicker: UIPickerView!
    @IBOutlet weak var carPicker: UIPickerView!
  
    private var income: String = "2000 - 5000"
    private var house: String  = "暂没购房"
    private var car: String    = "暂没购车"
    private var height: String = "170cm"
    
    var bottomButtonHandler: ((String, String, String, String) -> Void)?
    var closeButtonHandler: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupSetting()
    }
    
    private func setupSetting() {
        heightPicker.delegate = self
        heightPicker.dataSource = self
        heightPicker.tag = 200
        
        incomePicker.delegate = self
        incomePicker.dataSource = self
        incomePicker.tag = 300
        
        housePicker.delegate = self
        housePicker.dataSource = self
        housePicker.tag = 400
        
        carPicker.delegate = self
        carPicker.dataSource = self
        carPicker.tag = 500
        
        incomePicker.selectRow(incomes.count / 2, inComponent: 0, animated: true)
        heightPicker.selectRow(heights.count / 2, inComponent: 0, animated: true)
    }
    @IBAction func settingAction(sender: UIButton) {
      self.bottomButtonHandler?(height, income, house, car)
    }
    //      @available(iOS 2.0, *)
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 200 {
            return heights[row]
        }else if pickerView.tag == 300{
            return incomes[row]
        }else if pickerView.tag == 400{
            return houses[row]
        }else {
            return cars[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 200 {
           height = heights[row]
        }else if pickerView.tag == 300{
           income = incomes[row]
        }else if pickerView.tag == 400{
            house =  houses[row]
        }else {
            car = cars[row]
        }
    }

    
    
    // returns the # of rows in each component..
    @available(iOS 2.0, *)
     func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 200 {
            return heights.count
        }else if pickerView.tag == 300{
            return incomes.count
        }else if pickerView.tag == 400{
            return houses.count
        }else {
            return cars.count
        }
    }
}

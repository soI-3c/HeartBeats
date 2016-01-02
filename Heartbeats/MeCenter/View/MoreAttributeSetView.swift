//
//  MoreAttributeSetView.swift
//  Heartbeats
//
//  Created by iOS-3C on 16/1/1.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

class MoreAttributeSetView: NameWithPhoneSetView, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var setPicker: UIPickerView!
    
    var soureCome: Int? {
        willSet {
            if let soure = newValue {
                switch soure {
                    case 2 :
                       soures = sexs
                    case 3:
                        soures = ages
                    case 4 :
                        soures = heights
                    case 5:
                        soures = academicArray
                    case 6 :
                        soures = incomes
                    case 7:
                            soures = houses
                    default:
                            soures = cars
                }
                setPicker.reloadAllComponents()
            }
        }
    }
    var soures: [String]? = ["没有数据", "有数据吗"]
    var selectChangeStr: String?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        print("awakeFromNib")
    }
    @IBAction func editAction(sender: HBButton) {
        if selectChangeStr == nil {
            selectChangeStr = soures![0]
        }
        changeHandler?(selectChangeStr!)
        changeSaveActionHandler?()
    }
    
    @available(iOS 2.0, *)
     func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    @available(iOS 2.0, *)
     func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return soures!.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return soures![row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            selectChangeStr = soures![row]
    }
}

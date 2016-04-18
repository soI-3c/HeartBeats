//
//  PersonalitySetView.swift
//  Heartbeats
//
//  Created by liaosenshi on 15/12/30.
//  Copyright © 2015年 heart. All rights reserved.
//

let textViewNumber = 200
import UIKit

class PersonalitySetView: NameWithPhoneSetView, UITextViewDelegate {
    @IBOutlet weak var editTextView: UITextView!
    @IBOutlet weak var editBtn: HBButton!
    
    @IBAction func changeEditAction(sender: HBButton) {
        changeHandler?(editTextView.text!)
        changeSaveActionHandler?()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        editTextView?.delegate = self
        editTextView?.becomeFirstResponder()
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "") {
            return true
        }
        if textView.text?.characters.count >= textViewNumber {
            return false
        }
        return true
    }
}

//
//  PersonalitySetView.swift
//  Heartbeats
//
//  Created by liaosenshi on 15/12/30.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit

class PersonalitySetView: NameWithPhoneSetView {
    @IBOutlet weak var editTextView: UITextView!

    @IBAction func changeEditAction(sender: HBButton) {
        changeHandler?(editTextView.text!)
        changeSaveActionHandler?()
    }
}

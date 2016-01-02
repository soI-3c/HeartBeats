//
//  PersonalityView.swift
//  Heartbeats
//
//  Created by liaosenshi on 15/12/22.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit

class PersonalityView: UIView {

    @IBOutlet weak var personalityTextView: UITextView!
   
    var closeButtonHandler: (() -> Void)?
    var bottomButtonHandler: ((String) -> Void)?


    @IBAction func PeronalityAction(sender: UIButton) {
        bottomButtonHandler?(personalityTextView.text)
    }
}

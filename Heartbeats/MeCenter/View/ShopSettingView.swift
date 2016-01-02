//
//  ShopSettingView.swift
//  Heartbeats
//
//  Created by liaosenshi on 15/12/25.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit

class ShopSettingView: UIView {

    var shopActionHandler: (() -> Void)?
    var settingActionHandler: (() -> Void)?
    
    override func drawRect(rect: CGRect) {
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func shopAction(sender: UIButton) {
        shopActionHandler?()
    }

    @IBAction func settingAction(sender: UIButton) {
        settingActionHandler?()
    }

}

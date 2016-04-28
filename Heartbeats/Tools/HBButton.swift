//
//  UIButton+Extension.swift
//  Heartbeats
//
//  Created by liaosenshi on 15/12/30.
//  Copyright © 2015年 heart. All rights reserved.
//
import UIKit

class HBButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true

    }
}
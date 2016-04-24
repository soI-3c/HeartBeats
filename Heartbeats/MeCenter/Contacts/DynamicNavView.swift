//
//  DynamicNavView.swift
//  Heartbeats
//
//  Created by iOS-3C on 16/4/24.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

class DynamicNavView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        let btn = UIButton(type: .Custom)
        btn.setTitle("相机胶卷", forState: .Normal)
        btn.setImage(UIImage(named: "closeIcon"), forState: UIControlState.Normal)
        btn.frame = CGRectMake(0, 0, 135, 35)
    }
}

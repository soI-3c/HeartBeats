//
//  PersonalitySectionView.swift
//  Heartbeats
//
//  Created by liaosenshi on 15/12/25.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit

// 个人介绍的View
class PersonalitySectionView: UIView {
    @IBOutlet weak var persionalityLabel: UILabel!
    override func awakeFromNib() {
        persionalityLabel.textAlignment = .Center
    }
}
//
//  PersonalitySectionView.swift
//  Heartbeats
//
//  Created by liaosenshi on 15/12/25.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit

class PersonalitySectionView: UIView {
    var linesActionHandler: ((CGFloat) -> Void)?
    
    @IBOutlet weak var persionalityLabel: UILabel!
    
    var personality: String? {
        willSet {
            if let str: NSString = newValue {
                self.persionalityLabel.text = newValue
                let textSize =  str.sizeWithAttributes([NSFontAttributeName:persionalityLabel.font])
                let lines =  textSize.width / (screenMaimWidth - 2)
                self.linesActionHandler?(lines)    // 回调行数
            }
        }
    }
    override func awakeFromNib() {
    }
}
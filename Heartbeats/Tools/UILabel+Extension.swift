//
//  UILabel+Extension.swift
//  微博009
//
//  Created by Romeo on 15/9/5.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

extension UILabel {

    /// - returns: UILabel
    convenience init(title: String?, fontSize: CGFloat) {
        // 实例化当前对象
        self.init()
        // 设置对象属性
        text = title
        textColor = UIColor.blackColor()
        backgroundColor = UIColor.whiteColor()
        font = UIFont(name: "Helvetica-Bold", size: fontSize)
        sizeToFit()
    }
}

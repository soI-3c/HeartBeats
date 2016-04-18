//
//  UIButton+Extension.swift
//  Heartbeats
//
//  Created by liaosenshi on 15/12/30.
//  Copyright © 2015年 heart. All rights reserved.

import UIKit

extension UILabel {
    /// - returns: UILabel
    convenience init(title: String?, fontSize: CGFloat, balckBack: Bool = false) {
        // 实例化当前对象
        self.init()
        // 设置对象属性
        text = title
        numberOfLines = 0
        sizeToFit()
        if(balckBack) {
            textColor = UIColor.whiteColor()
            backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.85)
        }else {
            textColor = UIColor.blackColor()
            backgroundColor = UIColor.whiteColor()
        }
        font = UIFont(name: "Helvetica-Bold", size: fontSize)
        layer.cornerRadius = 5
        //设置遮盖额外部分,下面两句的意义及实现是相同的
        //imgV.clipsToBounds = true
        layer.masksToBounds = true
    }
}

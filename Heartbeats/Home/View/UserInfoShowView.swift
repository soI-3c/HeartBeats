//
//  UserInfoShowView.swift
//  Heartbeats
//
//  Created by iOS-3C on 16/4/13.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

let mar: CGFloat = 4
class UserInfoShowView: UIView {
    var infos = [String]() {
        didSet {
            for var subView in subviews {
                subView.removeFromSuperview()
            }
            if infos.count > 0 {
                for var i = 0; i < infos.count; ++i {
                    let conunts = infos.count + 1
                    let maWidth = mar * (CGFloat(i) + 1)
                    let width = (frame.size.width - (CGFloat(conunts) * mar)) / CGFloat(infos.count)
                    let x = maWidth + CGFloat(i) * width
                    let y: CGFloat = 0
                    let label = UILabel(title: infos[i], fontSize: 13, balckBack: true)
                    label.textAlignment = .Center
                    label.frame = CGRectMake(x , y, width, self.frame.size.height)
                    self.addSubview(label)
                    layoutIfNeeded()
                }
            }
        }
    }
}

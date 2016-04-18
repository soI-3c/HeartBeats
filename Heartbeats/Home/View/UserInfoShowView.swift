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

//    // 缩放图像的目标
//    // 1. 图像要等比例缩放
//    // 2. 统一的缩放`宽度`
//    func scaleImage(width: CGFloat) -> UIImage {
//        
//        // 1. 如果图像本身很小，直接返回
//        if size.width < width {
//            return self
//        }
//        
//        // 计算目标尺寸
//        let height = size.height * width / size.width
//        let s = CGSize(width: width, height: height)
//        
//        // 2. 使用图像上下文重新绘制图像
//        // 1> 开启上下文
//        UIGraphicsBeginImageContext(s)
//        
//        // 2> 绘图
//        drawInRect(CGRect(origin: CGPointZero, size: s))
//        
//        // 3> 从当前上下文拿到结果
//        let result = UIGraphicsGetImageFromCurrentImageContext()
//        
//        // 4> 关闭上下文
//        UIGraphicsEndImageContext()
//        
//        // 5> 返回结果
//        return result
//    }


}

//
//  HMProgressImageView.swift
//  Weibo09
//
//  Created by Romeo on 15/9/15.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

class HMProgressImageView: UIImageView {

    /// 进度数值，0～1
    var progress: CGFloat = 0 {
        didSet {
            progressView.progress = progress
        }
    }
    
    private lazy var progressView: HMProgressView = {
        let p = HMProgressView()
        
        p.backgroundColor = UIColor.clearColor()
        
        // 添加控件
        self.addSubview(p)
        // 设置大小
        p.frame = self.bounds

        return p
    }()
    
    /// 在 imageView 中，drawRect 函数不会被调用到
//    override func drawRect(rect: CGRect) {
//        // Drawing code
//        printLog("come here")
//    }
    
    /// 类中类，专供 HMProgressImageView 使用
    private class HMProgressView: UIView {
        
        /// 进度数值，0～1
        var progress: CGFloat = 0 {
            didSet {
                setNeedsDisplay()
            }
        }
        
        // 提问：rect 是什么 = view.bounds
        // drawRect 一旦被调用，所有的内容都会重新被绘制
        private override func drawRect(rect: CGRect) {
            
            if progress >= 1 {
                return
            }
            
            // 绘制曲线
            /**
                1. 中心点
                2. 半径
                3. 起始角度
                4. 结束角度
                5. 是否顺时针
            
            self.center 是相对父视图
            */
            let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
            let r = min(rect.width, rect.height) * 0.5
            let start = -CGFloat(M_PI_2)
            let end = 2 * CGFloat(M_PI) * progress + start
            
            // 添加曲线
            let path = UIBezierPath(arcCenter: center, radius: r, startAngle: start, endAngle: end, clockwise: true)
            
            // 增加指向圆心的路径
            path.addLineToPoint(center)
            // 关闭路径，产生一个扇形
            path.closePath()
            
            // 设置属性 - 在实际应用中，动画只是点缀，不要抢
            UIColor(white: 0.0, alpha: 0.5).setFill()
            
            path.fill()
        }
    }
}

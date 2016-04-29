
//
//  UIButton+Extension.swift
//  Heartbeats
//
//  Created by liaosenshi on 15/12/30.
//  Copyright © 2015年 heart. All rights reserved.

import UIKit

extension UIImage {
    
    /// 将当前图片缩放到指定宽度
    /// - parameter width: 指定宽度
    /// - returns: UIImage，如果本身比指定的宽度小，直接返回
    func scaleImageToWidth(width: CGFloat) -> UIImage {
        // 1. 判断宽度，如果小于指定宽度直接返回当前图像
        if size.width < width {
            return self
        }
        // 2. 计算等比例缩放的高度
        let height = width * size.height / size.width
        
        // 3. 图像的上下文
        let s = CGSize(width: width, height: height)
        // 提示：一旦开启上下文，所有的绘图都在当前上下文中
        UIGraphicsBeginImageContext(s)
        
        // 在制定区域中缩放绘制完整图像
        drawInRect(CGRect(origin: CGPointZero, size: s))

        // 4. 获取绘制结果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        // 5. 关闭上下文
        UIGraphicsEndImageContext()

        // 6. 返回结果
        return result
    }
    
//    剪裁部分图片
    func getSubImage(rect: CGRect) -> UIImage {
      let subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect)
      let smallBounds = CGRectMake(0, 0, CGFloat(CGImageGetWidth(subImageRef)), CGFloat(CGImageGetHeight(subImageRef)))
       UIGraphicsBeginImageContext(smallBounds.size)
       let context = UIGraphicsGetCurrentContext()
        CGContextDrawImage(context, smallBounds, subImageRef)
        let smallImage = UIImage(CGImage: subImageRef!)
        UIGraphicsEndImageContext()
        return smallImage
    }
}

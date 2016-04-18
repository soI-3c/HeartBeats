//
//  MainTabar.swift
//  Heartbeats
//
//  Created by liaosenshi on 16/3/17.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

// 自定义tabarView
class MainTabar: UIView {
   static var mainTabarView: MainTabar?
    class func currentMainTabar() -> MainTabar{
        if mainTabarView != nil {
            return mainTabarView!
        }
         self.mainTabarView = NSBundle.mainBundle().loadNibNamed("MainTabar", owner: nil, options: nil).first as? MainTabar
        mainTabarView?.backgroundColor = UIColor.clearColor()
        return mainTabarView!
    }
    @IBAction func selextControIndex(sender: UIButton) {
        selectControllerIndex?(sender.tag)
    }
    var selectControllerIndex: ((Int) -> Void)?
}

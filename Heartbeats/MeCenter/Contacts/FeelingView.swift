//
//  FeelingView.swift
//  Heartbeats
//
//  Created by iOS-3C on 16/5/2.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

/* 心情View */
class FeelingView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   func setUpUI() {
        var x: CGFloat = 0
        let y: CGFloat = 2.5
        let w: CGFloat = 35
        let h: CGFloat = 35
        for (var i = 0; i < self.imgNames.count; ++i) {
            let but = UIButton()
            but.tag = i
            but.setImage(UIImage(named: imgNames[i]), forState: .Normal)
            but.setImage(UIImage(named: "\(imgNames[i])s"), forState: .Highlighted)
            but.setImage(UIImage(named: "\(imgNames[i])s"), forState: .Selected)
            but.frame = CGRectMake( x, y, w, h);
            
            but.addTarget(self, action: "butIsSelect:", forControlEvents: .TouchUpInside)
            addSubview(but)
            x += w + 8;
        }
    }
    
    func butIsSelect(sender: UIButton) {                // 选择心情
        for subV in subviews  {
          let v = subV as? UIButton
            v?.selected = false
        }
        sender.selected = !sender.selected
        selectFeel?(imgNames[sender.tag])               // 回调选择的心情
    }
    var imgNames = ["c", "j", "k", "ku", "u"]           // 心情图片名字组
    var selectFeel: (String -> Void)?                   // 选择心情
}

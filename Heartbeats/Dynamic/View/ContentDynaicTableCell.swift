//
//  ContentDynaicTableCell.swift
//  Heartbeats
//
//  Created by liaosenshi on 16/4/21.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

class ContentDynaicTableCell: MainDynamicTableCell {
    
//    MARK: -- overide
    override func setUpUI() {
        super.setUpUI()
        contentView.addSubview(backView)
        
        backView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(topView.snp_bottom)
            make.left.right.equalTo(self)
            make.height.equalTo(screenMaimWidth)
        }
        content.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).offset(-16)
            make.centerY.equalTo(backView.center.y)
        }
    }
    
//    MARK: -- private
    override func rowHeigth(dynamic: Dynamic) -> CGFloat {
        backImageView.frame = CGRectMake(0, 0, screenMaimWidth, topView.frame.height + screenMaimWidth * 0.66 + bottomView.frame.height)
        return topView.frame.height + screenMaimWidth * 0.66 + bottomView.frame.height
    }
    
    //    MARK: -- setter/ getter
   override var dynamic: Dynamic? {
        didSet {
            content.text = dynamic?.content
            backImageView.frame = CGRectMake(0, 0, screenMaimWidth, self.rowHeigth(dynamic!))
            Tools.insertBlurView(backImageView, style: UIBlurEffectStyle.Light)
        }
    }
    
    var backView: UIView = UIView()
}


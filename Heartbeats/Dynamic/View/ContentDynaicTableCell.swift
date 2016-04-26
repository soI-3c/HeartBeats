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
        contentView.addSubview(content)
        
        backView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(topView.snp_bottom)
            make.left.right.equalTo(self)
            make.height.equalTo(screenMaimWidth)
        }
        content.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(backView.center)
            make.width.equalTo(screenMaimWidth)
        }
         backImageView.frame = CGRectMake(0, 0, screenMaimWidth, topView.frame.height + screenMaimWidth * 0.66 + bottomView.frame.height)
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
        }
    }
    
    var backView: UIView = UIView()
    var content: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.blackColor()
        lab.numberOfLines = 0
        return lab
    }()

}


//
//  ImageDynamicTableCell.swift
//  Heartbeats
//
//  Created by iOS-3C on 16/4/20.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

class ImageDynamicTableCell: MainDynamicTableCell {

//    MARK: -- override
    override func setUpUI() {
        super.setUpUI()
        contentView.addSubview(photosImgView)
        // 根据文字长度, 动态计算section的高度
    
        photosImgView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(topView.snp_bottom)
            make.left.right.equalTo(self)
            make.height.equalTo(screenMaimWidth)
        }
        content.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(photosImgView.snp_bottom)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).offset(-16)
            make.height.equalTo(45)
        }
    }

    override func rowHeigth(dynamic: Dynamic) -> CGFloat {
        return topView.frame.height + screenMaimWidth + 45 + bottomView.frame.height
    }
    
//    MARK: -- setter/ getter
    var photosImgView: UIImageView = UIImageView()
    override var dynamic: Dynamic? {
        didSet {
            content.text = dynamic?.content
            backImageView.frame = CGRectMake(0, 0, screenMaimWidth, self.rowHeigth(dynamic!))
            if let url = dynamic?.photos?.url {
                photosImgView.sd_setImageWithURL(NSURL(string: url), placeholderImage: placeholderImage)
            }
            Tools.insertBlurView(backImageView, style: UIBlurEffectStyle.Light)
        }
    }
}

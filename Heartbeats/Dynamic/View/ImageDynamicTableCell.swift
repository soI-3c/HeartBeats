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
        contentView.addSubview(content)
        // 根据文字长度, 动态计算section的高度
        let textSize =  content.text?.sizeWithAttributes([NSFontAttributeName: content.font])
    
        photosImgView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(topView.snp_bottom)
            make.left.right.equalTo(self)
            make.height.equalTo(screenMaimWidth)
        }
        content.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(photosImgView.snp_bottom)
            make.left.right.equalTo(self)
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
            photosImgView.sd_setImageWithURL(NSURL(string: (dynamic?.user?.iconImage?.url)!), placeholderImage: UIImage(named: "headImage"))
        }
    }
    var content: UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 0
        return lab
    }()
}

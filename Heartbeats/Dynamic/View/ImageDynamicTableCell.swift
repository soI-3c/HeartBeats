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
    
        photosImgView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(topView.snp_bottom)
            make.left.right.equalTo(self)
            make.height.equalTo(screenMaimWidth)
        }
        content.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(photosImgView.snp_bottom)
            make.left.right.equalTo(8)
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
            
            photosImgView.image = placeholderImage
//            let urls = Dynamic.photoUrls(dynamic!)
//            if urls?.count > 0 {
//                photosImgView.sd_setImageWithURL(NSURL(string: urls![0]), placeholderImage: placeholderImage)
//            }
            insertBlurView(backImageView, style: UIBlurEffectStyle.Light)
        }
    }
    var content: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.whiteColor()
        lab.backgroundColor = UIColor.clearColor()
        lab.numberOfLines = 0
        return lab
    }()
}

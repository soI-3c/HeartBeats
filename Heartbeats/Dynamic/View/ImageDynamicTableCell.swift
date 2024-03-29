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
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-8)
        }
        addressLabel.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(self).offset(-8)
            make.bottom.equalTo(photosImgView.snp_bottom).offset(-8)
        }
    }
    override func rowHeigth(dynamic: Dynamic) -> CGFloat {
        let contentHeight: CGFloat =  dynamic.content?.characters.count > 0 ? 25 : 0
        let praisesHeight: CGFloat =  dynamic.praises?.count > 0 ? 40 : 0
        return topView.frame.height + screenMaimWidth + contentHeight + bottomView.frame.height + praisesHeight + dynamic.commentTabVHeight + 8
    }
//  MARK: -- private func
    func addPraise(imageView: UIImageView) {                        // 点赞通知
        NSNotificationCenter.defaultCenter().postNotificationName("touchPraiseEven", object: nil, userInfo: ["dynamic" : dynamic!, "Cell": self])
    }
    
//    MARK: -- setter/ getter
   lazy var photosImgView: UIImageView = {
        let imageV = UIImageView()
        imageV.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: "addPraise:")
        tapGesture.numberOfTapsRequired = 2

        imageV.addGestureRecognizer(tapGesture)
        return imageV
    }()
    override var dynamic: Dynamic? {
        didSet {
            for view in backImageView.subviews {
                view.removeFromSuperview()
            }
            content.text = dynamic?.content
            let contentHeight = dynamic?.content?.characters.count > 0 ? 25 : 0                //      根据是否有内容来决定高度(是否显示)
            content.snp_updateConstraints(closure: { (make) -> Void in
                make.height.equalTo(contentHeight)
            })
            bottomView.snp_makeConstraints { (make) -> Void in                               
                make.top.equalTo(content.snp_bottom)
                make.left.right.equalTo(self)
                make.height.equalTo(35)
            }
            let heitht = dynamic?.cellHeight > 0 ? dynamic?.cellHeight : rowHeigth(dynamic!)
            backImageView.frame = CGRectMake(0, 0, screenMaimWidth, heitht!)
            if let url = dynamic?.photos?.url {
                photosImgView.sd_setImageWithURL(NSURL(string: url), placeholderImage: placeholderImage)
            }
            Tools.insertBlurView(backImageView, style: .Light)
            setNeedsUpdateConstraints()
        }
    }
}

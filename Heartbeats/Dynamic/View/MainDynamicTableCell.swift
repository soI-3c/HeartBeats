//
//  MainDynamicTableCell.swift
//  Heartbeats
//
//  Created by iOS-3C on 16/4/8.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

class MainDynamicTableCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
    }
    
//    MARK: -- private
    func setUpUI() {
        contentView.addSubview(backImageView)
        contentView.addSubview(topView)
        contentView.addSubview(bottomView)
        
        topView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.height.equalTo(48)
            make.left.right.equalTo(self)
        }

        bottomView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self)
            make.left.right.equalTo(self)
            make.height.equalTo(88)
        }
    }
    
    func rowHeigth(dynamic: Dynamic) -> CGFloat {
        return 0.0
    }
    func insertBlurView (view: UIView, style: UIBlurEffectStyle) {      // 毛玻璃功能
        if  view.subviews.count > 1 {
            return
        }
        view.backgroundColor = UIColor.clearColor()
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
    }

//    MARK: -- setter/ getter
    var topView: CellTopView = CellTopView.loadNibSelf()
    var bottomView : CellBottomView = CellBottomView.loadNibSelf()
    
    var backImageView : UIImageView = {                                 // 毛玻璃
        let imgView = UIImageView()
        imgView.image = placeholderImage
        return imgView
    }()
    
    var dynamic: Dynamic? {
        didSet{
            let urls = Dynamic.photoUrls(dynamic!)
            if urls?.count > 0 {
                backImageView.sd_setImageWithURL(NSURL(string: urls![0]), placeholderImage: placeholderImage)
            }
            topView.dynamic = dynamic
            bottomView.dynamic = dynamic
        }
    }
}

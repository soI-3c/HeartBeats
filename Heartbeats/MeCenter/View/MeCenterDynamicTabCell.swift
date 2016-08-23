//
//  MeCenterDynamicTabCell.swift
//  Heartbeats
//
//  Created by liaosenshi on 16/8/23.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

/** 个人中心 动态显示的 cell */
class MeCenterDynamicTabCell: UITableViewCell {
    
    private let imgV = UIImageView()
    private let deleBtn :UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .redColor()
        btn .setImage(UIImage(named: "closeIcon"), forState: .Normal)
        btn.addTarget(MeCenterDynamicTabCell.self, action: #selector(MeCenterDynamicTabCell.deleDynamic(_:)), forControlEvents: .TouchUpInside)
        return btn
    }()
    var dynamicImageUrl: String? {
        didSet {
            imgV.sd_setImageWithURL(NSURL(string: dynamicImageUrl!))
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func setUpUI() {
        backgroundColor = UIColor.clearColor()
        imgV.contentMode = .ScaleAspectFill
        contentView.addSubview(imgV)
        imgV.addSubview(deleBtn)
        imgV.snp_makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        deleBtn.snp_makeConstraints { (make) in
            make.top.equalTo(contentView.snp_top).offset(8)
            make.right.equalTo(contentView.snp_right).offset(8)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
    }
    func deleDynamic(sender: UIButton) {
        
    }
}

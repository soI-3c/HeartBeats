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
    
//    MARK: -- setter/ getter
    var topView: CellTopView = CellTopView.loadNibSelf()
    var bottomView : CellBottomView = CellBottomView.loadNibSelf()
    
    
    var dynamic: Dynamic? {
        didSet{
            topView.dynamic = dynamic
            bottomView.dynamic = dynamic
        }
    }
}

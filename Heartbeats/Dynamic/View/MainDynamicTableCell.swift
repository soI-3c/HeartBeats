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
        contentView.addSubview(content)
        contentView.addSubview(dynamicPraiseCollectionV)
        contentView.addSubview(addressLabel)
        
        addressLabel.layer.zPosition = 100              // 在图层最上面
        
        topView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.height.equalTo(48)
            make.left.right.equalTo(self)
        }
        dynamicPraiseCollectionV.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(content)
            make.top.equalTo(bottomView.snp_bottom)
            make.height.equalTo(40)
        }
    }
    
    func rowHeigth(dynamic: Dynamic) -> CGFloat {
        return 0.0
    }
//    MARK: -- setter/ getter
    let topView: CellTopView = CellTopView.loadNibSelf()
    let bottomView : CellBottomView = CellBottomView.loadNibSelf()
    
   lazy var content: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.whiteColor()
        lab.numberOfLines = 0
        return lab
    }()
    lazy var addressLabel: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .Center
        lab.textColor = UIColor.orangeColor()
        lab.alpha = 0.8
        return lab
    }()
    
    lazy var backImageView : UIImageView = {                                 // 毛玻璃
        let imgView = UIImageView()
        return imgView
    }()
    var dynamicPraiseCollectionV = DynamicPraisesCollectionView()
    
    var dynamic: Dynamic? {
        didSet{
            if let url = dynamic?.photos?.url {
                backImageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: placeholderImage)
            }
            if let address = dynamic?.address {
                addressLabel.text = "#\((address))"
            }
            let height =  dynamic?.praises?.count > 0 ? 44 : 0
             dynamicPraiseCollectionV.snp_updateConstraints { (make) -> Void in
                make.height.equalTo(height)
            }
            
            topView.dynamic = dynamic
            bottomView.dynamic = dynamic
        }
    }
}

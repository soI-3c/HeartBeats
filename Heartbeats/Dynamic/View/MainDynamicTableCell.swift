//
//  MainDynamicTableCell.swift
//  Heartbeats
//
//  Created by iOS-3C on 16/4/8.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

/*动态Cell*/
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
    
//    MARK: -- private func
    func setUpUI() {
        contentView.addSubview(backImageView)
        contentView.addSubview(topView)
        contentView.addSubview(bottomView)
        contentView.addSubview(content)
        contentView.addSubview(dynamicPraiseCollectionV)
        contentView.addSubview(dynamicCommentsView)
        contentView.addSubview(addressLabel)
        
        addressLabel.layer.zPosition = 100              // 在图层最上面
        
        topView.snp_makeConstraints { (make) -> Void in                     // topView
            make.top.equalTo(self)
            make.height.equalTo(48)
            make.left.right.equalTo(self)
        }
        dynamicPraiseCollectionV.snp_makeConstraints { (make) -> Void in    // 点赞view
            make.left.right.equalTo(self).offset(CGPoint(x: 8, y: 8))
            make.top.equalTo(bottomView.snp_bottom)
        }
        dynamicCommentsView.snp_makeConstraints { (make) -> Void in         // 评论View
            make.top.equalTo(dynamicPraiseCollectionV.snp_bottom)
            make.left.right.equalTo(content)
        }
    }
    func rowHeigth(dynamic: Dynamic) -> CGFloat {
        return 0.0
    }
    func commentTabVHeight(number: CGFloat) -> CGFloat {                         // 评论行高, 最多4行
        if number <= 4 {
            return number * 30
        }
        if number > 4 { return 4 * 30 }
        return 0
    }
    
//    MARK: -- setter/ getter
    let topView: CellTopView = CellTopView.loadNibSelf()
    let bottomView : CellBottomView = CellBottomView.loadNibSelf()
    
    lazy var content: UILabel = UILabel(title: "", fontSize: 12, textColor: UIColor.whiteColor(), backColor: UIColor.clearColor(), cornerRadius: 0);
    lazy var addressLabel: UILabel = UILabel(title: "", fontSize: 10, textColor: UIColor.orangeColor(), backColor: UIColor.clearColor(), cornerRadius: 0);
    
    lazy var backImageView : UIImageView = {                                 // 毛玻璃
        let imgView = UIImageView()
        return imgView
    }()
    var dynamicPraiseCollectionV = DynamicPraisesCollectionView()           // 点赞列表
    var dynamicCommentsView = CellCommentTabView()                          //  评论列表
    
    var dynamic: Dynamic? {
        didSet{
            if let url = dynamic?.photos?.url {
                backImageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: placeholderImage)
            }
            if let address = dynamic?.address {
                addressLabel.text = "#\((address))"
            }
            let height =  dynamic?.praises?.count > 0 ? 40 : 0
             dynamicPraiseCollectionV.snp_updateConstraints { (make) -> Void in
                make.height.equalTo(height)
            }
            dynamicCommentsView.snp_updateConstraints { (make) -> Void in
//               make.height.equalTo(self.commentTabVHeight((self.dynamic?.comments?.count)!))
                make.height.equalTo(120)
            }
            dynamicPraiseCollectionV.praises = dynamic?.praises
            topView.dynamic = dynamic
            bottomView.dynamic = dynamic
        }
    }
}

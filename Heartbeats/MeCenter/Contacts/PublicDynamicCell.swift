//
//  PublicDynamicCell.swift
//  Heartbeats
//
//  Created by liaosenshi on 16/1/6.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

protocol PublicDynamicCellDelegate: NSObjectProtocol{
    func publicDynamicCell(cell: PublicDynamicCell, converse user: HeartUser)
    func publicDynamicCell(cell: PublicDynamicCell, giveHeart user: HeartUser)
}

let HBHomeCollectionCellID = "HBHomeCollectionCellID"

class PublicDynamicCell: UICollectionViewCell {
    
//    MARK:-- 属性
//   用户
    var user: HeartUser? {
        didSet {
            if let user = user {
                let image = placeholderImage
                if let url = user.iconImage {
                   userHeadImg.sd_setImageWithURL(NSURL(string: url), forState: UIControlState.Normal, placeholderImage: image)
                }
                if let url = user.backIconImage {
                    backImageView.sd_setImageWithURL(NSURL(string: url))
                }
                username!.text = "  \(user.username)  "
                heartLabel.text = user.personality
                
                userInfos.removeAll()                   // 先删除信息中的所能内容
//               在这可对外提供一个方法,简单实现
                if user.age?.isEmpty == false{
                    userInfos.append(user.age!)
                }
                if user.sex?.isEmpty == false {
                    userInfos.append(user.sex!)
                }
                if user.academic?.isEmpty == false {
                    userInfos.append(user.academic!)
                }
                if user.height?.isEmpty == false {
                    userInfos.append(user.height!)
                }
                if user.address?.isEmpty == false {
                    userInfos.append(user.address!)
                }
//                userinfoView.infos = userInfos;       // 根据信息数据来动态创建label
            }
        }
    }
    
    var userInfos: [String] = [String]()                                    // 保存用户设置的数据,用于动态创建label显示
    
    var tapBackImageBlock: ((UIImage) -> Void)?                             // 点击背景头像的block
    
    weak var delegate: PublicDynamicCellDelegate?                           // 代理
    
    lazy var userinfoView : UserInfoShowView = UserInfoShowView()                // 显示基本信息
    lazy var userHeadImg: HBButton = {                                           //头像
        let headBtn = HBButton()
        //设置头像圆角
        //设置遮盖额外部分,下面两句的意义及实现是相同的
        headBtn.imageView?.contentMode = .ScaleAspectFit
        headBtn.layer.borderWidth = 1
        headBtn.layer.borderColor = UIColor.whiteColor().CGColor
        return headBtn
    }()

    lazy var backImageView: UIImageView = {
        let backImagV = UIImageView()
        backImagV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapBackImageView"))            //   添加点击手势
        backImagV.userInteractionEnabled = true
        backImagV.image = UIImage(named: "back")
        backImagV.contentMode = .ScaleAspectFill
        return backImagV
    }()                      // 背景图片
    
    lazy var username: UILabel? = UILabel(title: "  HeartBeats  ", fontSize: fontSize, balckBack: true)
    
//   送心Button
   lazy var giveHeartView: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: Selector("giveHeartAction:"), forControlEvents: UIControlEvents.TouchDown)
        button.setTitle("心动", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.jm_setCornerRadius(5, withBackgroundColor: .blackColor())
        return button
    }()
    lazy var chatBtn: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: Selector("giveHeartAction:"), forControlEvents: UIControlEvents.TouchDown)
        button.setTitle("聊天", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.jm_setCornerRadius(5, withBackgroundColor: .blackColor())
        return button
    }()
    
    // 心灵鸡烫
   lazy var heartLabel: UILabel = {
        let heartL = UILabel()
        heartL.textAlignment = NSTextAlignment.Center
        heartL.font = UIFont.systemFontOfSize(10)
        heartL.numberOfLines = 0
        heartL.textColor = UIColor.blackColor()
        return heartL;
    }()

//    MARK: 初始化方法
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSize(width: 8, height: 8))
        let layer = CAShapeLayer()
        layer.frame = bounds
        layer.path = path.CGPath
        self.layer.mask = layer
        setUI()
    }
//    MARK: -- 点击背景头像的事件
    func tapBackImageView() {
        if let image = backImageView.image {
            tapBackImageBlock?(image)
        }
    }
    override func prepareForReuse() {
        userHeadImg.imageView?.image = nil
        backImageView.image = nil
    }
//    MARK: -- PublicDynamicCellDelegate
    func giveHeartAction(sender: HBButton) {
        sender.transform = CGAffineTransformMakeScale(0.86, 0.86)
        UIView.animateWithDuration(0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            // 恢复默认形变
            sender.transform = CGAffineTransformIdentity
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                }, completion: { (_) -> Void in
            })
            }) { (_) -> Void in
        }
        delegate?.publicDynamicCell(self, giveHeart: user!)
    }
    func setUI() {
       contentView.addSubview(backImageView)
       contentView.addSubview(userHeadImg)
       contentView.addSubview(username!)
       contentView.addSubview(userinfoView)
       contentView.addSubview(heartLabel)
       contentView.addSubview(giveHeartView)
       contentView.addSubview(chatBtn)
        
        backImageView.snp_makeConstraints { (make) -> Void in
            make.left.top.equalTo(self).offset(4)
            make.right.equalTo(self).offset(-4)
            make.height.equalTo(self).offset( -self.frame.height * 0.35)
        }
        userHeadImg.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(backImageView)
            make.width.height.equalTo(40)
            make.centerY.equalTo(backImageView.snp_bottom)
        }
        username?.snp_makeConstraints(closure: { (make) -> Void in
            make.height.equalTo(16)
            make.left.equalTo(userHeadImg.snp_right).offset(2)
            make.top.equalTo(backImageView.snp_bottom).offset(4)
        })
        userinfoView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(15)
            make.top.equalTo((username?.snp_bottom)!).offset(4)
        }
        heartLabel.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(giveHeartView)
            make.height.equalTo(25)
            make.bottom.equalTo(giveHeartView.snp_top).offset(-16)
        }
        giveHeartView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(backImageView)
            make.right.equalTo(chatBtn.snp_left).offset(-4)
            make.width.equalTo(chatBtn)
            make.height.equalTo(27)
            make.bottom.equalTo(self.snp_bottom).offset(-4)
        }
        chatBtn.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(backImageView)
            make.height.equalTo(giveHeartView)
            make.bottom.equalTo(self.snp_bottom).offset(-4)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}



// MARK: -- CollectionView
class HBHomeCollectionView: UICollectionView {
    //    MARK: -- 根据在没图片来确定CollectionView是否显示
    var photosUrls: [String]? {
        didSet {
            if photosUrls?.count > 0 {
                reloadData()
                return
            }
        }
    }
//     MARK: -- 初始化
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // 设置布局的间距
        self.delegate = self             // 让自己成为自己的代理
        self.dataSource = self
        showsHorizontalScrollIndicator = false
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.itemSize = CGSizeMake(self.frame.width, self.frame.height)
        registerNib(UINib(nibName: "HBHomeCollectionCell", bundle: nil), forCellWithReuseIdentifier: HBHomeCollectionCellID)
    }
}
// MARK: -- CollectionView分类
extension HBHomeCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(HBHomeCollectionCellID, forIndexPath: indexPath) as! HBHomeCollectionCell
//        cell.imgUrl = photosUrls?[indexPath.row]
        return cell
    }
}

// MARK: -- CollectionViewCell
class HBHomeCollectionCell: UICollectionViewCell {
    var imgUrl: String? {
        didSet {
            if let url = imgUrl {
                photoImgView.sd_setImageWithURL(NSURL(string:url))
            }
        }
    }
    @IBOutlet weak var photoImgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
}


//
//  UserDynamicCollectionV.swift
//  Heartbeats
//
//  Created by iOS-3C on 16/6/10.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

/* 个人中心 照片显示CollectionView */
class UserDynamicCollectionV: UICollectionView {
    var dynamics: [Dynamic]? {
        didSet {
            reloadData()
        }
    }
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        bounces = false
        dataSource = self
        delegate = self
        scrollEnabled = false
        backgroundColor = UIColor.clearColor()
        registerClass(UserDynamicCollectionVCell.self, forCellWithReuseIdentifier: "userDyanmicCellID")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension UserDynamicCollectionV: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dynamics != nil ? (dynamics?.count)! + ((dynamics?.count)! == 6 ? 0 : 1) : 0
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("userDyanmicCellID", forIndexPath: indexPath) as! UserDynamicCollectionVCell
        cell.dynamicImgUrl =  indexPath.item < dynamics!.count ? dynamics![indexPath.item].photos?.url : nil
        return cell
    }
}
extension UserDynamicCollectionV: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == dynamics!.count {
            // 添加图片
            return
        }
        // 显示点击的图片
    }
}


// MARK: -- Cell
class UserDynamicCollectionVCell: UICollectionViewCell {
    var dynamicImgUrl: NSString? {
        didSet{
            if let url = dynamicImgUrl {
                dynamicImgV.sd_setImageWithURL(NSURL(string: url as String), placeholderImage: placeholderImage)
            }
        }
    }
    private let dynamicImgV = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        contentView.addSubview(dynamicImgV)
        layer.cornerRadius = 5
        clipsToBounds = true
        dynamicImgV.frame = bounds
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {                   // 当cell要进入 缓冲池的时候
        dynamicImgV.image = nil
    }
}


// MARK: -- FlowLayout
/** 个人中人动态FlowLayout */
let MAXWHSzie = UIScreen.mainScreen().bounds.size

class UserDynamicCollectionLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        itemSize = CGSize(width: MAXWHSzie.width / 3.0 - 4, height: MAXWHSzie.width / 3.0 - 4)
        minimumInteritemSpacing = 2
        minimumLineSpacing = 4
        sectionInset = UIEdgeInsets(top: 4, left: 2, bottom: 2, right: 2)
    }
}



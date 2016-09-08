//
//  UserDynamicCollectionV.swift
//  Heartbeats
//
//  Created by iOS-3C on 16/6/10.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

/* 个人中心 个人相册*/
class UserDynamicCollectionV: UICollectionView {
    var photographAlbum: [String]! {
        didSet {
            reloadData()
        }
    }
    var addImagesBlock: (() -> Void)?                       // 添加图片到相册
    var tapPhotograpAlbum: ((Int) -> Void)?              // 点击图片
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
        return photographAlbum.count + (photographAlbum.count == 6 ? 0 : 1)
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("userDyanmicCellID", forIndexPath: indexPath) as! UserDynamicCollectionVCell
        cell.dynamicImgUrl =  indexPath.item < photographAlbum.count ? photographAlbum[indexPath.item] : nil
        return cell
    }
}
extension UserDynamicCollectionV: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == photographAlbum.count {
            // 添加图片
            self.addImagesBlock?()
            return
        }
        // 显示点击的图片
        tapPhotograpAlbum?(indexPath.item)
    }
}

// MARK: -- Cell
class UserDynamicCollectionVCell: UICollectionViewCell {
    var dynamicImgUrl: NSString? {
        didSet{
            if let url = dynamicImgUrl {
                dynamicImgV.sd_setImageWithURL(NSURL(string: url as String), placeholderImage: placeholderImage)
                return
            }
            dynamicImgV.image = UIImage(named: "add")
        }
    }
    private let dynamicImgV = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        contentView.addSubview(dynamicImgV)
        layer.cornerRadius = 5
        clipsToBounds = true
        dynamicImgV.contentMode = .ScaleAspectFill
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



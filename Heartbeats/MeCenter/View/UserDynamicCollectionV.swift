//
//  UserDynamicCollectionV.swift
//  Heartbeats
//
//  Created by iOS-3C on 16/6/10.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

/*个人动态列表*/
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
        backgroundColor = UIColor.whiteColor()
        registerClass(UserDynamicCollectionVCell.self, forCellWithReuseIdentifier: "userDyanmicCellID")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension UserDynamicCollectionV: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dynamics?.count ?? 0
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("userDyanmicCellID", forIndexPath: indexPath) as! UserDynamicCollectionVCell
         let dynamic = dynamics![indexPath.item]
        cell.dynamicImgUrl = dynamic.photos?.url
        return cell
    }
}
extension UserDynamicCollectionV: UICollectionViewDelegate {

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
        backgroundColor = UIColor.whiteColor()
        contentView.addSubview(dynamicImgV)
        dynamicImgV.frame = bounds
        dynamicImgV.layer.borderWidth = 1
        dynamicImgV.layer.borderColor = UIColor.whiteColor().CGColor
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: -- FlowLayout
/** 个人中人动态FlowLayout */
let MAXWHSzie = UIScreen.mainScreen().bounds.size

class UserDynamicCollectionLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        itemSize = CGSize(width: MAXWHSzie.width / 2.0, height: MAXWHSzie.width / 2.0)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}



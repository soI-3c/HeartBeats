//
//  ImageFilterCollectionView.swift
//  Heartbeats
//
//  Created by iOS-3C on 16/4/30.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

/* 滤镜选择器 */
class ImageFilterCollectionView: UICollectionView {
    
//    MARK : -- override
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        self.dataSource = self
        self.delegate = self
        prepareLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareLayout() {
        registerClass(ImageFilterCollectionCell.self, forCellWithReuseIdentifier: "ImageFilterCellID")
        // 获得当前的布局属性
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        self.backgroundColor = UIColor.clearColor()
        layout.minimumLineSpacing = 16
        layout.itemSize = CGSizeMake(60, 80)
        self.showsHorizontalScrollIndicator = false
        layout.scrollDirection = .Horizontal
    }
    // 各种滤镜
    private let filterNames = ["CIPhotoEffectInstant", "CIPhotoEffectNoir", "CIPhotoEffectTonal", "CIPhotoEffectTransfer", "CIPhotoEffectMono", "CIPhotoEffectFade", "CIPhotoEffectProcess", "CIPhotoEffectChrome"]
    
    var selectImageFilter: (String -> Void)?                // 选择指定filter
}

extension ImageFilterCollectionView: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterNames.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
           let cell =  collectionView.dequeueReusableCellWithReuseIdentifier("ImageFilterCellID", forIndexPath: indexPath) as! ImageFilterCollectionCell
           cell.filterName = filterNames[indexPath.item]
        return cell
    }
}
extension ImageFilterCollectionView: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectImageFilter?(filterNames[indexPath.item])
    }
}


/*滤镜cell*/
class ImageFilterCollectionCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imgView)
        contentView.addSubview(title)
        
        imgView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.contentView).offset(8)
            make.left.right.equalTo(self.contentView).offset(CGPoint(x: 8, y: -8))
            make.height.equalTo(self.contentView.frame.height * 0.7)
        }
        
        title.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(imgView.snp_bottom)
            make.right.left.equalTo(imgView)
            make.height.equalTo(self.contentView.frame.height * 0.3)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "filterImage")
        return imageView
    }()
    let title: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .Center
        lab.textColor = UIColor.whiteColor()
        lab.font = UIFont(name: "", size: 13)
        return lab
    }()
    var filterName: String? {
        didSet {
           title.text = filterName
           imgView.image = Tools().imgFilterEffect(UIImage(named: "filterImage")!, filterName: filterName!)
        }
    }
}


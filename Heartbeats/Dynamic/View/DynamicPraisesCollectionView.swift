//
//  DynamicPraisesCollectionView.swift
//  Heartbeats
//
//  Created by liaosenshi on 16/4/28.
//  Copyright © 2016年 heart. All rights reserved.
//


let praisesCollectionViewCell = "PraisesCollectionViewCellID"
class DynamicPraisesCollectionView: UICollectionView {
//    MARK: -- override
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        prepareLayout()
    }
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        dataSource = self
        prepareLayout()
    }
    
//    MARK: -- private func
    private func prepareLayout() {
        // 获得当前的布局属性
        registerClass(DynamicPraisesCollectionViewCell.self, forCellWithReuseIdentifier: praisesCollectionViewCell)
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        backgroundColor = UIColor.clearColor()
        showsHorizontalScrollIndicator = false
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 3
        layout.itemSize = CGSizeMake(30,25)
    }
}

// MARK: -- dataSource
extension DynamicPraisesCollectionView : UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(praisesCollectionViewCell, forIndexPath: indexPath) as? DynamicPraisesCollectionViewCell
        cell?.imgUrl = "sdsdas"
        return cell!
    }
}

// MAKR: -- cell
class DynamicPraisesCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
    }
    
    func setUpUI() {
        contentView.addSubview(imgView)
        imgView.frame = bounds
    }
    
    var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 30 / 2
        imgView.layer.masksToBounds = true
        imgView.layer.borderWidth = 1.0
        imgView.layer.borderColor = UIColor.whiteColor().CGColor
        return imgView
    }()
    var imgUrl : String? {
        didSet {
            imgView.sd_setImageWithURL(NSURL(string: imgUrl!), placeholderImage: UIImage(named: "u3"))
        }
    }
}




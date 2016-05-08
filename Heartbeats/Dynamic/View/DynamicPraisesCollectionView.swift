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
    func prepareLayout() {
        dataSource = self
        // 获得当前的布局属性
        registerClass(DynamicPraisesCollectionViewCell.self, forCellWithReuseIdentifier: praisesCollectionViewCell)
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .Horizontal
        backgroundColor = UIColor.clearColor()
        showsHorizontalScrollIndicator = false
        let margin: CGFloat = 2;
        let itemWH = itemWHWithCount(8, margin: margin)
        
        layout.itemSize = CGSizeMake(itemWH, itemWH);
        layout.minimumInteritemSpacing = margin;
        layout.minimumLineSpacing = margin;
        layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    }
    func itemWHWithCount(var count: CGFloat, margin: CGFloat) -> CGFloat {
        var itemWH: CGFloat = 0;
        let width = screenMaimWidth - 32;
        repeat {
            let wh = (width - (count + 1) * margin) / count
            itemWH = floor(wh)
            count++;
        } while (itemWH > 30);
        return itemWH;
    }

}

// MARK: -- dataSource
extension DynamicPraisesCollectionView : UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
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
            imgView.sd_setImageWithURL(NSURL(string: imgUrl!), placeholderImage: placeholderImage)
        }
    }
}




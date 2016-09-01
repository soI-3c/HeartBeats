//
//  BrowseImageController.swift
//  Heartbeats
//
//  Created by liaosenshi on 16/9/1.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

/** 个人中心的图片浏览器 */
private let reuseIdentifier = NSStringFromClass(BrowseImageCell.self)
class BrowseImageController: UICollectionViewController {
    var imageUrls: [String]!
    var selectIdx: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        self.collectionView!.registerClass(BrowseImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    override func viewWillAppear(animated: Bool) {
//        collectionView?.scrollToItemAtIndexPath(NSIndexPath(index: selectIdx), atScrollPosition: .Right, animated: true)
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! BrowseImageCell
        cell.imgUrl = imageUrls[indexPath.item]
        return cell
    }
    private func setUpUI() {
        collectionView?.backgroundColor = .redColor()
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .Horizontal
        layout.itemSize = CGSizeMake(320, 400)
//        collectionView?.showsHorizontalScrollIndicator = false
    }
}
/* cell */
class BrowseImageCell: UICollectionViewCell {
    var imgUrl: String! {
        didSet {
            print(imgUrl)
            imgView.sd_setImageWithURL(NSURL(string: imgUrl))
        }
    }
   private let imgView: UIImageView =  {
        let imgV = UIImageView()
        imgV.contentMode = .ScaleAspectFit
        return imgV
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUpUI() {
        contentView.addSubview(imgView)
        imgView.frame = bounds
//        imgView.snp_makeConstraints { (make) in
//            make.edges.equalTo(contentView)
//        }
    }
}
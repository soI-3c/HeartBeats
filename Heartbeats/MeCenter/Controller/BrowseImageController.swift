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
    var imageUrls: [String]! {
        didSet {
            collectionView?.reloadData()
        }
    }
    var selectIdx: Int!
    var deleImageAction: ((Int, UIButton) -> Void)?           // 删除
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        self.collectionView!.registerClass(BrowseImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    override func viewWillAppear(animated: Bool) {
        collectionView?.scrollToItemAtIndexPath(NSIndexPath(index: selectIdx), atScrollPosition: .Right, animated: true)
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! BrowseImageCell
        cell.imgUrl = imageUrls[indexPath.item]
        cell.deleImageBlock = { [weak self](cell, sender) -> Void in
            self!.deleAction(cell, sender: sender)                      // 删除图片
        }
        return cell
    }
    private func setUpUI() {
        collectionView?.backgroundColor = .clearColor()
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .Horizontal
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSizeMake(collectionView!.frame.size.width, collectionView!.frame.size.height)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.pagingEnabled = true
    }
    // 删除图片
    private func deleAction(cell: BrowseImageCell, sender: UIButton){
       let idx = collectionView?.indexPathForCell(cell)?.item
        print(imageUrls[idx!])
        let fileQuery = AVFile.query()
        fileQuery.whereKey("url", equalTo: imageUrls[idx!])
        fileQuery.findFilesInBackgroundWithBlock { (result, error) in
            if error == nil {
                    self.imageUrls.removeAtIndex(idx!)
                    self.deleImageAction?(idx!, sender)
                    self.collectionView?.reloadData()
                    sender.userInteractionEnabled = true
                (result.first as? AVFile)?.deleteInBackgroundWithBlock({[weak self](b, error) in
                })
            }else {
                sender.userInteractionEnabled = true
                SVProgressHUD.showInfoWithStatus("删除失败")
            }
        }
    }
}
/* cell */
class BrowseImageCell: UICollectionViewCell {
    var deleImageBlock: ((BrowseImageCell, UIButton) -> Void)?           // 删除

    var imgUrl: String! {
        didSet {
            imgView.sd_setImageWithURL(NSURL(string: imgUrl))
        }
    }
   private let imgView: UIImageView =  {
        let imgV = UIImageView()
        imgV.contentMode = .ScaleAspectFit
        return imgV
    }()
   private lazy var deleBtn: UIButton = {
        let btn = UIButton(frame: CGRectMake(100, 100, 100, 100))
        btn.setImage(UIImage(named: "closeIcon"), forState: .Normal)
        btn.addTarget(self, action: "deleAction:", forControlEvents: .TouchUpInside)
        return btn
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
        contentView.addSubview(deleBtn)
        imgView.frame = bounds
    }
    func deleAction(sender: UIButton){              // 删除按钮
        sender.userInteractionEnabled = false
        self.deleImageBlock?(self, sender)
    }
}
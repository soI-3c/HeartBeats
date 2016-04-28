//
//  MeCenterCell.swift
//  Heartbeats
//
//  Created by liaosenshi on 15/12/18.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit

let HBColleectionCellID = "HBColleectionCellID"
let HBPhotoItemMargin: CGFloat = 0.0

let HBCollectionCellItemWidth = 42
let HBCollectionCellItemHeight = 50

//MARK : ---- 个人中心Cell
class MeCenterCell: UITableViewCell {

   var dynamic: Dynamic? {
        didSet {
            if dynamic != nil {
                contentLabel.text = dynamic?.content
                let urls = Dynamic.photoUrls(dynamic!)
//                photosCollectionView.photosUrls = urls
//                dateSoureUrls = urls
                photosCollectionView.reloadData()
            }
        }
    }
    var dateSoureUrls: [String]?
    @IBOutlet weak var contentLabel: UILabel!

    @IBOutlet weak var photosCollectionView: HBCollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(false, animated: true)
    }
}

class HBCollectionView: UICollectionView {
//    MARK: -- 根据在没图片来确定CollectionView是否显示
   var photosUrls: [String]? {
        didSet {
            if photosUrls?.count > 0 {
                reloadData()
              return
            }
            translatesAutoresizingMaskIntoConstraints = true
            frame.size = CGSizeZero
        }
    }
    override func awakeFromNib() {
        dataSource = self
        delegate = self
        // 设置布局的间距
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = HBPhotoItemMargin
        layout.minimumLineSpacing = HBPhotoItemMargin
        layout.itemSize = calcViewSize()
        registerNib(UINib(nibName: "HBCollectionCell", bundle: nil), forCellWithReuseIdentifier: HBColleectionCellID)
    }
    /// 根据模型中的图片数量来计算视图大小
    private func calcViewSize() -> CGSize {
        // 1. 准备工作
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        // 设置默认大小
        layout.itemSize = CGSize(width: HBCollectionCellItemWidth , height: HBCollectionCellItemHeight)
        // 2. 根据图片数量来计算大小
        let count = photosUrls?.count ?? 0
        //
        //        // 1张图
        if count == 1 {
            return self.frame.size
        }
        return frame.size
    }
}

extension HBCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosUrls?.count ?? 0
    }
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(HBColleectionCellID, forIndexPath: indexPath) as! HBCollectionCell
        
        cell.imgUrl = photosUrls?[indexPath.row]
        return cell
    }
}

class HBCollectionCell: UICollectionViewCell {
    var finishedCallBack: (() -> ())?
    var imgUrl: String? {
        didSet {
           if let url = imgUrl {
                photoImgView.image = nil
                self.photoImgView.sd_setImageWithURL(NSURL(string:url))
            }
        }
    }
    var showImage: UIImage? {
        didSet {
            photoImgView.image = nil
            photoImgView.image = showImage
        }
    }
    @IBOutlet weak var scrollV: UIScrollView!
    @IBOutlet weak var photoImgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImgView.contentMode = .ScaleAspectFit
        scrollV.minimumZoomScale = 0.5
        scrollV.maximumZoomScale = 2.0
        scrollV.delegate = self
        scrollV.contentSize = photoImgView.frame.size
    }
}

extension HBCollectionCell: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return photoImgView
    }
    func scrollViewDidScroll(scrollView: UIScrollView){
    }
    func scrollViewDidZoom(scrollView: UIScrollView) {
    }
}

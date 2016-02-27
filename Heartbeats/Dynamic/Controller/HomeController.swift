//
//  DynamicController.swift
//  Heartbeats
//
//  Created by iOS-3C on 15/11/15.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit


class HomeController: UICollectionViewController {

    // 实现 init() 构造函数，方便外部的代码调用，不需要额外指定布局属性
    init() {
        // 调用父类的默认构造函数
        super.init(collectionViewLayout: DWFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.backgroundColor = UIColor.whiteColor()
        // 注册可重用 cell
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "HMNewFeatureCellID")
        
        prepareLayout()
    }
    
    /// 1. 准备布局
    private func prepareLayout() {
        // 获得当前的布局属性
        let layout = collectionView?.collectionViewLayout as! DWFlowLayout
        
        layout.itemSize = CGSize(width: self.view.frame.width * 0.7, height: self.view.frame.height * 0.6)
          collectionView?.showsHorizontalScrollIndicator = false
    }
    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HMNewFeatureCellID", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.blackColor()
        return cell
    }
  
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    }
}


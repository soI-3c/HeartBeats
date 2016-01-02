//
//  ContactsCollectionViewController.swift
//  Heartbeats
//
//  Created by liaosenshi on 15/12/15.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
 let cellId = "cellId";
 let cellId2 = "cellId2";
class ContactsCollectionViewController: UICollectionViewController {
    
    var layout = AWCollectionViewDialLayout(radius: 0.39, andAngularSpacing: 0.16, andCellSize: CGSize(width: screenMaimWidth * 0.5, height: 200), andAlignment: 1 , andItemHeight: 80, andXOffset: 0.23)
    
    init() {
        // 调用父类的默认构造函数
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var items: [AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = [["name": "Dwayne Wade", "picture": "dwayne_wade.png"], ["name": "Dwayne Wade", "picture": "dwayne_wade.png"], ["name": "Dwayne Wade", "picture": "dwayne_wade.png"], ["name": "Dwayne Wade", "picture": "dwayne_wade.png"], ["name": "Dwayne Wade", "picture": "dwayne_wade.png"]]
      
        // Register cell classes
        collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.registerNib(UINib(nibName: "Contact", bundle: nil), forCellWithReuseIdentifier: cellId)
         collectionView?.registerNib(UINib(nibName: "dialCell2", bundle: nil), forCellWithReuseIdentifier: cellId2)
        prepareLayout()
    }



    /// 1. 准备布局
    private func prepareLayout() {
        // 获得当前的布局属性
        let layout = collectionView?.collectionViewLayout as! AWCollectionViewDialLayout
        collectionView?.backgroundColor = UIColor.whiteColor()
        var radius: CGFloat = 0
        var angularSpacing: CGFloat  = 0
        var xOffset: CGFloat = 0
        layout.cellSize = CGSize(width: screenMaimWidth * 0.7, height: screenMaimheiht * 0.15)
        layout.wheelType = 0
        
        radius = 310;
        angularSpacing = 16;
        xOffset = 80;
        layout.xOffset = xOffset
        layout.dialRadius = radius
        layout.AngularSpacing = angularSpacing
        collectionView?.reloadData()
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 20
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath)
        cell.backgroundColor =  indexPath.row % 2 == 0 ? UIColor.yellowColor() : UIColor.redColor()
        return cell
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let showView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        showView.backgroundColor = UIColor.redColor()
        let window = UIApplication.sharedApplication().delegate?.window!
         let modal = PathDynamicModal.show(modalView: showView, inView: window!)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}

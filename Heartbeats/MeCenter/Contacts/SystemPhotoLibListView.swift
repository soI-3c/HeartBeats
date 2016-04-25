//
//  SystemPhotoLibListView.swift
//  Heartbeats
//
//  Created by liaosenshi on 16/4/25.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

/* 所有相册View*/

let photoLibCellID = "photoLibCellID"
class SystemPhotoLibListView: UITableView, UITableViewDataSource, UITableViewDelegate {
//    MARK: -- override
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        registerClass(UITableViewCell.self, forCellReuseIdentifier: photoLibCellID)
        dataSource = self
        delegate = self
        loadLibPhotos()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK : -- private
    func loadLibPhotos() {
        tableFooterView = UIView()
        self.bounces = false
       photoLib.enumerateGroupsWithTypes(ALAssetsGroupAll, usingBlock: { (group, _) -> Void in
        if group != nil {
             self.assetGroups.append(group)
        }
        self.reloadData()
        }) { (_) -> Void in
        }
    }
    
//    MAR: -- setter/ getter
    lazy var photoLib: ALAssetsLibrary = ALAssetsLibrary()              // 系统资源
    lazy var assetGroups: [ALAssetsGroup] = [ALAssetsGroup]()           // 所在相册
    lazy var assets: NSMutableArray = NSMutableArray()                  // 指定相册中的Asset
     var selectPhotoGroup: ((NSMutableArray, String) -> Void)?                    // 选择指定相册
}

extension SystemPhotoLibListView {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return assetGroups.count ?? 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       var cell = tableView.dequeueReusableCellWithIdentifier(photoLibCellID) as? SystemPhotoLibCell
        if cell == nil {
            cell = SystemPhotoLibCell(style: .Subtitle, reuseIdentifier: photoLibCellID)
        }
        let group = assetGroups[indexPath.row]
        let imageCGF = group.posterImage().takeRetainedValue()
        cell!.textLabel?.text = group.valueForProperty(ALAssetsGroupPropertyName) as? String
        cell!.detailTextLabel?.text = "\(group.numberOfAssets())"
        cell?.imageView?.image = UIImage(CGImage: imageCGF)
        return cell!
    }
}
extension SystemPhotoLibListView {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 86
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let group = assetGroups[indexPath.row]
        assets.removeAllObjects()
        group.setAssetsFilter(ALAssetsFilter.allPhotos())
        group.enumerateAssetsWithOptions(.Reverse, usingBlock: { (asset, idx, _) -> Void in
            if asset != nil {
                self.assets.addObject(asset)
            }
        })
        selectPhotoGroup?(assets, group.valueForProperty(ALAssetsGroupPropertyName) as! String)               // 回调选择的相册
    }
}

class SystemPhotoLibCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var frame: CGRect{                                         // 复写frame, 为了让每个cell之间有间距
       get{
           return super.frame
       }
       set{
           let frame = CGRectMake(newValue.origin.x, newValue.origin.y - 8, newValue.size.width, newValue.size.height - 8)
           super.frame = frame
       }
    }
}




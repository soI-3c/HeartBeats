//
//  DynamicTableViewController.swift
//  Heartbeats
//
//  Created by liaosenshi on 16/3/17.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

let MainDynamicCellID = "MainDynamicCellID"


enum DynamicCellID : String {
    case imageCellID = "imageCellID"
    case contentCellID = "contentCellID"
    static func cellID(dynamic: Dynamic) -> String {
       return dynamic.photos != nil ? imageCellID.rawValue : contentCellID.rawValue
    }
}
let imageCellID = "imageCellID"
let contentCellID = "contentCellID"
class DynamicTableViewController: UITableViewController {
    
//    MARK:-- Override
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = true
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerClass(ImageDynamicTableCell.self, forCellReuseIdentifier: DynamicCellID.imageCellID.rawValue)
        tableView.registerClass(ContentDynaicTableCell.self, forCellReuseIdentifier: DynamicCellID.contentCellID.rawValue)
        
        
        // 提示：如果不使用自动计算行高，UITableViewAutomaticDimension，一定不要设置底部约束
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
        
//        将backgroundView的高提高® 20, 设置,毛玻璃
        tableView.backgroundView = backImageView
        tableView.backgroundView?.frame = CGRectMake(0, 0, screenMaimWidth, (tableView.backgroundView?.frame.height)! + 20)
        view.setNeedsLayout()
        Tools.insertBlurView(backImageView, style: .Light)
    }
    
//    MARK: -- private
    func loadData() {
        NetworkTools.loadDynamics { (result, error) -> () in
            if error == nil {
                self.dynamics = result as? [Dynamic]
            }
        }
    }
//    MARK: -- getter / setter
    var en: DynamicCellID = DynamicCellID.imageCellID       // cell ID
    
    var scrollUporDown: Bool = false                        // 用于判断table的上下滚动
    var newY: CGFloat = 0
    var oldY: CGFloat = 0
    
    var dynamics: [Dynamic]? {                              // 动态s
        didSet {
            tableView.reloadData()
        }
    }
    var backImageView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = placeholderImage
        return imgView
    }()                       // 动态背景图片, 毛玻离
}

// MARK: --- Dasoure
extension DynamicTableViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dynamics?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> MainDynamicTableCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(DynamicCellID.cellID(dynamics![indexPath.item]), forIndexPath: indexPath) as! MainDynamicTableCell
        cell.dynamic = dynamics![indexPath.item]
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let dynamic = dynamics?[indexPath.item]             // 先取缓存行高, 没有再计算
        if  dynamic?.cellHeight > 0 {
            return dynamic!.cellHeight
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(DynamicCellID.cellID(dynamics![indexPath.item])) as! MainDynamicTableCell
        dynamic!.cellHeight = cell.rowHeigth(dynamic!)
        return cell.rowHeigth(dynamic!)
    }
}



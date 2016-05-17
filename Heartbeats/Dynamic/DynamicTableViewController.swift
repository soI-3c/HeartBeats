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
        // 改变点赞通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changePraises:", name: "touchPraiseEven", object: nil)
        
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
    deinit {                                            // 移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
//    MARK: -- private func
    func loadData() {
        NetworkTools.loadDynamics { (result, error) -> () in
            if error == nil {
                self.dynamics = result as? [Dynamic]
            }
        }
    }
    
//   点赞刷新指定点赞列表
    func changePraises(notification: NSNotification) {
       let user = HeartUser.currentUser()
       let info = notification.userInfo
        let indexPath = self.tableView.indexPathForCell(info!["Cell"] as! MainDynamicTableCell)
        
       let dynamic = info!["dynamic"] as! Dynamic
        
       var praises = dynamic.praises                                                                        // 取消点赞
        for var i = 0; i < praises?.count; ++i {
            let praise = praises![i] as? DynamicPraise
            if praise?.userID == HeartUser.currentUser().objectId {
                dynamic.removeObject(praise, forKey: "praises")
                praise?.deleteInBackground()
                dynamic.cellHeight = 0
                self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .None)                // 刷新指定行
                self.tableView.setNeedsLayout()
                praiseAnimation(false)
                dynamic.saveInBackground()
                return
            }
        }
        
        // 点赞
        let praise = DynamicPraise(dynamicID: dynamic.objectId, userID: user.objectId, userHeadImg: user.iconImage, userName: user.username)
        dynamic.addUniqueObject(praise, forKey: "praises")
        dynamic.cellHeight = 0                                                                    // 解决缓存行高没法刷新到点赞
        dynamic.saveInBackgroundWithBlock({ (success, error) -> Void in
            if error == nil {
                self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .None)        // 刷新指定行
                self.tableView.setNeedsLayout()
                self.praiseAnimation(true)
            }
        })

    }
    // 点赞动画
    private func praiseAnimation(isPraise: Bool) {
        let praiseView = UIImageView(image: UIImage(named: "praise"))
        let window = UIApplication.sharedApplication().delegate?.window
        praiseView.center = window!!.center
        praiseView.sizeToFit()
        window!!.addSubview(praiseView)
        UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 6, initialSpringVelocity: 10, options: .CurveEaseInOut, animations: { () -> Void in
                if isPraise == true {
                    praiseView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI * 0.5))
                    praiseView.transform = CGAffineTransformRotate(praiseView.transform, CGFloat(M_PI * 0.5))
                }else {
                      praiseView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                }
            }) { (_) -> Void in
                praiseView.removeFromSuperview()
        }
    }
    
//    MARK: -- getter / setter
    var en: DynamicCellID = DynamicCellID.imageCellID       // cell ID
    var dynamics: [Dynamic]? {                              // 动态s
        didSet {
            dynamics?.forEach({ (dynamic) -> () in                      // 计算评论显示的高度
                var commentsHeight: CGFloat = 0
                dynamic.comments?.forEach({ (comment) -> () in
                    let (_, height) = Tools.cellContentWithCellHeight(comment as! DynamicComment)
                    commentsHeight += height
                })
                dynamic.commentTabVHeight = commentsHeight
            })
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
        let dynamic = dynamics?[indexPath.item]             // 先取缓存行高, 没有, 再计算
        if  dynamic?.cellHeight > 0 {
            return dynamic!.cellHeight
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(DynamicCellID.cellID(dynamics![indexPath.item])) as! MainDynamicTableCell
        dynamic!.cellHeight = cell.rowHeigth(dynamic!)
        return cell.rowHeigth(dynamic!)
    }
}



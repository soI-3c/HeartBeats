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
       return dynamic.photos?.count > 0 ? imageCellID.rawValue : contentCellID.rawValue
    }
}
let imageCellID = "imageCellID"
let contentCellID = "contentCellID"
class DynamicTableViewController: UITableViewController {
    
//    let contents = ["yesh, you know, lalalala, you need to change...", "有些路，通往哪里并不重要，重要的是你会在路上看到什么样的风景。", "We all go through thunderstorms, but not every one of us make it", "The only way to get what you really want, is to know what you really want. And the only way to know what you really want, is to know yourself.", "o keep a relationship with love: Admit it whenever you’re wrong， and when you’re right， shut up", "走向最远的方向——哪怕前路迷茫；抱着最大的希望——哪怕山穷水尽；坚持最强的意志——哪怕刀山火海；做好最坏的打算——哪怕从头再来。", "因为，你的努力终究不是为了别人，别人的评价也未必是你真实的自己", "我们每个人都有不同的处世方式，就像一串葡萄到手后，有人挑最好的先吃，有人把好的留到最后吃。", "生命好在无意义，才容得下各自赋予意义。假如生命是有意义的，这个意义却不合我的志趣，那才尴尬狼狈。"];
    
//    MARK:-- Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        for var i = 0; i <= 2; ++i {
//            let dynamic = Dynamic()
//            dynamic.user = HeartUser.currentUser()
////            let imgNumber = Int(arc4random() % 5)
////            let file = HBAVFile(name: "contentImg.png", data: UIImagePNGRepresentation(UIImage(named: "u\(i)")!))
////            dynamic.photos = [file]
//            dynamic.content = contents[i]
//            dynamic.saveInBackground()
//        }
        self.navigationController?.navigationBar.translucent = true
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerClass(ImageDynamicTableCell.self, forCellReuseIdentifier: DynamicCellID.imageCellID.rawValue)
        tableView.registerClass(ContentDynaicTableCell.self, forCellReuseIdentifier: DynamicCellID.contentCellID.rawValue)
        
        // 提示：如果不使用自动计算行高，UITableViewAutomaticDimension，一定不要设置底部约束
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
        loadData()
    }
    var en: DynamicCellID = DynamicCellID.imageCellID
    
//    override func scrollViewDidScroll(scrollView: UIScrollView) {
//        if scrollView.isEqual(tableView) {
//            newY = scrollView.contentOffset.y
//            if newY != oldY {
//                scrollUporDown = newY > oldY ? true: false
//            }
//            oldY = newY
//        }
//        if scrollUporDown == true {
//            UIView.animateWithDuration(0.5, animations: { () -> Void in
//                    self.navigationController?.navigationBar.frame = CGRectMake(0, -44, screenMaimWidth, 44)
//                }, completion: { (_) -> Void in
//            })
//        }else {
//            UIView.animateWithDuration(0.5, animations: { () -> Void in
//                self.navigationController?.navigationBar.frame = CGRectMake(0, 20, screenMaimWidth, 44)
//                }, completion: { (_) -> Void in
//            })
//        }
//    }
    
//    MARK: -- private
    func loadData() {
        NetworkTools.loadDynamics { (result, error) -> () in
            if error == nil {
                self.dynamics = result as? [Dynamic]
            }else {
                print(error)
            }
        }
    }
    
//    MARK: -- getter / setter
    var scrollUporDown: Bool = false            // 用于判断table的上下滚动
    var newY: CGFloat = 0
    var oldY: CGFloat = 0
    
    var dynamics: [Dynamic]? {                 // 动态s
        didSet {
            tableView.reloadData()
        }
    }
}

// MARK: --- Dasoure
extension DynamicTableViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


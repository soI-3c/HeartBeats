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

//    MARK:-- Override
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.translucent = true
        tableView.registerClass(ImageDynamicTableCell.self, forCellReuseIdentifier: DynamicCellID.imageCellID.rawValue)
        tableView.registerClass(ContentDynaicTableCell.self, forCellReuseIdentifier: DynamicCellID.contentCellID.rawValue)
        // 提示：如果不使用自动计算行高，UITableViewAutomaticDimension，一定不要设置底部约束
        tableView.estimatedRowHeight = 400
        
        loadData()
    }
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.isEqual(tableView) {
            newY = scrollView.contentOffset.y
            if newY != oldY {
                scrollUporDown = newY > oldY ? true: false
            }
            oldY = newY
        }
        if scrollUporDown == true {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.navigationController?.navigationBar.frame = CGRectMake(0, -44, screenMaimWidth, 44)
                }, completion: { (_) -> Void in
            })
        }else {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.navigationController?.navigationBar.frame = CGRectMake(0, 20, screenMaimWidth, 44)
                }, completion: { (_) -> Void in
            })
        }
    }
    
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


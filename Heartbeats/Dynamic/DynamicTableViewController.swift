//
//  DynamicTableViewController.swift
//  Heartbeats
//
//  Created by liaosenshi on 16/3/17.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

let MainDynamicCellID = "MainDynamicCellID"

class DynamicTableViewController: UITableViewController {
    var scrollUporDown: Bool = false
    var newY: CGFloat = 0
    var oldY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.translucent = true
        tableView.registerNib(UINib(nibName: "MainDynamicTableCell", bundle: nil), forCellReuseIdentifier: MainDynamicCellID)
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
//    MARK: --根据滚动方向隐藏导航栏
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
    }
extension DynamicTableViewController {
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> MainDynamicTableCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MainDynamicCellID, forIndexPath: indexPath) as! MainDynamicTableCell
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return screenMaimheiht * 0.65;
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


//
//  PublicDynamicController.swift
//  Heartbeats
//
//  Created by liaosenshi on 16/1/6.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit
import WebKit

let HBPublicDynamicCellID = "HBPublicDynamicCellID"
class PublicDynamicController: UITableViewController, UITextViewDelegate {
//    MARK: -- 懒加载属性
    lazy var headView : UITextView  = {
        let view = UITextView(frame: CGRect(x: 0, y: 0, width: screenMaimWidth, height: screenMaimheiht * 0.3))
        view.text = " 这一刻, 你想说什么..."
        view.delegate = self
        return view
    }()
    lazy var pictureSelectView: UIView = {
        // 图片选择器
        let view = self.pictureSelectController.view
        view.frame = CGRect(x: 0, y: 0, width: screenMaimWidth, height: 400)
        return view
    }()
   lazy var pictureSelectController = PictureSelectorViewController()   // 图片选择器
    
    
    private lazy var logoLabel: UILabel = {
        let logo = UILabel(frame: CGRect(x: 0, y: 0, width: 414, height: 50))
        logo.text = "HeartBeats"
        logo.textAlignment = NSTextAlignment.Center
        logo.font = UIFont.systemFontOfSize(35)
        return logo
    }()
    
//    MARK: -- 初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "发布动态"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Done, target: self, action: "cancelAction:")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style:UIBarButtonItemStyle.Done, target: self, action: "publicDynamicAction")
        
//        添加通知.当TextView修改的时候
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textViewBeginEndEditing", name: UITextViewTextDidBeginEditingNotification, object: headView)


        addChildViewController(pictureSelectController)
        tableView.addSubview(logoLabel)
        tableView.tableHeaderView =  headView
        tableView.tableFooterView = pictureSelectView
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: HBPublicDynamicCellID)
    }
    
    //记得移除通知监听
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
//    MARK: -- 取消发布
    func cancelAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    //    MARK: -- 发表动态
    func publicDynamicAction() {
        let dynamic = Dynamic()
        dynamic.content = headView.text
        dynamic.user = HeartUser.currentUser()
        let images = pictureSelectController.pictures           // 获取用户要发表图片
    
        for var i = 0; i < images.count ; ++i {
            let imageData = UIImagePNGRepresentation(images[i])
            let fileData = HBAVFile(data: imageData)
            fileData.saveInBackgroundWithBlock({ (success, e) -> Void in
                 if success == true {
                    dynamic.addObject(fileData, forKey: HBDynamicPhotos)
                        dynamic.saveInBackgroundWithBlock { (success, error) -> Void in
                            if success == true {
                                Tools.showSVPMessage("发表成功")
                                return
                            }
                            Tools.showSVPMessage("发表失败")
                    }
                }
            })
        }
    }
    func textViewBeginEndEditing() {
        headView.text = ""
        headView.textColor = UIColor.blackColor()
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(HBPublicDynamicCellID, forIndexPath: indexPath)
        cell.backgroundColor = UIColor(white: 0.9, alpha: 0.6)
        cell.textLabel?.text = "地点 "
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    
    // Override to support conditional editing of the table view.
//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }

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

}

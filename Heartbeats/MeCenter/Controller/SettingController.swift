//
//  SettingController.swift
//  Heartbeats
//
//  Created by liaosenshi on 15/12/28.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit

class SettingController: UITableViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var academicLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var isHaveHouseLabel: UILabel!
    @IBOutlet weak var isHaveCarLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var personalityLabel: UITableViewCell!
    
    @IBOutlet weak var cellShowText: UILabel!
    private var user: HeartUser?
    
    var currUser: HeartUser? {
        set {
           if let newUser = newValue {
                   self.user = newUser
            }
        }
        get {
            return self.user
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = false
        prepare()
    }
    private func prepare() {
        if let username = user?.username {
            usernameLabel.text = username
        }
        if let mobilePhoneNumber = user!.mobilePhoneNumber {
            phoneLabel.text = mobilePhoneNumber
        }
        if let age = user?.age {
              ageLabel.text = age
        }
        if let sex = user?.sex {
                sexLabel.text = sex
        }
        if let academic = user?.academic {
            academicLabel.text = academic
        }
        if let height = user?.height {
            heightLabel.text = height
        }
        if let income = user?.income {
            incomeLabel.text = income
        }
        if let car = user?.car {
            isHaveCarLabel.text = car
        }
        if let house = user?.house {
            isHaveHouseLabel.text = house
        }
    }
//    MARK: -- 退出登陆
    @IBAction func loginOutAction(sender: UIButton) {
        let userIconAlert = UIAlertController(title: "是否确定退出登陆?", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let loAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: loginOutHandler)
        let canelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel,handler: nil)
         userIconAlert.addAction(loAction)
         userIconAlert.addAction(canelAction)
        self.presentViewController(userIconAlert, animated: true, completion: nil)
    }
    private func loginOutHandler(avc:UIAlertAction) -> Void {
          HeartUser.logOut()
    }
//   MARK: --  tableViewDelegate
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let (showView, _) = self.loadNameWithPhoneView("NameWithPhoneSetView")
             showView.editTextField.text = user?.username
            showView.changeHandler = {(objStr) -> Void in
                self.user?.username = objStr
            }
        }else if indexPath.row == 1 {
            let (showView, _) = self.loadNameWithPhoneView("NameWithPhoneSetView")
             showView.editTextField.text = user?.mobilePhoneNumber
            showView.changeHandler = {(objStr) -> Void in
                self.user?.mobilePhoneNumber = objStr
            }
        }else if indexPath.row == 9 {
            let (showView, _) = self.loadNameWithPhoneView("PersonalitySetView")
            (showView as? PersonalitySetView)?.editTextView.text = user?.personality
            showView.changeHandler = {(objStr) -> Void in
                self.user?.personality = objStr
            }
        }else {
            let (showView, _) = self.loadNameWithPhoneView("MoreAttributeSetView")
           (showView as? MoreAttributeSetView)?.soureCome = indexPath.row
            switch  indexPath.row {
            case 2 :
                showView.changeHandler = {(objStr) -> Void in
                    self.user?.sex? =  objStr
                }
            case 3:
                showView.changeHandler = {(objStr) -> Void in
                    self.self.user?.age = objStr
                }
            case 4 :
                showView.changeHandler = {(objStr) -> Void in
                    self.self.user?.height = objStr
                }
            case 5:
                showView.changeHandler = {(objStr) -> Void in
                    self.user?.academic = objStr
                }
            case 6 :
                showView.changeHandler = {(objStr) -> Void in
                    self.user?.income = objStr
                }
            case 7:
                showView.changeHandler = {(objStr) -> Void in
                    self.user?.house = objStr
                }
            default:
                showView.changeHandler = {(objStr) -> Void in
                    self.user?.car = objStr
                }
            }

        }
        prepare()
    }
    
    private func loadNameWithPhoneView(classString: String) -> (view: NameWithPhoneSetView, modal: PathDynamicModal) {
        let showView = Tools.instantiateFromNib(classString, widthPercen: 0.65, hieghtPercen: 0.4) as! NameWithPhoneSetView
        let window = UIApplication.sharedApplication().delegate?.window!
        let modal = PathDynamicModal.show(modalView: showView, inView: window!)
        
        showView.changeSaveActionHandler = {() -> Void in
            modal.closeWithLeansRight()
            self.user?.saveInBackground()
        }
        showView.closeHandler = {() -> Void in
            modal.closeWithLeansLeft()
            return
        }
        return (showView, modal)
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

}
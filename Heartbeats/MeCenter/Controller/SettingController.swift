//
//  SettingController.swift
//  Heartbeats
//
//  Created by liaosenshi on 15/12/28.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit

typealias changeUserInfo = (HeartUser) -> Void

/** 个人设置 */
class SettingController: UITableViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var academicLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var isHaveHouseLabel: UILabel!
    @IBOutlet weak var isHaveCarLabel: UILabel!
    @IBOutlet weak var addressLab: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var personalityLabel: UITableViewCell!
    @IBOutlet weak var cellShowText: UILabel!
    
    var isChanged : Bool = false                // 判断是否有修改信息
    var changUserInfoBlock : changeUserInfo?   // 修改用户信息的回调(回到个人中心刷新数据)
    
    var changeRootControToLogin : changeRootViewControllerToLogin?
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
        navigationItem.title = "设置"
        tableView.tableFooterView = UIView()
        prepare()
    }
    
    override func viewWillDisappear(animated: Bool) {
        if isChanged == true{
            if let user = self.user {
                changUserInfoBlock?(user)       // 如果有修改则刷新个人中心的数据
            }
        }
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
        if let address = user?.address {
            addressLab.text = address
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
//    MARK: -- 退出登陆
    private func loginOutHandler(avc:UIAlertAction) -> Void {
          HeartUser.logOut()
          NSNotificationCenter.defaultCenter().postNotificationName(HBRootViewControllerSwitchNotification, object: false)
    }
//   MARK: --  tableViewDelegate
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        prepare()
        return 0
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {                 // 名字
            let (showView, _) = self.loadNameWithPhoneView("NameWithPhoneSetView", textNumer: 10)
            showView.editTextField.text = user?.username
            showView.editTextField.resignFirstResponder()
            showView.changeHandler = {(objStr) -> Void in
                self.user?.username = objStr
            }
        }else if indexPath.row == 1 {           // 电话
            let (showView, _) = self.loadNameWithPhoneView("NameWithPhoneSetView", textNumer: 11)
            showView.editTextField.text = user?.mobilePhoneNumber
            showView.changeHandler = {(objStr) -> Void in
                self.user?.mobilePhoneNumber = objStr
            }
        }else if indexPath.row == 10 {          // 个人介绍
            let (showView, _) = self.loadNameWithPhoneView("PersonalitySetView", textNumer: 0)
            (showView as? PersonalitySetView)?.editTextView.text = user?.personality
            showView.changeHandler = {(objStr) -> Void in
                self.user?.personality = objStr
            }
        }else {
            let (showView, _) = self.loadNameWithPhoneView("MoreAttributeSetView", textNumer: 0)
           (showView as? MoreAttributeSetView)?.soureCome = indexPath.row
            switch indexPath.row {
            case 2 :
                showView.changeHandler = {(objStr) -> Void in
                    self.user?.sex = objStr
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
                    self.user?.address = objStr
                }
            case 8:
                showView.changeHandler = {(objStr) -> Void in
                    self.user?.house = objStr
                }
            case 9:
                showView.changeHandler = {(objStr) -> Void in
                    self.user?.car = objStr
                }
            default:
               break
            }
        }
    }
    private func loadNameWithPhoneView(classString: String, textNumer: Int) -> (view: NameWithPhoneSetView, modal: PathDynamicModal) {
        let showView = Tools.instantiateFromNib(classString, widthPercen: 0.65, hieghtPercen: 0.5) as! NameWithPhoneSetView
        showView.textNumber = textNumer;
        let window = UIApplication.sharedApplication().delegate?.window!
        let modal = PathDynamicModal.show(modalView: showView, inView: window!)
        
        showView.changeSaveActionHandler = {() -> Void in
            modal.closeWithLeansRight()
            self.user?.saveInBackgroundWithBlock({ (success, e) -> Void in
                if success == true {
                    self.tableView.reloadData()
                    self.isChanged = true
                }else {
                    SVProgressHUD.showInfoWithStatus("编辑失败")
                }
            })
        }
        showView.closeHandler = {() -> Void in
            modal.closeWithLeansLeft()
            return
        }
        return (showView, modal)
    }
    override func scrollViewDidScroll(scrollView: UIScrollView) {
    }
}

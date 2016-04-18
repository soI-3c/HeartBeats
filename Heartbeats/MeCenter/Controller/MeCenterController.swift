//
//  MeCenterController.swift
//  Heartbeats
//
//  Created by iOS-3C on 15/11/15.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit
import AVOSCloud


let meCenterCellID = "meCenterCellID"

class MeCenterController: UITableViewController, MeCenterHeadViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//    MARK: -- 数据懒加载初始化
    var user: HeartUser?{
        didSet {
            self.headView.user = user
            self.personaView.persionalityLabel.text = user?.personality
            NetworkTools.loadDynamicsByUser(user!) { (result, error) -> () in              //    MARK : - 加载动态数据
                if error == nil {
                    self.dynamics = result as? [Dynamic]
                    return
                }
                Tools.showSVPMessage("加载失败#")
            }
        }
    }
    private lazy var headView : MeCenterHeadView = MeCenterHeadView()
    private lazy var isUserHeadImg: Bool = true                     //   判断是否是头像
    
    private lazy var personaView: PersonalitySectionView = {
        let view = Tools.instantiateFromNib("PersonalitySectionView", widthPercen: 0, hieghtPercen: 0) as! PersonalitySectionView
        return view
    }()
    var dynamics: [Dynamic]? {
        didSet {
            tableView.reloadData()
        }
    }
    //    MARK: --  初始化操作
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "MeCenterCell", bundle: nil), forCellReuseIdentifier: meCenterCellID)
        if user == nil {            // 默认是当前用户, 如果不传user过来
            user = HeartUser.currentUser()
        }
        setupUI()
    }
    
    private func setupUI() {
        headView.delegate = self
        headView.bounds = CGRectMake(0, 0, 0, tableView.frame.height * 0.8)
        tableView.tableHeaderView = headView
        
        navigationController?.navigationBar.hidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        navigationController?.navigationBar.translucent = true
    }
    
//    MARK: - MeCenterHeadViewDelegate 
//    换头像
    func chageUserHeaderImg(meCenterHeadView : MeCenterHeadView) {
        if user != HeartUser.currentUser() {                            // 若不是当前用户则不能修改
            return
        }
        isUserHeadImg = true
        selectIcon()
    }
    func chageUserBackImg(meCenterHeadView: MeCenterHeadView) {
        if user != HeartUser.currentUser() {
            return
        }
        isUserHeadImg = false
        selectIcon()
    }
    
//    MARK: --- tableViewDelegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1{
            return 0
        }
        return dynamics?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(meCenterCellID, forIndexPath: indexPath) as? MeCenterCell
        cell?.dynamic = dynamics?[indexPath.row]
        return cell!
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        if section == 0 {
            return self.personaView
        }
        if section == 1 {
            let view = Tools.instantiateFromNib("ShopSettingView", widthPercen: 0, hieghtPercen: 0) as! ShopSettingView
                view.shopActionHandler = {()-> Void in
            }
            view.settingActionHandler = {[weak self]()-> Void in
              let settingController =   UIStoryboard(name: "SettingController", bundle: nil).instantiateInitialViewController() as? SettingController
                settingController!.currUser = self!.user
                settingController?.changUserInfoBlock = {[weak self] (user) -> Void in
                    self?.headView.user = user
                }
                self!.navigationController?.pushViewController(settingController!, animated: true)
            }
            return view
        }
        return nil
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let showDynamicPControl = NSBundle.mainBundle().loadNibNamed("ShowDynamicPhotoController", owner: nil, options: nil).first as? ShowDynamicPhotoController
        showDynamicPControl?.selectDynamicIndex = indexPath.row
        showDynamicPControl?.dynamics = dynamics
        presentViewController(showDynamicPControl!, animated: true, completion: nil)
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 44
        }
        // 根据个人介绍的文字长度, 动态计算section的高度
        let textSize =  personaView.persionalityLabel.text?.sizeWithAttributes([NSFontAttributeName: personaView.persionalityLabel.font])
        return textSize?.height <= 0 ? 0 : textSize!.height + 8
    }
    
// MARK: --- 更换头像一系列方法
    func selectIcon(){
        let userIconAlert = UIAlertController(title: "请选择操作", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let chooseFromPhotoAlbum = UIAlertAction(title: "从相册选择", style: UIAlertActionStyle.Default, handler: funcChooseFromPhotoAlbum)
        userIconAlert.addAction(chooseFromPhotoAlbum)
        
        let chooseFromCamera = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default,handler:funcChooseFromCamera)
        userIconAlert.addAction(chooseFromCamera)
    
        let canelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel,handler: nil)
        userIconAlert.addAction(canelAction)
        self.presentViewController(userIconAlert, animated: true, completion: nil)
    }
    
    //从相册选择照片
    func funcChooseFromPhotoAlbum(avc:UIAlertAction) -> Void{
        let imagePicker = UIImagePickerController()
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            return;
        }
        //设置代理
        imagePicker.delegate = self
        //允许编辑
        imagePicker.allowsEditing = true
        //设置图片源
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        //模态弹出IamgePickerView
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    //拍摄照片
    func funcChooseFromCamera(avc:UIAlertAction) -> Void{
        let imagePicker = UIImagePickerController()
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            return;
        }
        //设置代理
        imagePicker.delegate = self
        //允许编辑
        imagePicker.allowsEditing=true
        //设置图片源
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        
        //模态弹出IamgePickerView
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
   @objc func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //UIImagePicker回调方法
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
////        获取照片的原图
//        let image = (info as NSDictionary).objectForKey(UIImagePickerControllerOriginalImage)
//        获得编辑后的图片
        let image = (info as NSDictionary).objectForKey(UIImagePickerControllerEditedImage)
        print(image?.size)
        print(UIImagePNGRepresentation(image! as! UIImage)!.length)
        
        dispatch_async(dispatch_get_global_queue(0, 0)) { () -> Void in     //异步子线程去储存图片
            if self.isUserHeadImg == true {
                self.changeAndSaveImg(image as! UIImage, iconImageFileName: HBUserIconImage)
            }else {
                self.changeAndSaveImg(image as! UIImage, iconImageFileName: HBUserBackIconImage)
            }
        }
         picker.dismissViewControllerAnimated(true, completion: nil)
     }
    
    func changeAndSaveImg(image: UIImage, iconImageFileName: String) {
        dispatch_sync(dispatch_get_main_queue()) { () -> Void in            // 回至主线程刷新UI
            self.isUserHeadImg == true ?
                self.headView.userHeadImgView.setBackgroundImage(image, forState: .Normal) : self.headView.userBackImg.setBackgroundImage(image, forState: .Normal)
        }
        //保存图片至沙盒
        self.saveImage(image, imageName: iconImageFileName)
    }
    
    //MARK: - 保存图片到服务器
    func saveImage(currentImage: UIImage,imageName: String){
        var imageData = NSData()
        imageData = UIImageJPEGRepresentation(currentImage, 0.5)!
        // 获取沙盒目录
        let fullPath = ((NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents") as NSString).stringByAppendingPathComponent(imageName)
        // 将图片写入文件
        imageData.writeToFile(fullPath, atomically: false)
        
        //将服务器之前的图片删除
        let fileQuery = HBAVFile.query()
        fileQuery.whereKey("name", equalTo: imageName)
        let files = try? fileQuery.findFiles()
        if files?.count > 0 {
            for file in files! {
                   let f = file as? HBAVFile
                    f?.deleteInBackground()
            }
        }
        //      保存到服务器
        let imgData = UIImagePNGRepresentation(currentImage)
        let imgFile = HBAVFile(name: imageName, data: imgData)
        user!.setObject(imgFile, forKey: imageName)
        user!.saveInBackgroundWithBlock { (success, error) -> Void in
            if success == true {
                Tools.showSVPMessage("设置成功")
                return
            }else {
                Tools.showSVPMessage("设置失败#")
                return
            }
        }
    }
    
}

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
    private lazy var user: HeartUser? = {
        let user = HeartUser.currentUser()
        return user
    }()
    private lazy var headView : MeCenterHeadView = MeCenterHeadView()
    
    private lazy var isUserHeadImg: Bool = true
    
    private var personalitySectionViewHeight: CGFloat = 44 {
        didSet {
             tableView.reloadData()
        }
    }
    private lazy var personaView: PersonalitySectionView = {
        let view = Tools.instantiateFromNib("PersonalitySectionView", widthPercen: 0, hieghtPercen: 0) as! PersonalitySectionView
        view.linesActionHandler = {(lines) -> Void in
            self.personalitySectionViewHeight = 18 * (lines + 2)
        }
        return view
    }()
    
//    MARK:--    初始化操作
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "MeCenterCell", bundle: nil), forCellReuseIdentifier: "meCenterCellID")
        setupUI()
    }
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = true
        headView.user = user
        personaView.personality = user?.personality
    }
    override func viewWillLayoutSubviews() {
    }
    private func setupUI() {
        headView.delegate = self
        headView.bounds = CGRectMake(0, 0, 0, tableView.frame.height * 0.8)
        tableView.tableHeaderView = headView
    }
    
//    MARK: - MeCenterHeadViewDelegate 
//    换头像
    func chageUserHeaderImg(meCenterHeadView : MeCenterHeadView) {
        isUserHeadImg = true
        selectIcon()
    }
    func chageUserBackImg(meCenterHeadView: MeCenterHeadView) {
        isUserHeadImg = false
        selectIcon()
    }
    
//    MARK: --- tableViewDelegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(meCenterCellID, forIndexPath: indexPath) as? MeCenterCell
        
        return cell!
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        if section == 0 {
            return self.personaView
        }
        if section == 1 {
            let view = Tools.instantiateFromNib("ShopSettingView", widthPercen: 0, hieghtPercen: 0) as! ShopSettingView
            view.shopActionHandler = {()-> Void in
                print("shopActionHandler")
            }
            view.settingActionHandler = {[weak self]()-> Void in
                  let settingController =   UIStoryboard(name: "SettingController", bundle: nil).instantiateInitialViewController() as? SettingController
                    settingController!.currUser = self!.user
                    self!.navigationController?.pushViewController(settingController!, animated: true)
            }
            return view
        }
        return nil
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 104
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return personalitySectionViewHeight
        }
        return 44
    }
    
// MARK: --- 更换头像一系列方法
   private func selectIcon(){
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
    private func funcChooseFromPhotoAlbum(avc:UIAlertAction) -> Void{
        let imagePicker = UIImagePickerController()
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
    private func funcChooseFromCamera(avc:UIAlertAction) -> Void{
        let imagePicker = UIImagePickerController()
        //设置代理
        imagePicker.delegate = self
        //允许编辑
        imagePicker.allowsEditing=true
        //设置图片源
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        //模态弹出IamgePickerView
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
   @objc  func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //UIImagePicker回调方法
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //获取照片的原图
        //let image = (info as NSDictionary).objectForKey(UIImagePickerControllerOriginalImage)
        //获得编辑后的图片
        let image = (info as NSDictionary).objectForKey(UIImagePickerControllerEditedImage)
        if isUserHeadImg == true {
            changeAndSaveImg(image as! UIImage, iconImageFileName: iconImageString)
        }else {
            changeAndSaveImg(image as! UIImage, iconImageFileName: backIconImageString)
        }
         picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func changeAndSaveImg(image: UIImage, iconImageFileName: String) {
        //保存图片至沙盒
        self.saveImage(image, imageName: iconImageFileName)
        let fullPath = ((NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents") as NSString).stringByAppendingPathComponent(iconImageFileName)
        //存储后拿出更新头像
        let savedImage = UIImage(contentsOfFile: fullPath)
        isUserHeadImg == true ?
            self.headView.userHeadImgView.setImage(savedImage, forState: UIControlState.Normal) : self.headView.userBackImg.setImage(savedImage, forState: UIControlState.Normal)
    }
    
    //MARK: - 保存图片至沙盒与服务器
    func saveImage(currentImage:UIImage,imageName:String){
        var imageData = NSData()
        imageData = UIImageJPEGRepresentation(currentImage, 0.5)!
        // 获取沙盒目录
        let fullPath = ((NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents") as NSString).stringByAppendingPathComponent(imageName)
        // 将图片写入文件
        imageData.writeToFile(fullPath, atomically: false)
        
//      保存到服务器
        let imgData = UIImagePNGRepresentation(currentImage)
        let imgFile = AVFile(name: imageName, data: imgData)
        user!.setObject(imgFile, forKey: imageName)
        user!.saveInBackgroundWithBlock { (success, error) -> Void in
            if success == true {
                print("头像(背景头像)上传服务器成功~")
                return
            }else {
               print("头像(背景头像)上传服务器失败~")
                return
            }
        }
    }
  }

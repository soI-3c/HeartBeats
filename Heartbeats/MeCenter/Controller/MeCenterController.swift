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
let scrWHSize = UIScreen.mainScreen().bounds.size;
class MeCenterController: UITableViewController, MeCenterHeadViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//    MARK: -- 数据懒加载初始化
    var user: HeartUser?{
        didSet {
            self.headView.user = user
            navigationItem.title = user?.username
//            self.personaView.persionalityLabel.text = user?.personality
            NetworkTools.loadDynamicsByUser(user!) { (result, error) -> () in              //    MARK : - 加载动态数据
                if error == nil {
                    self.dynamics = result as? [Dynamic]
                    return
                }
                Tools.showSVPMessage("加载失败#")
            }
        }
    }
    var dynamics: [Dynamic]? {
        didSet {
            userDynamicFootVuew.dynamics = dynamics
        }
    }
    private lazy var headView : MeCenterHeadView = MeCenterHeadView()
    private let userDynamicFootVuew = UserDynamicCollectionV(frame: CGRectMake(0, 0, 0, 400), collectionViewLayout: UserDynamicCollectionLayout())                //   动态展示
    private lazy var isUserHeadImg: Bool = true                             //   判断是否是头像
    
    //    MARK: --  初始化操作
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = false
        tableView.estimatedRowHeight = 88
         tableView.rowHeight = UITableViewAutomaticDimension
        let spaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        spaceItem.width = -15                                       // 为了自定返回按钮时, 往右偏移的问题
        let leftBtn = UIBarButtonItem(image: UIImage(named: "defBack")!.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: "setting")
        self.navigationItem.rightBarButtonItems = [spaceItem, leftBtn]
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: meCenterCellID)
        
        if user == nil {            // 默认是当前用户, 如果不传user过来
            user = HeartUser.currentUser()
        }
        setupUI()
    }
    private func setupUI() {
        headView.delegate = self
        headView.bounds = CGRectMake(0, 0, 0, tableView.frame.width)
        tableView.tableHeaderView = headView
        tableView.tableFooterView = userDynamicFootVuew
    }
    func setting() {
        let settingController = UIStoryboard(name: "SettingController", bundle: nil).instantiateInitialViewController() as? SettingController
        settingController!.currUser = user
        settingController?.changUserInfoBlock = {[weak self] (user) -> Void in
            self?.headView.user = user
            self?.tableView.reloadData()
            self?.tableView.layoutIfNeeded()           // 位置改变了, 调用系统会帮我们调整
        }
        navigationController?.pushViewController(settingController!, animated: true)
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
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         let cell = UITableViewCell()
        cell.backgroundColor = UIColor.whiteColor()
         let lab = UILabel(title: "", fontSize: 15)
        lab.backgroundColor = UIColor.blackColor()
        lab.numberOfLines = 0
        lab.textColor = UIColor.whiteColor()
        
        // 行距
        let attributedString1 = NSMutableAttributedString(string: (user?.personality)!);
        let paragraphStyle1 = NSMutableParagraphStyle();
        paragraphStyle1.lineSpacing = 1
        attributedString1.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle1, range: NSMakeRange(0, (user?.personality!.characters.count)!))
        lab.attributedText = attributedString1;
        cell.contentView.addSubview(lab)
        lab.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(cell.contentView).offset(UIEdgeInsets(top: 2, left: 2, bottom: -2, right: -2))
        }
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
//       获取照片的原图
//        let image = (info as NSDictionary).objectForKey(UIImagePickerControllerOriginalImage)
//        获得编辑后的图片
        let image = (info as NSDictionary).objectForKey(UIImagePickerControllerEditedImage)
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
                f?.deleteInBackgroundWithBlock({ (b, error) -> Void in
                    if (error != nil) {
                    }
                })
            }
        }
        //      保存到服务器
        let imgData = UIImagePNGRepresentation(currentImage)
        let imgFile = HBAVFile(name: imageName, data: imgData)
        user!.setObject(imgFile, forKey: imageName)
        user!.saveInBackgroundWithBlock { (success, error) -> Void in
            if success == false {
                Tools.showSVPMessage("设置失败#")
                return
            }
        }
    }
    
}

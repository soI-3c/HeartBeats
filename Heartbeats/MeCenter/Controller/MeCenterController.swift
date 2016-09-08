//
//  MeCenterController.swift
//  Heartbeats
//
//  Created by iOS-3C on 15/11/15.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit
import AVOSCloud


let window = UIApplication.sharedApplication().delegate?.window!
let meCenterCellID = "meCenterCellID"
let scrWHSize = UIScreen.mainScreen().bounds.size;
class MeCenterController: UITableViewController, MeCenterHeadViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, HMImagePickerControllerDelegate {
//    MARK: -- 数据懒加载初始化
    var user: HeartUser?{
        didSet {
            self.headView.user = user
            if let backUrl = user?.backIconImage {
                backImageView.sd_setImageWithURL(NSURL(string: backUrl))
            }
            navigationItem.title = user?.username
            NetworkTools.loadDynamicsByUser(user!) { (result, error) -> () in              //    MARK : - 加载动态数据
                if error == nil {
                    self.dynamics = result as? [Dynamic]
                    return
                }
                Tools.showSVPMessage("加载失败#")
            }
        }
    }
    private var selectImagesAsset = [PHAsset]?()          // 相册选择的图片PHAsset(用于定位再次选择)
    private var selectImage = [UIImage]?()                // 相册选择的图片
    
    var dynamics: [Dynamic]? {                            // 个人动态
        didSet {
            tableView.reloadData()
        }
    }
    lazy var backImageView: UIImageView = {
        let backImageV = UIImageView()
        return backImageV
    }()
    
    private lazy var headView : MeCenterHeadView = MeCenterHeadView()
    private let photographAlbumView = UserDynamicCollectionV(frame: CGRectZero, collectionViewLayout: UserDynamicCollectionLayout())                                      //   个人相册
    private lazy var isUserHeadImg: Bool = true                             //   判断是否是头像
    
    //    MARK: --  初始化操作
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = false
        tableView.estimatedRowHeight = 88
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .None
        tableView.showsVerticalScrollIndicator = false
        // 右边按钮
        let spaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        spaceItem.width = -15                                       // 为了自定返回按钮时, 往右偏移的问题
        let leftBtn = UIBarButtonItem(image: UIImage(named: "defBack")!.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: "setting")
        navigationItem.rightBarButtonItems = [spaceItem, leftBtn]
    
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0)
        // 注册
        tableView.registerClass(MeCenterDynamicTabCell.self, forCellReuseIdentifier: meCenterCellID)
        if user == nil {            // 默认是当前用户, 如果不传user过来
            user = HeartUser.currentUser()
        }
        // 添加图片到相册
        photographAlbumView.addImagesBlock = {[weak self]() -> Void in
            self!.addImagesToPhotographAlbum()
        }
        // 浏览图片
        photographAlbumView.tapPhotograpAlbum = {[weak self](idx) -> Void in
            let browseImageControl = BrowseImageController(collectionViewLayout: UICollectionViewFlowLayout())
            browseImageControl.imageUrls = self!.user?.photographAlbum
            browseImageControl.selectIdx = idx
            browseImageControl.deleImageAction = {(idx, btn) -> Void in         // 删除
                self!.user?.photographAlbum?.removeAtIndex(idx)
                self?.user?.saveInBackground()
                AVUser.changeCurrentUser(self?.user, save: true)
                self!.tableView.reloadData()
            }
            self?.addChildViewController(browseImageControl)
            browseImageControl.didMoveToParentViewController(self)
            PathDynamicModal.show(modalView: browseImageControl.collectionView!, inView: window!)
        }
        setupUI()
    }
    private func setupUI() {
        headView.delegate = self
        headView.bounds = CGRectMake(0, 0, 0, tableView.frame.width)
        Tools.insertBlurView(backImageView, style: .Light)
        tableView.backgroundView = backImageView
        tableView.tableHeaderView = headView
        tableView.tableFooterView = UIView()
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
    private func deleDynamic(deleCell :MeCenterDynamicTabCell) {                       // 删除动态
        let index = tableView.indexPathForCell(deleCell)
        let dynamic = dynamics![index!.row - 2]
        dynamic.deleteInBackgroundWithBlock { (b, error) -> Void in
            if error == nil && b == true{
                self.dynamics?.removeAtIndex(index!.row - 2)
                self.tableView.reloadData()
                return
            }
            SVProgressHUD.showInfoWithStatus("删除失败.")
        }
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
    // 添加相片到相册
    func addImagesToPhotographAlbum() {
       let imagePickerControl = HMImagePickerController(selectedAssets: selectImagesAsset)
        imagePickerControl.pickerDelegate = self
        imagePickerControl.targetSize = CGSize(width: 300, height: 300)
        imagePickerControl.maxPickerCount = 6 - (user?.photographAlbum?.count)!
        presentViewController(imagePickerControl, animated: true, completion: nil)
    }
    
    ///  MARK: --- ImageDelegate
    /// @param picker         图像选择控制器
    /// @param images         用户选中图像数组
    /// @param selectedAssets 选中素材数组，方便重新定位图像
    func imagePickerController(picker: HMImagePickerController, didFinishSelectedImages images: [UIImage], selectedAssets: [PHAsset]?) {
        var i = 0
        SVProgressHUD.show()
        for img in images {
            let imgFile = AVFile(name: HBPhotographAlbum, data: UIImageJPEGRepresentation(img, 1.0))
            imgFile.saveInBackgroundWithBlock({ [weak self](b, error) in
                if error == nil {
                    self?.user?.photographAlbum?.append(imgFile.url);
                    i += 1
                    if i == images.count {
                        SVProgressHUD.dismiss()
                        self?.user?.saveInBackgroundWithBlock({ (b, e) in               // 修改用户信息
                            if e == nil {
                                self?.tableView.reloadData()
                                self?.dismissViewControllerAnimated(true, completion: nil)
                                return;
                            }
                            SVProgressHUD.showInfoWithStatus("修改失败.")
                        })
                    }
                }
            })
        }
    }
//    MARK: --- tableViewDelegate
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dynamics != nil ? (dynamics?.count)! + 2 : 1
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {                 // 个人简介
            let cell = UITableViewCell()
            cell.selectionStyle = .None
            cell.backgroundColor = UIColor.clearColor()
            let lab = UILabel(title: "", fontSize: 15)
            lab.numberOfLines = 0
            lab.textColor = UIColor.init(white: 1.0, alpha: 1.0)
            
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
        if indexPath.row == 1 {                     // 个人相册
            let cell = UITableViewCell()
            cell.selectionStyle = .None
            cell.backgroundColor = UIColor.clearColor()
            cell.contentView.addSubview(photographAlbumView)
            photographAlbumView.snp_makeConstraints { (make) in
                make.edges.equalTo(cell.contentView).offset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            }
            photographAlbumView.photographAlbum = user?.photographAlbum ?? [String]()
            return cell
        }
        // 动态展示
        let cell = tableView.dequeueReusableCellWithIdentifier(meCenterCellID, forIndexPath: indexPath) as! MeCenterDynamicTabCell
        cell.deleDynamicBlock = {[weak self](deleCell) -> Void in
           self?.deleDynamic(deleCell)
        }
        cell.dynamicImageUrl = dynamics![indexPath.item - 2].photos?.url
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 1 {
            let size = CGSize(width: MAXWHSzie.width / 3.0 - 4, height: MAXWHSzie.width / 3.0 - 4)
            if user?.photographAlbum?.count > 0{
                if user?.photographAlbum?.count <= 2 {
                    return size.height + 16
                }
                return size.height * 2 + 16
            }
            return size.height + 8;
        }
        if indexPath.row != 0 {
            return scrWHSize.width
        }
        return UITableViewAutomaticDimension
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
        var oldUrl : String!
        oldUrl =  imageName == HBUserIncome ? user?.iconImage : user?.backIconImage             // 记录以前的url
        var imageData = NSData()
        imageData = UIImageJPEGRepresentation(currentImage, 0.5)!
        // 获取沙盒目录
        let fullPath = ((NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents") as NSString).stringByAppendingPathComponent(imageName)
        // 将图片写入文件
        imageData.writeToFile(fullPath, atomically: false)
        //      保存到服务器
        let imgData = UIImagePNGRepresentation(currentImage)
        let imgFile = AVFile(name: imageName, data: imgData)
        imgFile.saveInBackgroundWithBlock { (b, error) -> Void in
            if b == true {
                self.user?.setValue(imgFile.url, forKey: imageName)
                self.user?.save()
                NetworkTools.deleFileByUrl(oldUrl, finishedCallBack: { (result, error) in           // 删除以前的文件
                })
            }
        }
    }
}

//
//  DefaultPublicDynamicController.swift
//  Heartbeats
//
//  Created by liaosenshi on 16/1/13.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

// MARK: -- 发表动态 -  选择图片
class DefaultPublicDynamicController: UIViewController {
    
//   MARK: -- override
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpNav()
    }
    deinit {
        print("DefaultPublicDynamicController")
    }
    
//   MARK: --  private func
    func setUpUI() {
        addChildViewController(imgGridViewController)
        view.addSubview(imgGridViewController.view)
        view.addSubview(popView)
        imgGridViewController.view.frame = view.bounds
        navigationController?.navigationBar.addSubview(navBtn)
        
        navBtn.snp_makeConstraints { (make) -> Void in
            make.center.equalTo((navigationController?.navigationBar)!)
            make.width.equalTo(200)
            make.height.equalTo(35)
        }
        popView.frame = CGRectMake(0, -view.frame.height , screenMaimWidth, view.frame.height)
    }
    func setUpNav() {
        let spaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        spaceItem.width = -10                                       // 为了自定返回按钮时, 往右偏移的问题
        let leftBtn = UIBarButtonItem(image: UIImage(named: "cancel")!.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: "doBack")
        navigationItem.leftBarButtonItems = [spaceItem, leftBtn]
    }
    func doBack() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func showPhotoLibList(sender : UIButton) {
        sender.selected = !sender.selected
        UIView.animateWithDuration(0.35) { () -> Void in
            sender.imageView?.transform = CGAffineTransformRotate((sender.imageView?.transform)!,CGFloat(M_PI))
        };
        let y = sender.selected ? 0 : -self.view.frame.height
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            self.popView.frame = CGRectMake(0, y , screenMaimWidth, self.view.frame.height)
        })
    }
    
//    MARK: --- setter / getter 
    lazy var imgGridViewController: SCImageGridViewController = {        // 选择图片后跳到截取页面
        let imgGridViewControl = SCImageGridViewController()
        imgGridViewControl.selectImageAction = {[weak self](img) -> Void in
            self!.dynamicCutOffImgController.img = img
            self!.navigationController?.pushViewController(self!.dynamicCutOffImgController, animated: true)
        }
        return imgGridViewControl
    }()
    
   var dynamicCutOffImgController = DynamicCutOffImgController()        // 截取图片控制器
    
   lazy var navBtn: UIButton = {                                        // 相册显示名字
        let btn = UIButton(type: .Custom)
        btn.setTitle("相机胶卷", forState: .Normal)
        btn.setImage(UIImage(named: "upDown"), forState: .Normal)
        btn.addTarget(self, action: "showPhotoLibList:", forControlEvents: .TouchUpInside)
        return btn
    }()
    
    lazy var popView: SystemPhotoLibListView = {                        // 相册选择器
        let popView = SystemPhotoLibListView()
        popView.selectPhotoGroup = {(assets, groupPhotoName) -> Void in
            self.imgGridViewController.assets = assets
            self.navBtn.setTitle(groupPhotoName, forState: .Normal)
            self.showPhotoLibList(self.navBtn)                          // 主动调用btn的事件方法
        }
        return popView
    }()
}








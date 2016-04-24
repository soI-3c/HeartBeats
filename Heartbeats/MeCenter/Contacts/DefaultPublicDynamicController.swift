//
//  DefaultPublicDynamicController.swift
//  Heartbeats
//
//  Created by liaosenshi on 16/1/13.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit
// MARK: -- 发表动态
class DefaultPublicDynamicController: UIViewController {

//   MARK: -- override
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpNav()
    }
    
//   MARK: --  private func
    func setUpUI() {
        addChildViewController(imgGridViewController)
        view.addSubview(imgGridViewController.view)
        imgGridViewController.view.frame = view.bounds
        navigationController?.navigationBar.addSubview(navBtn)
    }
    func setUpNav() {
        let leftBtn = UIBarButtonItem(image: UIImage(named: "closeIcon")!.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: "doBack")
        navigationItem.leftBarButtonItems = [leftBtn]
    }
    
    func doBack() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
//    MARK: --- setter / getter 
    let imgGridViewController = SCImageGridViewController()
 
    let navBtn: UIButton = {            //
        let btn = UIButton(type: .Custom)
        btn.setTitle("相机胶卷", forState: .Normal)
        btn.setImage(UIImage(named: "closeIcon"), forState: UIControlState.Normal)
        btn.frame = CGRectMake(0, 0, 135, 35)
        return btn
    }()
}








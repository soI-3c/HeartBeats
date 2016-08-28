//
//  MainNavigationController.swift
//  HeartDance
//
//  Created by iOS-3C on 15/10/18.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController, UINavigationControllerDelegate,UIGestureRecognizerDelegate{
//    MARK:- 初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        interactivePopGestureRecognizer?.enabled = true
        interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(childViewControllers.count == 1) {
            return false
        }
        return true
    }
    
//    在第一次使用本类时会调用, 只会调用 一次
//    设置统一的界面效果
    internal override class func initialize() {
        let bar =  UINavigationBar.appearance()
        bar.barStyle = UIBarStyle.BlackOpaque
//        设置字体着色
        bar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        bar.translucent = false;
        
//        设置按钮着色
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Normal)
    }
    /**
        跳转控制器都会跳用本方法, 自定义返回按钮
    */
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if viewControllers.count >= 1 {
          let spaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
          spaceItem.width = -15                                       // 为了自定返回按钮时, 往右偏移的问题
          let leftBtn = UIBarButtonItem(image: UIImage(named: "defBack")!.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: "doBack")
            viewController.navigationItem.leftBarButtonItems = [spaceItem, leftBtn]
            MainTabar.currentMainTabar().hidden = true                          // 隐藏自定义的tabbar
        }
        if viewController .isKindOfClass(MeCenterController.self) {
            viewController.automaticallyAdjustsScrollViewInsets = false     // 让内容从状态顶部开始显示
        }
        super.pushViewController(viewController, animated: true)
    }
    
    override func popViewControllerAnimated(animated: Bool) -> UIViewController? {
       return super.popViewControllerAnimated(true)
    }
    
//    MARK : -- delegate
    // UINavigationControllerDelegate
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
//        只有当真正要显示是否是根据控制器时,才决定是否要显示tabbar, 只要不是根据控制器都隐藏tabbar
//        MainTabar.currentMainTabar().hidden = viewControllers.count > 1 ? true : false
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        //        只有当真正要显示是否是根据控制器时,才决定是否要显示tabbar, 只要不是根据控制器都隐藏tabbar
        MainTabar.currentMainTabar().hidden = viewControllers.count > 1 ? true : false
    }
    func doBack() {
        popViewControllerAnimated(true)
    }
    
}

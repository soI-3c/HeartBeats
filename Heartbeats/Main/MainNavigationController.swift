//
//  MainNavigationController.swift
//  HeartDance
//
//  Created by iOS-3C on 15/10/18.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController, UIGestureRecognizerDelegate{
//    MARK:- 初始化
    override func viewDidLoad() {
        super.viewDidLoad()
    let target =  interactivePopGestureRecognizer?.delegate
    let pan = UIPanGestureRecognizer(target: target, action: "handleNavigationTransition:")
        pan.delegate = self;
        view .addGestureRecognizer(pan)
        interactivePopGestureRecognizer?.enabled = false
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
        UIBarButtonItem .appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Normal)
    }
    
    func handleNavigationTransition( sender: UIGestureRecognizer){
          navigationController?.popViewControllerAnimated(true)
    }
    
    /**
        跳转控制器都会跳用本方法
    */
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Navigation

//     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

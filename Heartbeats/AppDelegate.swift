//
//  AppDelegate.swift
//  Heartbeats
//
//  Created by iOS-3C on 15/11/14.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit
import AVOSCloud


typealias changeRootViewControllerToMain = () -> Void
typealias changeRootViewControllerToLogin = () -> Void

/// 在类的外面写的常量或者变量就是全局能够访问的
/// 视图控制器切换通知字符串
let HBRootViewControllerSwitchNotification = "HBRootViewControllerSwitchNotification"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var changeRootControllerToMainBlock: changeRootViewControllerToMain?
    var changeRootControllToLogin: changeRootViewControllerToLogin?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds);
       window?.backgroundColor = UIColor.whiteColor()
        HeartUser.registerSubclass()
        Dynamic.registerSubclass()
        AVOSCloud.setApplicationId("MfQgIdk0MNsmNiKUh7tix2ph", clientKey: "QMviVrHgrzIBEvOrjqxOAYzK")
        
        // 注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "switchRootViewController:", name: HBRootViewControllerSwitchNotification, object: nil)
        setupAppearance()
        window?.rootViewController = defaultRootControll()
        window?.makeKeyAndVisible();
    //        集合短信SDK
        return true
    }
//   MARK: - 默认控制器
    private func defaultRootControll()-> UIViewController {
        if HeartUser.currentUser() != nil {
            return MainTabBarController()
        }
        return loadLoginRegisterControl()
    }
    
    @objc func switchRootViewController(n: NSNotification) {
        let isTrue = n.object as! Bool
       window?.rootViewController = isTrue ? MainTabBarController() : loadLoginRegisterControl()
    }
    
    private func loadLoginRegisterControl() -> UIViewController {
        let loginRegisterControllerSB =  UIStoryboard(name: "LoginRegisterMainViewController", bundle: nil)
        return loginRegisterControllerSB.instantiateInitialViewController() as! LoginRegisterMainViewController
    }
    
    /// 设置外观
    private func setupAppearance() {
        // 一经设置，全局有效，应该尽早设置
        UITabBar.appearance().tintColor = UIColor.clearColor()
        UITabBar.appearance().alpha = 0.015
        SVProgressHUD.setBackgroundColor(UIColor.blackColor())
        SVProgressHUD.setForegroundColor(UIColor.whiteColor())
    }
    
    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

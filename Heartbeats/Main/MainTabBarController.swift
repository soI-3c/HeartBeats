//
//  MainTabBarController.swift
//  HeartDance
//
//  Created by iOS-3C on 15/10/18.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

   lazy var mainTabarView : MainTabar = {
       let mainTabarView =  MainTabar.currentMainTabar()
        mainTabarView.selectControllerIndex = {(result) -> () in
            if result == 2 {
                  let viewController = DefaultPublicDynamicController()
                  self.presentViewController(MainNavigationController(rootViewController: viewController), animated: true, completion: nil)
                return
            }
            self.selectedIndex = result
        }
        return mainTabarView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTabarView.frame = tabBar.frame
        tabBar.removeFromSuperview()
        self.view .addSubview(mainTabarView);
        addChildViewControllers();
    }
    private func addChildViewControllers() {
        addChildViewController(HomeController(), title: "Heartbeats", imageName: "")
        addChildViewController(DynamicTableViewController(), title: "Dynamic", imageName: "")
        // 添加了一个空白的控制器
        addChildViewController(UIViewController())
        addChildViewController(ContactsCollectionViewController(), title: "Contacts", imageName: "")
        addChildViewController(MeCenterController(), title: "Me", imageName: "")
    }
    
    private func addChildViewController(vc: UIViewController, title: String, imageName: String) {
        vc.navigationItem.title = title;
        let navC = MainNavigationController(rootViewController: vc)
        addChildViewController(navC)
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

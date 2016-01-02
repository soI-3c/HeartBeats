//
//  MainTabBarController.swift
//  HeartDance
//
//  Created by iOS-3C on 15/10/18.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewControllers();
    }
    private func addChildViewControllers() {
        self.addChildViewController(DynamicController(), title: "Heartbeats", imageName: "")
        self.addChildViewController(ContactsCollectionViewController(), title: "ContactsCollectionViewController", imageName: "")
        self.addChildViewController(MeCenterController(), title: "Me", imageName: "")
    }
    
    private func addChildViewController(vc: UIViewController, title: String, imageName: String) {
        vc.title = title;
        tabBar.tintColor = UIColor.blackColor()
        let navC = MainNavigationController(rootViewController: vc)
        vc.tabBarItem.image = UIImage(named: imageName)
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

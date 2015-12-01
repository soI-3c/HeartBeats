//
//  MeCenterController.swift
//  Heartbeats
//
//  Created by iOS-3C on 15/11/15.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit

class MeCenterController: UIViewController {
    
//    MARK : - 懒加载控件
      private  lazy var meCenterTableView: UITableView = {
            let tableView = UITableView()
            return tableView
        }()
    
      private lazy var headView : MeCenterHeadView = MeCenterHeadView()
    
//      初始化操作
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
//    MARK; - 设置UI
    private func setupUI() {
        view.addSubview(headView)
        view.addSubview(meCenterTableView)
        self.navigationController?.navigationBarHidden = true
        headView.translatesAutoresizingMaskIntoConstraints = false
        meCenterTableView.translatesAutoresizingMaskIntoConstraints = false
        
        headView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(view).offset(CGSize(width: 0, height: -(view.frame.width * 0.6)))
        }
        meCenterTableView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(view)
            make.top.equalTo(headView.snp_bottom).offset(1)
        }
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

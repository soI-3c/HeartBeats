//
//  MeCenterController.swift
//  Heartbeats
//
//  Created by iOS-3C on 15/11/15.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit

class MeCenterController: UIViewController {

    @IBOutlet var headView: MeCenterHeadView!
    @IBOutlet weak var userHeadView: UIButton!

      private  lazy var meCenterTableView: UITableView = {
        let tableView = UITableView()
        return tableView
        }()
//      初始化操作
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        self.loadHeadView()
        self.setupUI()
    }
    private func loadHeadView() -> MeCenterHeadView {
        let headViews = NSBundle.mainBundle().loadNibNamed("MeCenterHeadView", owner: nil, options: nil)
            return headViews.first as! MeCenterHeadView
    }
//   MARK:  -- 设置UI
    private func setupUI() {
        headView = loadHeadView()
        view.addSubview(headView)
        view.addSubview(meCenterTableView)
        self.navigationController?.navigationBarHidden = true
        headView.translatesAutoresizingMaskIntoConstraints = false
        meCenterTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[headView]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["headView": headView]))
         view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[headView(==300)]-0-[tableView]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["headView": headView, "tableView": meCenterTableView]))
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

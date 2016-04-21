//
//  DefaultPublicDynamicController.swift
//  Heartbeats
//
//  Created by liaosenshi on 16/1/13.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

class DefaultPublicDynamicController: UIViewController {

    var photoDynamicBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.blackColor()
        btn.layer.cornerRadius = 60 / 2
        btn.layer.masksToBounds = true
        return btn
    }()
    var textDynamicBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius =  60 / 2
        btn.layer.masksToBounds = true
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
    }
    
    func setupUI() {
        view.addSubview(photoDynamicBtn)
        photoDynamicBtn.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(view.snp_top)
            make.centerX.equalTo(view)
            make.width.height.equalTo(60)
        }
    }
    func updateUI() {
        UIView.animateWithDuration(0.52, delay: 0, usingSpringWithDamping: 6, initialSpringVelocity: 6, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.photoDynamicBtn.snp_updateConstraints(closure: { (make) -> Void in
                    make.center.equalTo(self.view)
                })
            }) { (_) -> Void in
                
        }
    }
}









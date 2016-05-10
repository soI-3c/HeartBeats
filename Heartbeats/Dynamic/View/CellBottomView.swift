//
//  CellBottomView.swift
//  Heartbeats
//
//  Created by iOS-3C on 16/4/20.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

class CellBottomView: UIView {
//    MARK: -- private
    class func loadNibSelf() -> CellBottomView {
        return UINib(nibName: "CellBottomView", bundle: nil).instantiateWithOwner(nil, options: nil).first as! CellBottomView
    }
    
//    MARK:-- setter/ getter
    var dynamic: Dynamic? {
        didSet {
            praiseNumberLab.text = "\(dynamic?.praises?.count ?? 0)"
        }
    }
    @IBAction func praiseAction(sender: UIButton) {
       NSNotificationCenter.defaultCenter().postNotificationName("touchPraiseEven", object: nil, userInfo: ["dynamic" : dynamic!, "Cell": self.superview!.superview!])
    }
    
    @IBOutlet weak var praiseBtn: UIButton!
    @IBOutlet weak var discussNumberLab: UILabel!
    @IBOutlet weak var praiseNumberLab: UILabel!
}

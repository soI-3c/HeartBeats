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
            
        }
    }
    @IBOutlet weak var discussNumberLab: UILabel!
    @IBOutlet weak var praiseNumberLab: UILabel!
}

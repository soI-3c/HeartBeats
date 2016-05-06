//
//  CellTopView.swift
//  Heartbeats
//
//  Created by iOS-3C on 16/4/20.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

class CellTopView: UIView {
    
//    MARK:-- override
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        cornerRadius(userHeadView, radius: userHeadView.frame.width)
        cornerRadius(nowDoingBtn, radius: nowDoingBtn.frame.width)
    }
    
//    MARK: -- private
   class func loadNibSelf() -> CellTopView {
       return UINib(nibName: "CellTopView", bundle: nil).instantiateWithOwner(nil, options: nil).first as! CellTopView
    }
    func cornerRadius(sender : UIView, radius: CGFloat) {
        sender.layer.cornerRadius = radius / 2
        sender.layer.masksToBounds = true
        sender.layer.borderColor = UIColor.whiteColor().CGColor
        sender.layer.borderWidth = 1.5
    }
    
//    MARK: -- setter/ getter
    var dynamic: Dynamic? {
        didSet {
            if let dynamic = dynamic {
            userHeadView.setBackgroundImageWithURL(NSURL(string: (dynamic.user?.iconImage?.url)!), forState: UIControlState.Normal, placeholderImage: placeholderImage)
                usernameLabel.text = dynamic.user?.username
            }
        }
    }
    
    @IBOutlet weak var nowDoingBtn: UIButton!
    @IBOutlet weak var userHeadView: UIButton!
    
    @IBOutlet weak var usernameLabel: UILabel!
}

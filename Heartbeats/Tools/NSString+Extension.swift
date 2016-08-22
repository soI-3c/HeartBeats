//
//  HBString.swift
//  Heartbeats
//
//  Created by iOS-3C on 16/6/10.
//  Copyright © 2016年 heart. All rights reserved.
//


import UIKit

extension NSString {
    func stringSize() -> CGSize {
        return self.boundingRectWithSize(CGSize(width: 100, height: 999.0), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont()], context: nil).size
    }
}
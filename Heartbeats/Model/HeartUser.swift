//
//  HeartUser.swift
//  Heartbeats
//
//  Created by liaosenshi on 15/12/10.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit
import AVOSCloud

enum HeartBeatsSex: Int {
    case body
    case girl
};

class HeartUser: AVUser {
    
    @NSManaged var iconImage: AVFile?      // 用户头像
    @NSManaged var backIconImage: AVFile?  // 背景头像
    @NSManaged var personality: String?    // 个性签名
    @NSManaged var age: String?
    @NSManaged var sex: String?
    @NSManaged var academic: String?
    @NSManaged var height: String?
    @NSManaged var birthday: String
    @NSManaged var address: String?
    @NSManaged var income: String?
    @NSManaged var house: String?
    @NSManaged var car: String?
    
    override class func parseClassName() -> String? {
        return "_User"
    }
}

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
let HBUser = "user"
let HBUserDynamics = "dynamics"
let HBUserIconImage = "iconImage"
let HBUserBackIconImage = "backIconImage"
let HBUserPersonality = "personality"
let HBUserAge = "age"
let HBUserSex = "sex"
let HBUserHeight = "height"
let HBUserBirthday = "birthday"
let HBUserAddress = "address"
let HBUserIncome = "income"
let HBUserHouse = "house"
let HBUserCar = "car"
let HBPhotographAlbum = "photographAlbum"

class HeartUser: AVUser {
    @NSManaged var iconImage: String?      // 用户头像
    @NSManaged var backIconImage: String?  // 背景头像
    @NSManaged var personality: String?      // 个性签名
    @NSManaged var age: String?
    @NSManaged var sex: String?
    @NSManaged var academic: String?
    @NSManaged var height: String?
    @NSManaged var birthday: String
    @NSManaged var address: String?
    @NSManaged var income: String?
    @NSManaged var house: String?
    @NSManaged var car: String?
    @NSManaged var dynamics: [Dynamic]?
    @NSManaged var photographAlbum: [String]? // 个人相册
    override class func parseClassName() -> String? {
        return "_User"
    }
}

extension HeartUser {
}

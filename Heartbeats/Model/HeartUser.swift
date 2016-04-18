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

class HeartUser: AVUser {
    
    @NSManaged var iconImage: HBAVFile?      // 用户头像
    @NSManaged var backIconImage: HBAVFile?  // 背景头像
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
    @NSManaged var dynamics: [Dynamic]?
    override class func parseClassName() -> String? {
        return "_User"
    }
}

extension HeartUser {
//    MARK: --- 根据key 返回文件AVFile的 url
    func loadUserIconImageWithBackImage(user: HeartUser?, imageName: String?) -> String? {
        var url: String?
        let userQuery = HeartUser.query()
        userQuery.whereKey("objectId", equalTo: user?.objectId)
        userQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            print(objects)
            if objects != nil {
                if let user = objects.first as? HeartUser {
                    if imageName == HBUserIconImage {
                        url = user.iconImage?.url
                        print(url)
                    }
                    if imageName == HBUserBackIconImage {
                        url = user.backIconImage?.url
                        print(url)
                    }
                }
            }
        })
        return url
    }
}

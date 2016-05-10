//
//  DynamicPraise.swift
//  Heartbeats
//
//  Created by iOS-3C on 16/5/8.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

/*动态赞*/
class DynamicPraise: AVObject, AVSubclassing {
    @NSManaged var dynamicID: String!               //动态ID
    @NSManaged var userID: String!                  //  赞用户的ID
    @NSManaged var userHeadImg: HBAVFile?             //  赞用户名头像
    @NSManaged var userName: String!                 //  赞用户名
    
    init(dynamicID: String, userID: String, userHeadImg: HBAVFile?, userName: String){
        super.init()
        self.dynamicID = dynamicID
        self.userID = userID
        self.userName = userName
        self.userHeadImg = userHeadImg
    }
    override init() {
        super.init()
    }
    static func parseClassName() -> String? {
        return "DynamicPraise"
    }
}

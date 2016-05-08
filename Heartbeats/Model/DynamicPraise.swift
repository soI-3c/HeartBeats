//
//  DynamicPraise.swift
//  Heartbeats
//
//  Created by iOS-3C on 16/5/8.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit
/*动态赞*/
class DynamicPraise: AVObject {
    @NSManaged var dynamicID: String!               //动态ID
    @NSManaged var userID: String!                  //  赞用户的ID
    @NSManaged var userHeadImg: UIImage?             //  赞用户名头像
    @NSManaged var userName: String!                 //  赞用户名
    class func parseClassName() -> String? {
        return "DynamicPraise"
    }

}

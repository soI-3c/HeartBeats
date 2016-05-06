//
//  DynamicPraise.swift
//  Heartbeats
//
//  Created by liaosenshi on 16/5/6.
//  Copyright © 2016年 heart. All rights reserved.
//


/**动态点赞*/
class DynamicPraise: AVObject {
    var targetDynamic: String?              // 目标动态
    var usreName: String?                   // 点赞的用户名
    var userHeadImage: UIImage?             // 点赞的用户头像
    static func parseClassName() -> String? {
        return "DynamicPraise"
    }
}

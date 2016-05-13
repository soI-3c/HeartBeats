//
//  DynamicDiscuss.swift
//  Heartbeats
//
//  Created by liaosenshi on 16/5/11.
//  Copyright © 2016年 heart. All rights reserved.
//

/*评论*/
class DynamicComment: AVObject, AVSubclassing {
    @NSManaged var dynamicID: String!               //  动态ID
    @NSManaged var userID: String!                  //  评论用户的ID
    @NSManaged var userHeadImg: HBAVFile?           //  评论用户名头像
    @NSManaged var targetUserName: String?          //  评论目标的名字
    @NSManaged var userName: String!                //  评论用户名
    @NSManaged var commentContent: String!          //  评论内容
    
    init(dynamicID: String, userID: String, userHeadImg: HBAVFile?, userName: String, targetUserName: String? ,commentContent: String!){
        super.init()
        self.dynamicID = dynamicID
        self.userID = userID
        self.userName = userName
        self.targetUserName = targetUserName
        self.userHeadImg = userHeadImg
        self.commentContent = commentContent
    }
    override init() {
        super.init()
    }
    static func parseClassName() -> String? {
        return "DynamicComment"
    }
}

extension DynamicComment {
    
}

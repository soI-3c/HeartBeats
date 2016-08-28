//
//  NetworkTools.swift
//  Heartbeats
//
//  Created by liaosenshi on 16/1/4.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit
//MARK: --- 网络请求类
class NetworkTools: NSObject {
    // MARK: - 类型定义
    /// 网络回调类型别名
    typealias HBNetFinishedCallBack = (result: [AnyObject]?, error: NSError?)->()
    
//    MARK: -- 根据user返回user的动态
    class func loadDynamicsByUser(user: HeartUser, finishedCallBack: HBNetFinishedCallBack) {
        var dynamics = [Dynamic]()
        let dynamicQuery = Dynamic.query()
        dynamicQuery.whereKey(HBDynamicUser, equalTo: user)
        dynamicQuery.includeKey(HBDynamicUser)
        dynamicQuery.includeKey(HBDynamicPhotos)
        dynamicQuery.orderByDescending("createdAt")
        dynamicQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil {
                for dynamic in objects {
                    dynamics.append(dynamic as! Dynamic)
                }
                finishedCallBack(result:  dynamics, error: nil)
            }else {
                finishedCallBack(result: nil, error: error)
            }
        })
    }
//    MARK: -- 返回所有人动态数组
    class func loadDynamics(finishedCallBack: HBNetFinishedCallBack) {
        var dynamics = [Dynamic]()
        let dynamicQuery = Dynamic.query()
        dynamicQuery.includeKey(HBDynamicUser)
        dynamicQuery.includeKey(HBDynamicPhotos)
        dynamicQuery.includeKey(HBDynamicPraises)
        dynamicQuery.includeKey(HBDynamicComments)
        dynamicQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil {
                for dynamic in objects {
                    dynamics.append(dynamic as! Dynamic)
                }
                finishedCallBack(result: dynamics, error: nil)
            }else {
                finishedCallBack(result: nil, error: error)
            }
        })
    }

// 根据ID查找指定用户
   class func loadUserIconImageWithBackImage (user: HeartUser?, imageName: String?, finishedCallBack: HBNetFinishedCallBack) {
        let userQuery = HeartUser.query()
        userQuery.whereKey("objectId", equalTo: user?.objectId)
        userQuery.includeKey(HBPhotographAlbum)
        //设置缓存有
        userQuery.maxCacheAge = 24*3600;
        userQuery.getFirstObjectInBackgroundWithBlock { (obj, error) -> Void in
            if error == nil {
                finishedCallBack(result: [obj], error: nil)
            }
            if error != nil {
                finishedCallBack(result: nil, error: error)
            }
        }
    }
//    MARK: -- 查找指定用户的个人相册
    class func loadUserPhotographAlbumWithBackImage(param: [String: AnyObject], finishedCallBack: HBNetFinishedCallBack) {
        assert(param["objectId"] != nil, "查找相册时, userObjectId不能为空")
        let sql = "select photographAlbum from _User where objectId = ?"
        let dict = [param["objectId"]!]
        AVQuery.doCloudQueryInBackgroundWithCQL(sql, pvalues: dict) { (result, error) -> Void in
            if error == nil {
                finishedCallBack(result: result.results, error: nil)
            }else {
                 finishedCallBack(result: nil, error: error)
            }
        }
    }
// 查找所有User
  class func loadUsers (finishedCallBack: HBNetFinishedCallBack) {
        let userQuery = HeartUser.query()
        userQuery.cachePolicy = AVCachePolicy.NetworkElseCache
        //设置缓存有效期
        userQuery.maxCacheAge = 24*3600;
        userQuery.findObjectsInBackgroundWithBlock { (users, err) -> Void in
            if err == nil{
                finishedCallBack(result: users, error: nil)
            }else {
                if users != nil && users.count > 0 {
                    finishedCallBack(result: users, error: nil)
                    return
                }
                    finishedCallBack(result: nil, error: err)
            }
        }
    }
}

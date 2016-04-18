//
//  Dynamic.swift
//  Heartbeats
//
//  Created by iOS-3C on 16/1/2.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

let HBDynamicUser = "user"
let HBDynamicPhotos = "photos"
let HBDynamicContent = "content"
class Dynamic: AVObject, AVSubclassing {
    @NSManaged var user: HeartUser?
    @NSManaged var photos: [AnyObject]?
    @NSManaged var content: String?
    
   static func parseClassName() -> String? {
        return "Dynamic"
    }
}


extension Dynamic {
    class func photoUrls(dynamic: Dynamic) -> [String]? {
        var urls = [String]()
        if dynamic.photos?.count > 0 {
            for fileDate in dynamic.photos! {
                if let file = fileDate as? AVFile {
                   urls.append(file.url)
                }
            }
        }
        return urls
    }
}

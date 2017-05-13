//
//  BBSJarvis.swift
//  TJUBBS
//
//  Created by Halcao on 2017/5/10.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

struct BBSJarvis {
    
    //TODO: Model things here & View things in success
    static func login(username: String, password: String, failure: ((Error)->())? = nil, success:@escaping ()->()) {
        let para: [String : String] = ["username": username, "password": password]
        BBSBeacon.request(withType: .post, url: BBSAPI.login, parameters: para) { dict in
            if let data = dict["data"] as? [String: AnyObject] {
                BBSUser.shared.uid = data["uid"] as? Int
                BBSUser.shared.group = data["group"] as? Int
                BBSUser.shared.token = data["token"] as? String
                BBSUser.shared.username = username
                // 用 UserDefaults 存起来 BBSUser.shared
                BBSUser.save()
            }
            success()
        }
    }
    
    static func register(parameters: [String : String], failure: ((Error)->())? = nil, success: @escaping ([String: AnyObject])->()) {
        BBSBeacon.request(withType: .post, url: BBSAPI.register, parameters: parameters, failure: failure, success: success)
    }
    
//    static func getForumList(failure: ((Error)->())? = nil, success: @escaping ([String: AnyObject])->()) {
//        BBSBeacon.request(withType: .get, url: BBSAPI.forum, token: nil, parameters: nil,failure: failure, success: success)
//    }
    
    static func getHome() {
        BBSBeacon.request(withType: .get, url: BBSAPI.home, parameters: nil) { dict in
            if let data = dict["data"] as? [String: AnyObject],
                let name = data["name"],
                let nickname = data["nickname"],
                let real_name = data["real_name"],
                let signature = data["signature"],
                let post_count = data["post_count"],
                let unread_count = data["unread_count"],
                let points = data["points"],
                let level = data["level"],
                let c_online = data["c_online"],
                let group = data["group"] {
                BBSUser.shared.username = name as? String
                BBSUser.shared.nickname = nickname as? String
                BBSUser.shared.realName = real_name as? String
                BBSUser.shared.signature = signature as? String
                BBSUser.shared.postCount = post_count as? String
                BBSUser.shared.unreadCount = unread_count as? String
                BBSUser.shared.points = points as? String
                BBSUser.shared.level = level as? String
                BBSUser.shared.cOnline = c_online as? String
                BBSUser.shared.group = group as? Int
                
            }
        }
    }
    
    static func getAvatar() {
        
    }
}

//
//  BBSUser.swift
//  TJUBBS
//
//  Created by Halcao on 2017/5/10.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import ObjectMapper

let BBSUSERSHAREDKEY = "BBSUserSharedKey"

/*
 "name" : "用户名",
 "nickname" : "昵称",
 "real_name" : "真实姓名",
 "signature" : "个性签名",
 "post_count" : "发帖总数",
 "unread_count" : "未读消息总数",
 "points" : "积分",
 "level" : "等级",
 "c_online" : "上线次数",
 "group" : "用户组"
 */
//import ObjectMapper

class BBSUser {
    private init() {}
    static let shared = BBSUser()
    
    var username: String?
    var nickname: String?
    var realName: String?
    var signature: String?
    var postCount: Int?
    var threadCount: Int?
    var unreadCount: Int?
    var points: Int?
    var level: Int?
    var token: String?
    var cOnline: Int?
    var uid: Int?
    var group: Int?
    var createTime: Int?
    var avatar: UIImage?
    var tCreate: Int?
    var oldToken: String?
    var resetPasswordToken: String?
    var isVisitor: Bool = false
    var blackList: [String : Int] = [:]
    var fontSize: Int = 14
    
//    required init?(map: Map) {}
//    
//    func mapping(map: Map) {
//        username <- map["username"]
//        nickname <- map["nickname"]
//        realName <- map["realName"]
//        signature <- map["signature"]
//        postCount <- map["postCount"]
//        unreadCount <- map["unreadCount"]
//        points <- map["points"]
//        level <- map["level"]
//        token <- map["token"]
//        cOnline <- map["cOnline"]
//        uid <- map["uid"]
//        group <- map["group"]
//    }
    
    
    static func load(wrapper: UserWrapper) {
        BBSUser.shared.username = wrapper.username
        BBSUser.shared.nickname = wrapper.nickname
        BBSUser.shared.signature = wrapper.signature
        BBSUser.shared.postCount = wrapper.postCount
        BBSUser.shared.threadCount = wrapper.threadCount
        BBSUser.shared.points = wrapper.points
        BBSUser.shared.cOnline = wrapper.cOnline
        BBSUser.shared.group = wrapper.group
        BBSUser.shared.tCreate = wrapper.tCreate
        BBSUser.save()
    }
    
    static func save() {
//        let list = NSDictionary(dictionary: BBSUser.shared.blackList)
        let list = NSMutableDictionary()
        for key in Array<String>(BBSUser.shared.blackList.keys) {
            if let uid = BBSUser.shared.blackList[key] {
                list.setValue(uid, forKey: key)
            }
        }
        let dic: [String : Any] = ["username": BBSUser.shared.username ?? "", "token": BBSUser.shared.token ?? "", "uid": BBSUser.shared.uid ?? -1, "group": BBSUser.shared.group ?? -1, "blackList": list, "fontSize": BBSUser.shared.fontSize]
        UserDefaults.standard.set(NSDictionary(dictionary: dic), forKey: BBSUSERSHAREDKEY)
    }
    
    static func load() {
        if let dic = UserDefaults.standard.object(forKey: BBSUSERSHAREDKEY) as? NSDictionary,
            let username = dic["username"] as? String,
            let token = dic["token"] as? String,
            let uid = dic["uid"] as? Int,
            let group = dic["group"] as? Int,
            let fontSize = dic["fontSize"] as? Int,
            let list = dic["blackList"] as? NSDictionary {
            BBSUser.shared.username = username
            BBSUser.shared.uid = (uid == -1) ? nil : uid
            BBSUser.shared.token = (token == "") ? nil : token
            BBSUser.shared.group = (group == -1) ? nil : group
            BBSUser.shared.fontSize = fontSize
            var dict = Dictionary<String, Int>()
            if let keys = list.allKeys as? [String] {
                for key in keys {
                    if let uid = list[key] as? Int {
                        dict[key] = uid
                    }
                }
            }
            BBSUser.shared.blackList = dict
        }
    }
    
    static func delete() {
        //TODO: ??????  delete "BBSUser.shared."
        BBSUser.shared.username = nil
        BBSUser.shared.nickname = nil
        BBSUser.shared.token = nil
        BBSUser.shared.uid = nil
        BBSUser.shared.group = nil
        BBSUser.shared.avatar = nil
        BBSUser.shared.postCount = nil
        BBSUser.shared.threadCount = nil
        BBSUser.shared.points = nil
        BBSUser.shared.tCreate = nil
        BBSUser.shared.signature = nil
        BBSUser.shared.blackList.removeAll()
        UserDefaults.standard.removeObject(forKey: BBSUSERSHAREDKEY)
    }
    
}

class UserWrapper: NSObject, Mappable {
    var username: String?
    var nickname: String?
    var signature: String?
    var postCount: Int?
    var threadCount: Int?
    var points: Int?
    var level: Int?
    var cOnline: Int?
    var group: Int?
    var tCreate: Int?
    var uid: Int?
    var status: Int?
    var recentThreads: [ThreadModel] = []
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        username <- map["name"]
        nickname <- map["nickname"]
        signature <- map["signature"]
        postCount <- map["c_post"]
        threadCount <- map["c_thread"]
        points <- map["points"]
        cOnline <- map["c_online"]
        group <- map["group"]
        tCreate <- map["t_create"]
        uid <- map["uid"]
        status <- map["status"]
    }
}


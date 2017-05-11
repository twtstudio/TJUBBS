//
//  BBSUser.swift
//  TJUBBS
//
//  Created by Halcao on 2017/5/10.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

let BBSUSERSHAREDKEY = "BBSUserSharedKey"

class BBSUser {
    private init() {}
    static let shared = BBSUser()
    var username: String?
    var token: String?
    var uid: Int?
    var group: Int?
    
    func save() {
        let dic: [String : Any] = ["username": username ?? "", "token": token ?? "", "uid": uid ?? -1, "group": group ?? -1]
//        let dict = NSDictionary(objects: [username, token, uid, group], forKeys: ["username", "token", "uid", "group"])
        UserDefaults.standard.set(NSDictionary(dictionary: dic), forKey: BBSUSERSHAREDKEY)
    }
    
    func load() {
        if let dic = UserDefaults.standard.object(forKey: BBSUSERSHAREDKEY) as? NSDictionary,
            let username = dic["username"] as? String,
            let token = dic["token"] as? String,
            let uid = dic["uid"] as? Int,
            let group = dic["group"] as? Int {
            self.username = username
            self.uid = uid
            self.token = token
            self.group = group
        }
    }
    
    func delete() {
        BBSUser.shared.username = nil
        BBSUser.shared.token = nil
        BBSUser.shared.uid = nil
        BBSUser.shared.group = nil
        UserDefaults.standard.removeObject(forKey: BBSUSERSHAREDKEY)
    }
}

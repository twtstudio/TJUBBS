
//
//  BBSCache.swift
//  TJUBBS
//
//  Created by Halcao on 2017/10/16.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

let BBSCACHEKEY = "BBSCACHEKEY"
// 全站十大 - topThreads
let BBSTOPTHREADCACHEKEY = "BBSTOPTHREADCACHEKEY"
let BBSTOPLASTUPDATETIMECACHEKEY = "BBSTOPLASTUPDATETIMECACHEKEY"

class BBSCache {
    private init() {
        topThreads = UserDefaults.standard.object(forKey: BBSTOPTHREADCACHEKEY) as? [ThreadModel] ?? []
        lastUpdateTime = UserDefaults.standard.object(forKey: BBSTOPLASTUPDATETIMECACHEKEY) as? Date ?? Date(timeIntervalSince1970: 0)
    }
    static let shared = BBSCache()
    
    var topThreads: [ThreadModel] {
        didSet {
            if topThreads.isEmpty == false {
                UserDefaults.standard.set(topThreads, forKey: BBSTOPTHREADCACHEKEY)
            }
        }
    }
    
    var lastUpdateTime: Date {
        get {
            return self.lastUpdateTime
        }
        set {
            if newValue.compare(lastUpdateTime) == .orderedDescending {
                self.lastUpdateTime = newValue
                UserDefaults.standard.set(lastUpdateTime, forKey: BBSTOPTHREADCACHEKEY)
            }
        }
    }
    
    func save() {
//        let dic: [String : Any] = ["username": BBSUser.shared.username ?? "", "token": BBSUser.shared.token ?? "", "uid": BBSUser.shared.uid ?? -1, "group": BBSUser.shared.group ?? -1, "blackList": list, "fontSize": BBSUser.shared.fontSize]
//        UserDefaults.standard.set(NSDictionary(dictionary: dic), forKey: BBSCACHEKEY)
    }
}

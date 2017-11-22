
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
        topThreads = UserDefaults(suiteName: "com.TJUBBS")?.object(forKey: BBSTOPTHREADCACHEKEY) as? [ThreadModel] ?? []
        lastUpdateTime = UserDefaults(suiteName: "com.TJUBBS")?.object(forKey: BBSTOPLASTUPDATETIMECACHEKEY) as? Date ?? Date(timeIntervalSince1970: 0)
    }
    static let shared = BBSCache()
    
    var topThreads: [ThreadModel] {

        didSet {
            if topThreads.isEmpty == false {
                // 存起来
                UserDefaults(suiteName: "com.TJUBBS")?.set(topThreads, forKey: BBSTOPTHREADCACHEKEY)
            }
        }
    }
    
    var lastUpdateTime: Date {
        didSet {
            if oldValue.compare(lastUpdateTime) == .orderedAscending {
                // if time is more up to date
                UserDefaults(suiteName: "com.TJUBBS")?.set(lastUpdateTime, forKey: BBSTOPTHREADCACHEKEY)
            }  else {
                lastUpdateTime = oldValue
            }
        }
    }
    
    func save() {
//        let dic: [String : Any] = ["username": BBSUser.shared.username ?? "", "token": BBSUser.shared.token ?? "", "uid": BBSUser.shared.uid ?? -1, "group": BBSUser.shared.group ?? -1, "blackList": list, "fontSize": BBSUser.shared.fontSize]
//        UserDefaults.standard.set(NSDictionary(dictionary: dic), forKey: BBSCACHEKEY)
    }
}

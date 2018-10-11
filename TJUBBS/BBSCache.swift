//
//  BBSCache.swift
//  TJUBBS
//
//  Created by Halcao on 2017/10/16.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import Foundation
import ObjectMapper

let BBSCACHEKEY = "BBSCACHEKEY"
// 全站十大 - topThreads
let BBSTOPTHREADCACHEKEY = "BBSTOPTHREADCACHEKEY"
let BBSTOPLASTUPDATETIMECACHEKEY = "BBSTOPLASTUPDATETIMECACHEKEY"

struct BBSCache {
    static func set(_ object: Any, forKey key: String) {
        UserDefaults(suiteName: "com.TJUBBS")?.set(object, forKey: key)
    }

    static func object(forKey key: String) -> Any? {
        return UserDefaults(suiteName: "com.TJUBBS")?.object(forKey: key)
    }

    static func getTopThread() -> [ThreadModel] {
        if let json = object(forKey: BBSTOPTHREADCACHEKEY) as? [[String: Any]] {
            return Mapper<ThreadModel>().mapArray(JSONArray: json)
        }
        return []
    }

    static func saveTopThread(threads: [ThreadModel]) {
        set(threads.toJSON(), forKey: BBSTOPTHREADCACHEKEY)
    }
}

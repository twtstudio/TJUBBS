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
    enum Filename: String {
        case topThreads
        case threadList
    }
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

    static func store<T: Encodable>(object: T, in directory: Storage.Directory, as filename: Filename) {
        Storage.store(["com.tjubbs.cache": object], in: directory, as: filename.rawValue)
    }

    static func retreive<T: Decodable>(_ filename: Filename, from directory: Storage.Directory, as type: T.Type, success: @escaping (T) -> Void, failure: (() -> Void)? = nil) {
        guard fileExists(filename: filename.rawValue, in: directory) else {
            failure?()
            return
        }

        let queue = DispatchQueue(label: "com.tjubbs.cache")
        queue.async {
            let obj = Storage.retreive(filename.rawValue, from: directory, as: [String: T].self)
            DispatchQueue.main.async {
                if let obj = obj, let object = obj["com.tjubbs.cache"] {
                    success(object)
                } else {
                    failure?()
                }
            }
        }
    }

    static func fileExists(filename: String, in directory: Storage.Directory) -> Bool {
        return Storage.fileExists(filename, in: directory)
    }

    static func clear(directory: Storage.Directory) {
        Storage.clear(subdirectory: "./", in: directory)
    }

    static func delete(filename: String, in directory: Storage.Directory) {
        guard fileExists(filename: filename, in: directory) else {
            return
        }
        Storage.remove(filename, from: directory)
    }
}

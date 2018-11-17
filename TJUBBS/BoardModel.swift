//
//  BoardModel.swift
//  TJUBBS
//
//  Created by Halcao on 2017/5/9.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

// Forums -> Boards -> Board -> Thread

import Foundation
import ObjectMapper

class BoardModel: Mappable {
    var id: Int = 0
    var name: String = ""
    var info: String = ""
    var admin: String = ""
    var threadCount: Int = 0
    var visibility: Int = 0
    var anonymous = 0
    var forumID: Int = 0
    var forumName: String = ""
    var hidden: Int = 0

    required init?(map: Map) {}

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        info <- map["info"]
        admin <- map["admin"]
        threadCount <- map["c_thread"]
        visibility <- map["visibility"]
        forumID <- map["forum_id"]
        forumName <- map["forum_name"]
        anonymous <- map["anonymous"]
    }
}

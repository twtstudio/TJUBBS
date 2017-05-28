//
//  ThreadModel.swift
//  TJUBBS
//
//  Created by Halcao on 2017/5/9.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import Foundation
import ObjectMapper

struct ThreadModel: Mappable {
    
    var id: Int = 0
    var title: String = ""
    var authorID: Int = 0
    var boardID: Int = 0
    var authorName: String = "未知用户"
    var authorNickname: String = ""
    var isTop: Bool = false
    var isElite: Bool = false
    var visibility: Int = 0 // 0 for always, 1 for logged in users, 2 for never
    var createTime: Int = 0
    var modifyTime: Int = 0
    var content: String = ""
    var category: String = ""
    var replyNumber: Int = 0
    var inCollection: Bool = false
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        authorID <- map["author_id"]
        boardID <- map["board_id"]
        authorName <- map["author_name"]
        authorNickname <- map["author_nickname"]
        replyNumber <- map["c_post"]
        isTop <- map["b_top"]
        isElite <- map["b_elite"]
        visibility <- map["visibility"]
        createTime <- map["t_create"]
        modifyTime <- map["t_modify"]
        content <- map["content"]
        category <- map["category"]
        inCollection <- map["in_collection"]
    }
    
}

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
    
    var id = 0
    var title = ""
    var authorID = 0
    var boardID = 0
    var authorName = "未知用户"
    var authorNickname = ""
    var isTop = false
    var isElite = false
    var isLocked = false
    var visibility = 0 // 0 for always, 1 for logged in users, 2 for never
    var createTime = 0
    var modifyTime = 0
    var replyTime = 0
    var content = ""
    var category = ""
    var replyNumber = 0
    var inCollection = false
    var anonymous = 0
    var boardName = ""
    var isFriend = false
    var likeCount = 0
    var isLiked = false
    
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
        replyTime <- map["t_reply"]
        content <- map["content"]
        category <- map["category"]
        inCollection <- map["in_collection"]
        anonymous <- map["anonymous"]
        boardName <- map["board_name"]
        isFriend <- map["friend"]
        isLocked <- map ["b_locked"]
        likeCount <- map["like"]
        isLiked <- map["liked"]
    }
    
}

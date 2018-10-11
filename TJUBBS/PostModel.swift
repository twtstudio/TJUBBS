//
//  PostModel.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/15.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import Foundation
import ObjectMapper

struct PostModel: Mappable {

    var id: Int = 0
    var authorID: Int = 0
    var authorName: String = ""
    var authorNickname: String = ""
    var content: String = ""
    var floor: Int = 0
    var createTime: Int = 0
    var modifyTime: Int = 0
    var replyNumber: Int = 0
    var tid: Int = 0
    var anonymous: Int = 0
    var isFriend = false
    var likeCount = 0
    var isLiked = false

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        id <- map["id"]
        authorID <- map["author_id"]
        authorName <- map["author_name"]
        authorNickname <- map["author_nickname"]
        content <- map["content"]
        floor <- map["floor"]
        createTime <- map["t_create"]
        modifyTime <- map["t_modify"]
        replyNumber <- map["replyNumber"]
        tid <- map["thread_id"]
        anonymous <- map["anonymous"]
        isLiked <- map["liked"]
        likeCount <- map["like"]
        isFriend <- map["friend"]
    }
}

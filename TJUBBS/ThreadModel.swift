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
    var authorName: String = ""
    var isTop: Bool = false
    var isElite: Bool = false
    var visibility: Int = 0 // 0 for always, 1 for logged in users, 2 for never
    var createTime: Int = 0
    var modifyTime: Int = 0
    var content: String = "锦瑟无端五十弦，一弦一柱思华年。庄生晓梦迷蝴蝶，望帝春心托杜鹃。沧海月明珠有泪，兰田日暖玉生烟。此情可待成追忆，只是当时已惘然"
    var category: String = ""
    var replyNumber: Int = 0
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        authorID <- map["author_id"]
        boardID <- map["board_id"]
        authorName <- map["author_name"]
        isTop <- map["b_top"]
        isElite <- map["b_elite"]
        visibility <- map["visibility"]
        createTime <- map["t_create"]
        modifyTime <- map["t_modify"]
        content <- map["content"]
        category <- map["category"]
        replyNumber <- map["reply_number"]
    }
    
}

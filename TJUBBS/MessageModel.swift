
//
//  MessageModel.swift
//  TJUBBS
//
//  Created by Halcao on 2017/5/16.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import ObjectMapper

struct MessageModel: Mappable {
    var id = 0
    var content = ""
    var authorId = 0
    var authorName = ""
    var authorNickname = ""
    var tag = 0
    var read = -1
    var createTime = 0
    var detailContent: MessageContentModel?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        content <- map["content"]
        authorId <- map["author_id"]
        authorName <- map["author_name"]
        authorNickname <- map["author_nickname"]
        tag <- map["tag"]
        read <- map["read"]
        createTime <- map["t_create"]
    }

}

struct MessageContentModel: Mappable {
    var id: Int = 0
    var thread_id: Int = 0
    var title: String = ""
    var floor: Int = 0
    var createTime: Int = 0
    var modifyTime: Int = 0
    var content: String = ""
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        thread_id <- map["thread_id"]
        title <- map["thread_title"]
        content <- map["content"]
        floor <- map["floor"]
        createTime <- map["t_create"]
        modifyTime <- map["t_modify"]
    }
}


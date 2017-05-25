
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
    var t_create = 0
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        content <- map["content"]
        authorId <- map["author_id"]
        authorName <- map["author_name"]
        authorNickname <- map["author_nickname"]
        tag <- map["tag"]
        read <- map["read"]
        t_create <- map["t_create"]
    }

}

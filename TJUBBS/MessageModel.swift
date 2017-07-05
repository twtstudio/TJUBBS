
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
    var authorId: Int = 0 {
        didSet(newValue) {
            if authorId != BBSUser.shared.uid {
                type = .received
            }
        }
    }
    var authorName = ""
    var authorNickname = ""
    var tag = 0
    var read = -1
    var createTime = 0
    var type: CellType = .sent
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

    init(string: String, timestamp: Int, type: CellType, palName: String, palNickName: String, palID: Int, id: Int) {
        self.id = id
        self.content = string
        self.authorId = palID
        self.authorName = palName
        self.authorNickname = palNickName
        self.createTime = timestamp
    }
}

struct MessageContentModel: Mappable {
    var id: Int = 0
    var thread_id: Int = 0
    var thread_title: String = ""
    var floor: Int = 0
    var createTime: Int = 0
    var modifyTime: Int = 0
    var content: String = ""
    var anonymous: Int = 0
    var reply_id: Int = 0
    var reply_content: String = ""
    var allow_anonymous: Int = 0
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        thread_id <- map["thread_id"]
        thread_title <- map["thread_title"]
        content <- map["content"]
        floor <- map["floor"]
        createTime <- map["t_create"]
        modifyTime <- map["t_modify"]
        anonymous <- map["anonymous"]
        reply_id <- map["reply_id"]
        reply_content <- map["reply_content"]
        allow_anonymous <- map["allow_anonymous"]
    }
}

struct FriendRequestModel: Mappable {
    var message = ""
    var id = ""
    var status = 0
    var uid = 0
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        message <- map["message"]
        status <- map["status"]
    }
}


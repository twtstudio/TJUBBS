//
//  ForumModel.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/12.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import Foundation
import ObjectMapper

struct ForumModel: Mappable {

    var id: Int = 0
    var name: String = ""
    var info: String = ""
    var admin: String = ""
    var boardCount: Int = 0

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        info <- map["info"]
        admin <- map["admin"]
        boardCount <- map["c_board"]
    }
}

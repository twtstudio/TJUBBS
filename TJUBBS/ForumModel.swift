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
    
    var id: String?
    var name: String?
    var info: String?
    var admin: String?
    var childBoard: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        info <- map["info"]
        admin <- map["admin"]
        childBoard <- map["c_board"]
    }
}

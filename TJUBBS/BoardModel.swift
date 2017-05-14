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

struct BoardModel: Mappable {
    
    var id: Int = 0
    var name: String = ""
    var info: String = ""
    var admin: String = ""
    var threadCount: Int = 0
    var visibility: Int = 0
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        info <- map["info"]
        admin <- map["admin"]
        threadCount <- map["c_thread"]
        visibility <- map["visibility"]
    }
}

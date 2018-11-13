//
//  UserModel.swift
//  TJUBBS
//
//  Created by 侯钦瀚 on 2018/11/5.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserModel: Mappable {
    var name = ""
    var nickname = ""
    var signature = ""
    var totalPoints = 0
    var getPoints = 0
    var id = 0
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        nickname <- map["nickname"]
        signature <- map["signature"]
        totalPoints <- map["points"]
        getPoints <- map["points_inc"]
        id <- map["id"]
    }
}

//
//  ForumModel.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/12.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import Foundation
import ObjectMapper

typealias ForumModel = ForumWrapperModel<BoardModel>

class ForumWrapperModel<T: Mappable>: Mappable {
    var id: Int = 0
    var name: String = ""
    var info: String = ""
    var admin: String = ""
    var boardCount: Int = 0
    var boards: [T] = []

    required init?(map: Map) {}

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        info <- map["info"]
        admin <- map["admin"]
        boardCount <- map["c_board"]
        boards <- map["boards"]
    }
}

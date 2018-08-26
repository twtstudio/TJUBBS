//
//  InputItem.swift
//  TJUBBS
//
//  Created by Halcao on 2017/5/1.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

class InputItem: ExpressibleByStringLiteral {
    var title: String = ""
    var placeholder: String = ""
    var rawName: String = ""
    var isSecure = false
    var type: TextInputCellType = .textField
//    ["姓名-请输入姓名-name-s"] // -s secure
    required init(stringLiteral value: String) {
        decodeString(value: value)
    }

    required init(extendedGraphemeClusterLiteral value: String) {
        decodeString(value: value)
    }

    required init(unicodeScalarLiteral value: String) {
        decodeString(value: value)
    }

    func decodeString(value: String) {
        let array = value.split(separator: "-").map(String.init)
        guard array.count >= 3 else {
            fatalError("用错了啊兄弟 Usage: 标签-提示-字段(-s) -s 私密模式")
        }
        title = array[0]
        placeholder = array[1]
        rawName = array[2]
        if array.last == "s" {
            isSecure = true
        }
        if array.last == "v" {
            type = .textView
        }
    }
}

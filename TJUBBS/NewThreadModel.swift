//
//  NewThreadModel.swift
//  TJUBBS
//
//  Created by 侯钦瀚 on 2018/4/26.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class NewThreadModel {
    var threadTitle: String?
    var userName: String?
    var postTime: String?
    var replyNum: String?
    var threadContent: String?

    init(threadTitle: String, userName: String, postTime: String, replyNum: String, threadContent: String) {
        self.threadTitle = threadTitle
        self.userName = userName
        self.postTime = postTime
        self.replyNum = replyNum
        self.threadContent = threadContent
    }
}

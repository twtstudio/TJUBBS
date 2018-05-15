//
//  BBSAPI.swift
//  TJUBBS
//
//  Created by Halcao on 2017/5/11.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit


struct BBSAPI {
//    private static let baseURL = "https://bbs.twtstudio.com/api"
    private static let baseURL = "https://bbs.tju.edu.cn/api"
//    static let base = "https://bbs.twtstudio.com/api"
    private static let base = "https://bbs.tju.edu.cn/api"
    static let login =  BBSAPI.baseURL + "/passport/login"
    static let retrieve =  BBSAPI.baseURL + "/passport/retrieve"
    static let resetPassword =  BBSAPI.baseURL + "/passport/reset-pass"
    static let register =  BBSAPI.baseURL + "/passport/register/new"
    static let home = BBSAPI.baseURL + "/home"
    static let forumList = base + "/forum"
    static let index = base + "/index"
    static let collect = base + "/home/collection"
    static let loginOld = base + "/passport/login/old"
    static let registerOld = base + "/passport/register/old"
    static let sendMessage = base + "/home/message"
    static let messageCount = base + "/home/message/count"
    static let messageRead = base + "/home/message/read"
    static let appeal = base + "/passport/appeal"
    static let friendList = base + "/home/friend"
    static let attach = base + "/attach"
    static let friendConfirm = base + "/home/friend/confirm"

//    static var avatar = BBSAPI.baseURL + "avatar"
    static var avatar: String {
        return BBSAPI.baseURL + "/user/" + String(BBSUser.shared.uid ?? 0) + "/avatar"
    }
    static let setAvatar = BBSAPI.baseURL + "/home/avatar"
    
    static func boardList(forumID: Int) -> String {
        return base + "/forum/\(forumID)"
    }
    
    static func threadList(boardID: Int, page: Int, type: String) -> String { // tpye for "elite" or ""
        return base + "/board/\(boardID)/page/\(page)\(type)"
    }
    
    static func thread(threadID: Int, page: Int) -> String {
        return base + "/thread/\(threadID)/page/\(page)"
    }
    
    static func postThread(boardID: Int) -> String {
        return base + "/board/\(boardID)"
    }
    
    static func reply(threadID: Int) -> String {
        return base + "/thread/\(threadID)"
    }
    
    static func avatar(uid: Int) -> String {
        return BBSAPI.baseURL + "/user/\(uid)/avatar"
    }
    
    static func forumCover(fid: Int) -> String {
        return base + "/forum/\(fid)/cover"
    }
    
    static func message(page: Int) -> String {
        return base + "/home/message/page/\(page)"
    }
    
    static func deleteCollection(threadID: Int) -> String {
        return base + "/home/collection/\(threadID)"
    }
    
    static func myThreadList(page: Int) -> String {
        return base + "/home/publish/thread/page/\(page)"
    }
    
    static func myPostList(page: Int) -> String {
        return base + "/home/publish/post/page/\(page)"
    }
    
    static func dialog(uid: Int, page: Int) -> String {
        return base + "/home/message/dialog/\(uid)/page/\(page)"
    }

    static func home(uid: Int) -> String {
        return base + "/user/\(uid)/home"
    }
    
    static func post(pid: Int) -> String {
        return base + "/post/\(pid)"
    }
    
    static func thread(tid: Int) -> String {
        return base + "/thread/\(tid)"
    }
    
    static func friend(uid: Int) -> String {
        return base + "/home/friend/\(uid)"
    }
    
    static func searchThread(keyword: String, page: Int) -> String {
        return base + "/search/page/\(page)?keyword=" + keyword
    }
    
    static func searchUser(keyword: String) -> String {
        return base + "/search/user/" + keyword
    }
    
    static func index(page: Int) -> String {
        return base + "/index/latest?p=\(page)"
    }
    
    static func like(pid: Int) -> String {
        return base + "/post/\(pid)/like"
    }
    
    static func like(tid: Int) -> String {
        return base + "/thread/\(tid)/like"
    }
    
}

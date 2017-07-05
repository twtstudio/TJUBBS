//
//  BBSJarvis.swift
//  TJUBBS
//
//  Created by Halcao on 2017/5/10.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import ObjectMapper

struct BBSJarvis {
    
    static func login(username: String, password: String, failure: ((Error)->())? = nil, success:@escaping ()->()) {
        let para: [String : String] = ["username": username, "password": password]
        BBSBeacon.request(withType: .post, url: BBSAPI.login, parameters: para, failure: failure) { dict in
            if let data = dict["data"] as? [String: Any] {
                BBSUser.shared.uid = data["uid"] as? Int
                BBSUser.shared.group = data["group"] as? Int
                BBSUser.shared.token = data["token"] as? String
                BBSUser.shared.username = username
                // 用 UserDefaults 存起来 BBSUser.shared
                BBSUser.save()
            }
            success()
        }
    }
    
    static func register(parameters: [String : String], failure: ((Error)->())? = nil, success: @escaping ([String: Any])->()) {
        BBSBeacon.request(withType: .post, url: BBSAPI.register, parameters: parameters, failure: failure, success: success)
    }
    
    static func getHome(uid: Int = 0, success: ((UserWrapper)->())?, failure: @escaping (Error)->()) {
        if uid == 0 {
            BBSBeacon.request(withType: .get, url: BBSAPI.home, parameters: nil, failure: failure) { dict in
                if let data = dict["data"] as? [String: Any], let wrapper = Mapper<UserWrapper>().map(JSON: data) {
                    BBSUser.load(wrapper: wrapper)
                    success?(wrapper)
                } else if let err = dict["err"] as? Int, err == 0 {
                    failure(BBSError.custom)
                }
            }
        } else {
            BBSBeacon.request(withType: .get, url: BBSAPI.home(uid: uid), parameters: nil, failure: failure) { dict in
                if let data = dict["data"] as? [String : Any], let wrapper = Mapper<UserWrapper>().map(JSON: data), let recent = data["recent"] as? [[String : Any]] {
                    wrapper.uid = uid
                    wrapper.recentThreads = Mapper<ThreadModel>().mapArray(JSONArray: recent)
                    success?(wrapper)
                } else if let err = dict["err"] as? Int, err == 0 {
                    failure(BBSError.custom)
                }
            }
        }
    }
    
    static func getAvatar(success:@escaping (UIImage)->(), failure: @escaping (Error)->()) {
        BBSBeacon.requestImage(url: BBSAPI.avatar, failure: failure, success: success)
    }
    
    static func setAvatar(image: UIImage, success:@escaping ()->(), failure: @escaping (Error)->()) {
        BBSBeacon.uploadImage(url: BBSAPI.setAvatar, image: image, failure: failure, success: { _ in
                success()
        })
    }
    
    static func setInfo(para: [String : String], success: @escaping ()->(), failure: @escaping (Error)->()) {
        BBSBeacon.request(withType: .put, url: BBSAPI.home, parameters: para, failure: failure) { dict in
            success()
        }
    }

    static func getForumList(failure: ((Error)->())? = nil, success: @escaping ([String: Any])->()) {
        BBSBeacon.request(withType: .get, url: BBSAPI.forumList, token: nil, parameters: nil, failure: failure, success: success)
    }
    
    static func getBoardList(forumID: Int, failure: ((Error)->())? = nil, success: @escaping ([String: Any])->()) {
        BBSBeacon.request(withType: .get, url: BBSAPI.boardList(forumID: forumID), token: nil, parameters: nil, failure: failure, success: success)
    }
    
    static func getThreadList(boardID: Int, page: Int, type: String = "", failure: ((Error)->())? = nil, success: @escaping ([String: Any])->()) {
        print("API:\(BBSAPI.threadList(boardID: boardID, page: page, type: type))")
        BBSBeacon.request(withType: .get, url: BBSAPI.threadList(boardID: boardID, page: page, type: type), parameters: nil, failure: failure, success: success)
    }

    //TODO: cache Homepage
    static func getIndex(failure: ((Error)->())? = nil, success: @escaping ([String: Any])->()) {
        BBSBeacon.request(withType: .get, url: BBSAPI.index, parameters: nil, failure: failure, success: success)
    }
    
    static func getThread(threadID: Int, page: Int, failure: ((Error)->())? = nil, success: @escaping ([String: Any])->()) {
        BBSBeacon.request(withType: .get, url: BBSAPI.thread(threadID: threadID, page: page), parameters: nil, failure: failure, success: success)
    }

    
    static func postThread(boardID: Int, title: String, anonymous: Bool = false, content: String, failure: ((Error)->())? = nil, success: @escaping ([String: Any])->()) {
        var parameters = [
            "title": title,
            "content": content
        ]
        if anonymous == true {
            parameters["anonymous"] = "1"
        }
//        print("API:\(BBSAPI.postThread(boardID: boardID))")
//        print(parameters)
        BBSBeacon.request(withType: .post, url: BBSAPI.postThread(boardID: boardID), parameters: parameters, success: success)
    }
    
//    static func getMsgList(page: Int, failure: ((Error)->())? = nil, success: @escaping ([MessageModel])->()) {
//        BBSBeacon.request(withType: .get, url: BBSAPI.reciveMessage(page: page), parameters: nil, success: success)
//    }
    

    static func reply(threadID: Int, content: String, toID: Int? = nil, anonymous: Bool = false, failure: ((Error)->())? = nil, success: @escaping ([String: Any])->()) {
        var parameters = ["content": content]
        if let id = toID {
            parameters["reply"] = String(id)
        }
        if anonymous == true {
            parameters["anonymous"] = "1"
        }
        BBSBeacon.request(withType: .post, url: BBSAPI.reply(threadID: threadID), parameters: parameters, success: success)
    }
    
    static func getMessageCount(page: Int, failure: ((Error)->())? = nil, success: @escaping ([String: Any])->()) {
        BBSBeacon.request(withType: .get, url: BBSAPI.message(page: page), parameters: nil, success: success)
    }
    
    static func getMessage(page: Int, failure: ((Error)->())? = nil, success: @escaping ([MessageModel])->()) {
        BBSBeacon.request(withType: .get, url: BBSAPI.message(page: page), parameters: nil, failure: failure) { dict in
            if let data = dict["data"] as? [[String: Any]] {
                var msgList = Array<MessageModel>()
                for msg in data {
                    let model = MessageModel(JSON: msg)
                    if var model = model {
                        if (msg["content"] as? String) != nil {
                            msgList.append(model)
                        } else if let content = msg["content"] as? [String : Any] {
                            let contentModel = MessageContentModel(JSON: content)
                            model.detailContent = contentModel
                            msgList.append(model)
                        }
                    }
                }
                success(msgList)
            }
        }
    }

    
    
    static func collect(threadID: Int, failure: ((Error)->())? = nil, success: @escaping ([String: Any])->()) {
        let parameters = ["tid": "\(threadID)"]
        BBSBeacon.request(withType: .post, url: BBSAPI.collect, parameters: parameters, success: success)
    }
    
    static func deleteCollect(threadID: Int, failure: ((Error)->())? = nil, success: @escaping ([String: Any])->()) {
        BBSBeacon.request(withType: .delete, url: BBSAPI.deleteCollection(threadID: threadID), parameters: nil, success: success)
    }
    
    static func getCollectionList(failure: ((Error)->())? = nil, success: @escaping ([String: Any])->()) {
        BBSBeacon.request(withType: .get, url: BBSAPI.collect, parameters: nil, success: success)
    }
    
    static func getMyThreadList(page: Int, failure: ((Error)->())? = nil, success: @escaping ([String: Any])->()) {
        BBSBeacon.request(withType: .get, url: BBSAPI.myThreadList(page: page), parameters: nil, success: success)
    }
    
    
    static func loginOld(username: String, password: String, failure: ((Error)->())? = nil, success: @escaping ([String: Any])->()) {
        let parameters = ["username": username, "password": password]
        BBSBeacon.request(withType: .post, url: BBSAPI.loginOld, parameters: parameters, success: success)
    }
    
    static func registerOld(username: String, password: String, cid: String, realName: String, failure: ((Error)->())? = nil, success: @escaping ([String: Any])->()) {
        let parameters = [
            "username": username,
            "password": password,
            "cid": cid,
            "real_name": realName,
            "token": BBSUser.shared.oldToken!
        ]
        BBSBeacon.request(withType: .post, url: BBSAPI.registerOld, parameters: parameters, success: success)
    }
    

    static func sendMessage(uid: String, content: String, failure: ((Error)->())? = nil, success: @escaping ([String: Any])->()) {
        let para = ["to_uid": uid, "content": content]
        BBSBeacon.request(withType: .post, url: BBSAPI.sendMessage, parameters: para, success: success)
    }
    
    static func appeal(username: String, cid: String, realName: String, studentNumber: String, email: String, message: String, failure: ((Error)->())? = nil, success: @escaping ([String: Any])->()) {
        let parameters = [
            "username": username,
            "cid": cid,
            "real_name": realName,
            "stunum": studentNumber,
            "email": email,
            "message": message
        ]
        BBSBeacon.request(withType: .post, url: BBSAPI.appeal, parameters: parameters, success: success)

    }
    
    static func retrieve(stunum: String?, username: String?, realName: String, cid: String, failure: ((Error)->())? = nil, success: @escaping ([String: Any])->()) {
        var parameters = [
            "real_name": realName,
            "cid": cid
        ]
        if stunum != nil {
            parameters["stunum"] = stunum!
        }
        if username != nil {
            parameters["username"] = username!
        }
        BBSBeacon.request(withType: .post, url: BBSAPI.retrieve, parameters: parameters, success: success)
    }
    
    static func resetPassword(password: String, failure: ((Error)->())? = nil, success: @escaping ([String: Any])->()) {
        let parameters = [
            "uid": String(BBSUser.shared.uid!),
            "token": BBSUser.shared.resetPasswordToken!,
            "password": password
        ]
        BBSBeacon.request(withType: .post, url: BBSAPI.resetPassword, parameters: parameters, success: success)
    }
    
    static func getFriendList(failure: ((Error)->())? = nil, success: @escaping ([UserWrapper])->()) {
        BBSBeacon.request(withType: .get, url: BBSAPI.friendList, parameters: nil) { dict in
            if let data = dict["data"] as? [[String : Any]] {
                let friends = Mapper<UserWrapper>().mapArray(JSONArray: data)
                success(friends)
            }
        }
    }
    
    static func getDialog(uid: Int, page: Int, failure: ((Error)->())? = nil, success: @escaping ([MessageModel])->()) {
        BBSBeacon.request(withType: .get, url: BBSAPI.dialog(uid: uid, page: page), parameters: nil) { dict in
            if let data = dict["data"] as? [[String : Any]] {
                let messages = Mapper<MessageModel>().mapArray(JSONArray: data)
                success(messages.reversed())
            }
        }
    }
    
    static func getImageAttachmentCode(image: UIImage, progressBlock: ((Progress)->())? = nil, failure: ((Error)->())? = nil, success: @escaping (Int)->()) {
        BBSBeacon.uploadImage(url: BBSAPI.attach, method: .post, image: image, progressBlock: progressBlock, failure: failure, success: { dic in
            if let data = dic["data"] as? [String : String], let code = data["id"] {
                success(Int(code)!)
            }
        })
    }
    
}

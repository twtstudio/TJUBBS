//
//  BBSBeacon.swift
//  TJUBBS
//
//  Created by Halcao on 2017/4/30.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

enum SessionType {
    case get
    case post
    case delete
    case put
}

struct BBSBeacon {
<<<<<<< HEAD
    static var authentication: String? {
        if let uid = BBSUser.shared.uid, let tokenStr = BBSUser.shared.token {
            return String(uid) + "|" + tokenStr
        } else {
            return nil
        }
    }

=======
    //TODO: change AnyObject to Any
>>>>>>> Usable ranklist in homepage
    static func request(withType type: HTTPMethod = .get, url: String, token: String? = nil, parameters: [String: String]?, failure: ((Error) -> Void)? = nil, success: (([String: Any]) -> Void)?) {
        var headers = HTTPHeaders()
        headers["User-Agent"] = DeviceStatus.userAgent
        headers["X-Requested-With"] = "Mobile"
        guard let authentication = authentication else {
            return
        }
        headers["authentication"] = authentication
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 7.0

        LoadingWrapper.shared.startTimer = Timer.scheduledTimer(timeInterval: 1.0, target: LoadingWrapper.shared, selector: #selector(LoadingWrapper.startLoading), userInfo: nil, repeats: false)
        LoadingWrapper.shared.stopTimer = Timer.scheduledTimer(timeInterval: 7.0, target: LoadingWrapper.shared, selector: #selector(LoadingWrapper.stopLoading), userInfo: nil, repeats: false)

        if type == .get || type == .post || type == .put {
            Alamofire.request(url, method: type, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString { response in
                HUD.hide()
                LoadingWrapper.shared.startTimer?.invalidate()
                LoadingWrapper.shared.stopTimer = nil
                LoadingWrapper.shared.stopTimer?.invalidate()
                LoadingWrapper.shared.startTimer = nil
                switch response.result {
                case .success:
<<<<<<< HEAD
                    guard let data = response.data else {
                        failure?(BBSError.custom("请求数据为空"))
                        return
                    }

                    guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
                        let errMsg = String(data: data, encoding: .utf8) ?? "JSON解析错误"
                        HUD.flash(.labeledError(title: errMsg, subtitle: nil), delay: 1.2)
                        failure?(BBSError.custom(errMsg))
                        return
                    }

                    guard let dict = json as? [String: Any],
                        let err = dict["err"] as? Int else {
                            failure?(BBSError.custom("JSON数据转换错误"))
                            return
                    }

                    guard err == 0 else {
                        // "1" : "无效的UID或token过期"
                        // "2" : "无效的token"
                        if err == 0 || err == 1 {
                            // TODO: present login controller
                            BBSUser.shared.token = nil
                            return
=======
                    if let data = response.data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                            if let dict = json as? [String: AnyObject] {
                                if let err = dict["err"] as? Int, err == 0 {
                                    success?(dict)
                                } else {
                                    if dict["data"] as? String == "无效的token" {
                                        BBSUser.shared.token = nil
//                                        HUD.flash(.labeledError(title: "登录过期😐 请重新登录", subtitle: nil), delay: 1.5)
                                    } else {
//                                        if BBSUser.shared.token != nil {
                                            HUD.flash(.label(dict["data"] as? String), delay: 1.2)
//                                        }
                                    }
                                    failure?(BBSError.custom)
                                }
                            }
                        } catch let error {
                            let errMsg = String(data: response.data!, encoding: .utf8)
                            HUD.flash(.labeledError(title: errMsg, subtitle: nil), delay: 1.2)
                            failure?(error)
                            // log.error(error)/
>>>>>>> Usable ranklist in homepage
                        }

                        if let msg = dict["data"] as? String {
                            // TODO: 整理一下 统一展示
                            HUD.flash(.label(msg), delay: 1.2)
                            failure?(BBSError.errorCode(err, msg))
                        } else {
                            failure?(BBSError.errorCode(err, "未知请求错误"))
                        }
                        return
                    }

                    success?(dict)
                case .failure(let error):
                    failure?(error)
                }
            }

        } else if type == .delete {
            Alamofire.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    if let data = response.result.value {
                        if let dict = data as? [String: Any], dict["err"] as? Int == 0 {
                            success?(dict)
                        } else {
                            HUD.hide()
                            HUD.flash(.label((data as? [String: Any])?["data"] as? String), delay: 1.0)
                        }
                    }
                case .failure(let error):
                    if let data = response.result.value {
                        if let dict = data as? [String: Any] {
<<<<<<< HEAD
                            //                            log.errorMessage(dict["data"] as? String)/
=======
//                            log.errorMessage(dict["data"] as? String)/
>>>>>>> Usable ranklist in homepage
                            HUD.hide()
                            HUD.flash(.label(dict["data"] as? String), delay: 1.0)
                        }
                    }
                    failure?(error)
                    //                    log.error(error)/
                }
            }
        }
    }

    static func requestImage(url: String, failure: ((Error) -> Void)? = nil, success: ((UIImage) -> Void)?) {
        //        Alamofire.request( , method:  , parameters:  , encoding:  , headers:  )
        var headers = HTTPHeaders()
        headers["User-Agent"] = DeviceStatus.userAgent

        guard let authentication = authentication else {
            return
        }
        headers["authentication"] = authentication

        Alamofire.request(url, method: .get, parameters: nil, headers: headers).responseData { response in
            switch response.result {
            case .success:
                if let data = response.data, let image = UIImage(data: data) {
                    success?(image)
                }
            case .failure(let error):
                failure?(error)
            }
        }
    }

    static func uploadImage(url: String, method: HTTPMethod = .put, image: UIImage, progressBlock: ((Progress) -> Void)? = nil, failure: ((Error) -> Void)? = nil, success: (([String: Any]) -> Void)?) {
        let data = UIImageJPEGRepresentation(image, 1.0)
        var headers = HTTPHeaders()
        headers["User-Agent"] = DeviceStatus.userAgent
        guard let authentication = authentication else {
            return
        }
        headers["authentication"] = authentication

        if method == .put {
            Alamofire.upload(multipartFormData: { formdata in
                formdata.append(data!, withName: "1", fileName: "avatar.jpeg", mimeType: "image/jpeg")
            }, to: url, method: .put, headers: headers, encodingCompletion: { response in
                switch response {
                case .success(let upload, _, _):
                    upload.responseJSON { _ in
                        success?([:])
                    }
                    upload.uploadProgress { progress in
                        progressBlock?(progress)
                    }
                case .failure(let error):
                    failure?(error)
                }
            })
        } else if method == .post {
            Alamofire.upload(multipartFormData: { formdata in
                formdata.append(data!, withName: "file", fileName: "image.jpeg", mimeType: "image/jpeg")
                formdata.append("filename".data(using: .utf8)!, withName: "name", mimeType: "text")
            }, to: url, method: .post, headers: headers, encodingCompletion: { response in
                switch response {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let dic = response.result.value as? [String: Any] {
                            if(dic["err"] as? Int) == 0 {
                                success?(dic)
                            } else {
                                HUD.flash(.label(dic["data"] as? String), delay: 1.0)
                            }
                        }
                    }
                    upload.uploadProgress { progress in
                        progressBlock?(progress)
                    }
                case .failure(let error):
                    failure?(error)
                }
            })
        }
    }
}

class LoadingWrapper: NSObject {
    var startTimer: Timer?
    var stopTimer: Timer?

    static let shared = LoadingWrapper()
    override init() {}
    func startLoading() {
        if startTimer != nil {
            let view = UIViewController.current?.view
            HUD.show(.rotatingImage(UIImage(named: "progress")), onView: view)
        }
    }
    func stopLoading() {
        HUD.hide()
    }
}

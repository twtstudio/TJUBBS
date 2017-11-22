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

enum BBSError: String, Error {
    case network = "网络错误"
    case custom = ""
}


struct BBSBeacon {
    //TODO: change AnyObject to Any
    static func request(withType type: HTTPMethod = .get, url: String, token: String? = nil, parameters: Dictionary<String, String>?, failure: ((Error)->())? = nil, success: ((Dictionary<String, Any>)->())?) {
        var headers = HTTPHeaders()
        headers["User-Agent"] = DeviceStatus.userAgent
        headers["X-Requested-With"] = "Mobile"
        if let uid = BBSUser.shared.uid, let tokenStr = BBSUser.shared.token {
            headers["authentication"] = String(uid) + "|" + tokenStr
        }
        
        // the next line absofuckinglutely sucks
//         let para = parameters ?? [:]
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 7.0
        
        FuckingWrapper.shared.startTimer = Timer.scheduledTimer(timeInterval: 1.0, target: FuckingWrapper.shared, selector: #selector(FuckingWrapper.startLoading), userInfo: nil, repeats: false)
        FuckingWrapper.shared.stopTimer = Timer.scheduledTimer(timeInterval: 7.0, target: FuckingWrapper.shared, selector: #selector(FuckingWrapper.stopLoading), userInfo: nil, repeats: false)
        
        if type == .get || type == .post || type == .put {
            Alamofire.request(url, method: type, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString { response in
                HUD.hide()
                FuckingWrapper.shared.startTimer?.invalidate()
                FuckingWrapper.shared.stopTimer = nil
                FuckingWrapper.shared.stopTimer?.invalidate()
                FuckingWrapper.shared.startTimer = nil
                switch response.result {
                case .success:
                    if let data = response.data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                            if let dict = json as? Dictionary<String, AnyObject> {
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
                        }
                    }
                case .failure(let error):
                    failure?(error)
                    // log.error(error)/
                }
            }
            
        } else if type == .delete {
            Alamofire.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    if let data = response.result.value  {
                        if let dict = data as? Dictionary<String, Any>, dict["err"] as? Int == 0 {
                            success?(dict)
                        } else {
                            HUD.hide()
                            HUD.flash(.label((data as? [String: Any])?["data"] as? String), delay: 1.0)
                        }
                    }
                case .failure(let error):
                    if let data = response.result.value  {
                        if let dict = data as? Dictionary<String, Any> {
//                            log.errorMessage(dict["data"] as? String)/
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
    
    static func requestImage(url: String, failure: ((Error)->())? = nil, success: ((UIImage)->())?) {
        //        Alamofire.request( , method:  , parameters:  , encoding:  , headers:  )
        var headers = HTTPHeaders()
        headers["User-Agent"] = DeviceStatus.userAgent
        guard let uid = BBSUser.shared.uid, let tokenStr = BBSUser.shared.token else {
//            log.errorMessage("Token expired!")/
            return
        }
        headers["authentication"] = String(uid) + "|" + tokenStr
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
    
    static func uploadImage(url: String, method: HTTPMethod = .put, image: UIImage, progressBlock: ((Progress)->())? = nil, failure: ((Error)->())? = nil, success: (([String : Any])->())?) {
        let data = UIImageJPEGRepresentation(image, 1.0)
        var headers = HTTPHeaders()
        headers["User-Agent"] = DeviceStatus.userAgent
        guard let uid = BBSUser.shared.uid, let tokenStr = BBSUser.shared.token else {
            return
        }
        headers["authentication"] = String(uid) + "|" + tokenStr
        
        if method == .put {
            Alamofire.upload(multipartFormData: { formdata in
                formdata.append(data!, withName: "1", fileName: "avatar.jpeg", mimeType: "image/jpeg")
            }, to: url, method: .put, headers: headers, encodingCompletion: { response in
                switch response {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        success?([:])
                    }
                    upload.uploadProgress { progress in
                        progressBlock?(progress)
//                        print(progress)
                    }
                case .failure(let error):
                    failure?(error)
                    print(error)
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
                        if let dic = response.result.value as? [String : Any] {
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
                    print(error)
                }
            })
        }
    }
}

class FuckingWrapper: NSObject {
    var startTimer: Timer?
    var stopTimer: Timer?
    
    static let shared = FuckingWrapper()
    override init() {}
    func startLoading() {
        if startTimer != nil {
            let view = UIViewController.current?.view
            HUD.show(.rotatingImage(UIImage(named: "progress")), onView: view)
//            HUD.show(.rotatingImage(UIImage(named: "progress")))
        }
    }
    func stopLoading() {
        HUD.hide()
    }
}

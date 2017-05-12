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

let rootURL = ""

struct BBSBeacon {
    //TODO: change AnyObject to Any
    static func request(withType type: HTTPMethod, url: String, token: String?, parameters: Dictionary<String, String>?, success: ((Dictionary<String, AnyObject>)->())?, failure: ((Error)->())?) {
        var headers = HTTPHeaders()
        headers["User-Agent"] = DeviceStatus.userAgentString()
        let para = parameters ?? [:]
        let fullURL = rootURL + url
        if type == .get || type == .post {
            Alamofire.request(fullURL, method: type, parameters: para, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    if let data = response.result.value  {
                        if let dict = data as? Dictionary<String, AnyObject>, dict["err"] as! Int == 0 {
                            success?(dict)
                        } else {
                            HUD.flash(.label((data as? [String: AnyObject])?["data"] as? String), delay: 1.0)
                        }
                    }
                case .failure(let error):
                    failure?(error)
                    log.error(error)/
                    if let data = response.result.value  {
                        if let dict = data as? Dictionary<String, AnyObject> {
                            log.errorMessage(dict["data"] as? String)/
                            HUD.flash(.label(dict["data"] as? String), delay: 1.0)
                        }
                    }
                }
            }
        } else if type == .put {
            guard let filePath = parameters?["filePath"] else {
                fatalError("参数里要有文件路径filePath!")
            }
//            Alamofire.upload(filePath, to: fullURL, method: .put, headers: headers)
//                .uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
//                    print("上传进度: \(progress.fractionCompleted)")
//                }
//                .validate { request, response, data in
//                    // 自定义的校验闭包, 现在加上了 `data` 参数(允许你提前转换数据以便在必要时挖掘到错误信息)
//                    return .success
//                }
//                .responseJSON { response in
//                    switch response.result {
//                    case .success:
//                        if let data = response.result.value  {
//                            if let dict = data as? Dictionary<String, AnyObject>, dict["error_code"] as! Int == 0 {
//                                success?(dict)
//                            }
//                        }
//                    case .failure(let error):
//                        failure?(error)
//                        log.error(error)/
//                        if let data = response.result.value  {
//                            if let dict = data as? Dictionary<String, AnyObject> {
//                                log.errorMessage(dict["message"] as! String)/
//                            }
//                        }
//                    }
//            }
        } else if type == .delete {
            Alamofire.request(fullURL, method: .delete, parameters: para, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    if let data = response.result.value  {
                        if let dict = data as? Dictionary<String, AnyObject>, dict["err"] as? Int == 0 {
                            success?(dict)
                        } else {
                            HUD.flash(.label((data as? [String: AnyObject])?["data"] as? String), delay: 1.0)
                        }
                    }
                case .failure(let error):
                    failure?(error)
                    log.error(error)/
                    if let data = response.result.value  {
                        if let dict = data as? Dictionary<String, AnyObject> {
                            log.errorMessage(dict["data"] as? String)/
                            HUD.flash(.label(dict["data"] as? String), delay: 1.0)
                        }
                    }
                }
            }
        }
    }
}

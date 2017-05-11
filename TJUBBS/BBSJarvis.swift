//
//  BBSJarvis.swift
//  TJUBBS
//
//  Created by Halcao on 2017/5/10.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

struct BBSJarvis {
    static func login(username: String, password: String, failure: ((Error)->())? = nil, success:@escaping ([String: AnyObject])->()) {
        let para: [String : String] = ["username": username, "password": password]
        BBSBeacon.request(withType: .post, url: BBSAPI.login, token: nil, parameters: para, success: success, failure: failure)
    }
    
    static func register(parameters: [String : String], failure: ((Error)->())? = nil, success:@escaping ([String: AnyObject])->()) {
    BBSBeacon.request(withType: .post, url: BBSAPI.register, token: BBSUser.shared.token, parameters: parameters, success: success, failure: failure)
    }
        
}

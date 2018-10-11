//
//  Variables.swift
//  TJUBBS
//
//  Created by 侯钦瀚 on 2018/7/17.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class Variables {
    public static var statusBarHeight: CGFloat {
        get {
            guard UIDevice.current.isX() else {
                return 20
            }
            return 44
        }
    }
    
    public static let navigationNormalHeight: CGFloat = 44
}



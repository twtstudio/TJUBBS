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
    
    public static let WIDTH = UIScreen.main.bounds.width
    public static let HEIGHT = UIScreen.main.bounds.height
    
    public static func setNavBarTitle(title: String) -> UILabel {
        let titleLabel = UILabel(text: title, color: .black, fontSize: 18, weight: UIFontWeightMedium)
        return titleLabel
    }
    
    public static var timeStamp: String {
        let now = Date()
        let dateFormatter = DateFormatter()
        let timeInterval: TimeInterval = now.timeIntervalSince1970
        let timeStr = String(timeInterval)
        return timeStr
    }
}

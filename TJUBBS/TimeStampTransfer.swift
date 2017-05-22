//
//  TimeStampTransfer.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/6.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import Foundation

struct TimeStampTransfer {
    
    static func string(from timeStampString: String, with format: String) -> String {
        let second = Int(timeStampString)
        let timeStamp = Date(timeIntervalSince1970: Double(second!))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC+8")
        return dateFormatter.string(from: timeStamp as Date)
    }
    
    static func days(since timeStamp: Int) -> String {
        let date = Date(timeIntervalSinceReferenceDate: Double(timeStamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: date)
    }
}

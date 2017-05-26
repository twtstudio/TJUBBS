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
    
    static func daysString(time: Int) -> String {
        let now = Date()
        let timeStamp = Int(now.timeIntervalSince1970)
        let day = Int((timeStamp-time)/86400)
        return String(day)
    }
    
    static func hoursString(time: Int) -> String {
        let now = Date()
        let timeStamp = Int(now.timeIntervalSince1970)
        let hour = Int((timeStamp-time)/3600)
        return String(hour)
    }
    
    static func minutesString(time: Int) -> String {
        let now = Date()
        let timeStamp = Int(now.timeIntervalSince1970)
        let minute = Int((timeStamp-time)/60)
        return String(minute)
    }
    
    static func timeLabelSince(time: Int) -> String {
        let now = Date()
        let timeStamp = Int(now.timeIntervalSince1970)
        if timeStamp-time > 86400*4 {
            return self.string(from: String(time), with: "yyyy-MM-dd")
        } else if timeStamp-time > 86400 {
            return self.daysString(time: time)
        } else if timeStamp-time > 43200 {
            return self.hoursString(time: time)
        } else {
            return self.minutesString(time: time)
        }
    }
}

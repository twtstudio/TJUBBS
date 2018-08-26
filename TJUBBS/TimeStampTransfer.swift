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

    static func daysSince(time: Int) -> String {
        let now = Date()
        let timeStamp = Int(now.timeIntervalSince1970)
        let day = Int((timeStamp-time)/86400)
        return String(day)
    }

    static func daysString(time: Int) -> String {
        let now = Date()
        let timeStamp = Int(now.timeIntervalSince1970)
        let day = Int((timeStamp-time)/86400)
        return String(day) + " 天前"
    }

    static func hoursString(time: Int) -> String {
        let now = Date()
        let timeStamp = Int(now.timeIntervalSince1970)
        let hour = Int((timeStamp-time)/3600)
        return String(hour) + " 小时前"
    }

    static func minutesString(time: Int) -> String {
        let now = Date()
        let timeStamp = Int(now.timeIntervalSince1970)
        let minute = Int((timeStamp-time)/60)
        return String(minute) + " 分钟前"
    }

    static func secondsString(time: Int) -> String {
        let now = Date()
        let timeStamp = Int(now.timeIntervalSince1970)
        let second = Int(timeStamp-time)
        return String(second) + " 秒前"
    }

    static func timeLabelSince(time: Int) -> String {
        let now = Date()
        let timeStamp = Int(now.timeIntervalSince1970)
        if timeStamp-time > 86400*4 {
            return self.string(from: String(time), with: "yyyy-MM-dd")
        } else if timeStamp-time > 86400 {
            return self.daysString(time: time)
        } else if timeStamp-time > 3600 {
            return self.hoursString(time: time)
        } else if timeStamp-time > 59 {
            return self.minutesString(time: time)
        } else if timeStamp-time > 10 {
            return self.secondsString(time: time)
        } else {
            return "刚刚"
        }
    }

    static func daysStringNewly(time: Int) -> String {
        let now = Date()
        let timeStamp = Int(now.timeIntervalSince1970)
        let day = Int((timeStamp-time)/86400)
        return String(day) + " 天前有新动态"
    }

    static func hoursStringNewly(time: Int) -> String {
        let now = Date()
        let timeStamp = Int(now.timeIntervalSince1970)
        let hour = Int((timeStamp-time)/3600)
        return String(hour) + " 小时前有新动态"
    }

    static func minutesStringNewly(time: Int) -> String {
        let now = Date()
        let timeStamp = Int(now.timeIntervalSince1970)
        let minute = Int((timeStamp-time)/60)
        return String(minute) + " 分钟前有新动态"
    }

    static func secondsStringNewly(time: Int) -> String {
        let now = Date()
        let timeStamp = Int(now.timeIntervalSince1970)
        let second = Int(timeStamp-time)
        return String(second) + " 秒前有新动态"
    }

    static func timeLabelSinceNewly(time: Int) -> String {
        let now = Date()
        let timeStamp = Int(now.timeIntervalSince1970)
        if timeStamp-time > 86400*4 {
            return self.string(from: String(time), with: "yyyy-MM-dd")
        } else if timeStamp-time > 86400 {
            return self.daysStringNewly(time: time)
        } else if timeStamp-time > 3600 {
            return self.hoursStringNewly(time: time)
        } else if timeStamp-time > 59 {
            return self.minutesStringNewly(time: time)
        } else if timeStamp-time > 10 {
            return self.secondsStringNewly(time: time)
        } else {
            return "刚刚有新动态"
        }
    }
}

//
//  DateTime.swift
//  LoopFollow
//
//  Created by Jon Fawcett on 6/16/20.
//  Copyright © 2020 Jon Fawcett. All rights reserved.
//

import Foundation


public class dateTimeUtils {
    
    static func getTimeIntervalMidnightToday() -> TimeInterval {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dayString = formatter.string(from: now)
        let midnight = dayString + " 00:00:00"
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        newFormatter.locale = Locale(identifier: "en_US")
        let newDate = newFormatter.date(from: midnight)
        guard let midnightTimeInterval = newDate?.timeIntervalSince1970 else { return 0 }
        return midnightTimeInterval
    }
    
    static func getTimeIntervalMidnightYesterday() -> TimeInterval {
        let now = Date().addingTimeInterval(-86400)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dayString = formatter.string(from: now)
        let midnight = dayString + " 00:00:00"
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        newFormatter.locale = Locale(identifier: "en_US")
        let newDate = newFormatter.date(from: midnight)
        guard let midnightTimeInterval = newDate?.timeIntervalSince1970 else { return 0 }
        return midnightTimeInterval
    }
    
    static func getTimeInterval24HoursAgo() -> TimeInterval {
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today) ?? Date()
        return yesterday.timeIntervalSince1970
    }
    
    static func getNowTimeIntervalUTC() -> TimeInterval {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let utc = formatter.string(from: now)
        let day = formatter.date(from: utc)
        guard let utcTime = day?.timeIntervalSince1970 else { return 0 }
        return utcTime
    }
    
    static func getOneWeekOldTimeIntervalUTC() -> TimeInterval {
        let today = Date()
        let now = Calendar.current.date(byAdding: .day, value: -7, to: today)  ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let utc = formatter.string(from: now)
        let day = formatter.date(from: utc)
        guard let utcTime = day?.timeIntervalSince1970 else { return 0 }
        return utcTime
    }
    
    static func nowMinus24HoursTimeInterval() -> String {
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)  ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        let yesterdayString = dateFormatter.string(from: yesterday)
        return yesterdayString
    }
    
    static func nowMinus10DaysTimeInterval() -> String {
        let today = Date()
        let oldDate = Calendar.current.date(byAdding: .day, value: -10, to: today)  ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        let dayString = dateFormatter.string(from: oldDate)
        return dayString
    }
    
    static func printNow() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date)
    }
    
    static func is24Hour() -> Bool {
        let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)  ?? ""

        return dateFormat.firstIndex(of: "a") == nil
    }
}

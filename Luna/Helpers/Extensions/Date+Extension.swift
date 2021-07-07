//
//  Date+Extension.swift
//  Luna
//
//  Created by Admin on 03/06/21.
//

import Foundation

extension Date {
    
    // MARK:- DATE FORMAT ENUM
    //==========================
    enum DateFormat : String {
        
        case yyyy_MM_dd = "yyyy-MM-dd"
        case dd_MM_yyyy = "dd-MM-yyyy"
        case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
        case givenDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        yyyy-MM-dd'T'HH:mm:ss.SSSZ
        case yyyyMMddTHHmmssz = "yyyy-MM-dd'T'HH:mm:ssZ"
        case yyyyMMddTHHmmsssssz = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        case yyyyMMddTHHmmssssZZZZZ = "yyyy-MM-dd'T'HH:mm:ss.ssZZZZZ"
        case yyyyMMdd = "yyyy/MM/dd"
        case mmddyyyy = "MM/dd/yyyy"
        case dMMMyyyy = "d MMM, yyyy"
        case ddMMMyyyy = "dd MMM yyyy"
        case MMMdyyyy = "MMM d, yyyy"
        case hmmazzz = "h:mm a zzz"
        case HHmmss = "hh:mm:ss"
        case hhmma = "hh:mm a"
        case mmddyy = "m/dd/yy, hh:mm a"
        case profileFormat = "dd MMM, yyyy"
        case mmmmyy = "MMMM'' yy"
        case mmmmyyy = "MMMM yyy"
        case hour12 = "h:mm a"
        case hour24 = "HH:mm"
    }

    var daySuffix : String {
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: self)
        switch dayOfMonth {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "th"
        }
    }
    
    static let dateFormatter = DateFormatter()

    var isToday:Bool{
        return Calendar.current.isDateInToday(self)
    }
    var isYesterday:Bool{
        return Calendar.current.isDateInYesterday(self)
    }
    var isTomorrow:Bool{
        return Calendar.current.isDateInTomorrow(self)
    }
    var isWeekend:Bool{
        return Calendar.current.isDateInWeekend(self)
    }
    var year:Int{
        return (Calendar.current as NSCalendar).components(.year, from: self).year!
    }
    var month:Int{
        return (Calendar.current as NSCalendar).components(.month, from: self).month!
    }
    var weekOfYear:Int{
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: self).weekOfYear!
    }
    var weekday:Int{
        return (Calendar.current as NSCalendar).components(.weekday, from: self).weekday!
    }
    var weekdayOrdinal:Int{
        return (Calendar.current as NSCalendar).components(.weekdayOrdinal, from: self).weekdayOrdinal!
    }
    var weekOfMonth:Int{
        return (Calendar.current as NSCalendar).components(.weekOfMonth, from: self).weekOfMonth!
    }
    var day:Int{
        return (Calendar.current as NSCalendar).components(.day, from: self).day!
    }
    var hour:Int{
        return (Calendar.current as NSCalendar).components(.hour, from: self).hour!
    }
    var minute:Int{
        return (Calendar.current as NSCalendar).components(.minute, from: self).minute!
    }
    var second:Int{
        return (Calendar.current as NSCalendar).components(.second, from: self).second!
    }
    var numberOfWeeks:Int{
        let weekRange = (Calendar.current as NSCalendar).range(of: .weekOfYear, in: .month, for: Date())
        return weekRange.length
    }
    var unixTimestamp:Double {
        
        return self.timeIntervalSince1970
    }
    
    func yearsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.year, from: date, to: self, options: []).year!
    }
    func monthsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: []).month!
    }
    func weeksFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear!
    }
    func weekdayFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.weekday, from: date, to: self, options: []).weekday!
    }
    func weekdayOrdinalFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.weekdayOrdinal, from: date, to: self, options: []).weekdayOrdinal!
    }
    func weekOfMonthFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.weekOfMonth, from: date, to: self, options: []).weekOfMonth!
    }
    func daysFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day!
    }
    func hoursFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour!
    }
    func minutesFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute!
    }
    func secondsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second!
    }
    func offsetFrom(_ date:Date) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date) )y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
    
    ///Converts a given Date into String based on the date format and timezone provided
    func toString(dateFormat:String,timeZone:TimeZone = TimeZone.current)->String{
        
        let frmtr = DateFormatter()
//        frmtr.locale = Locale(identifier: "en_US_POSIX")
        frmtr.dateFormat = dateFormat
        frmtr.timeZone = timeZone
        return frmtr.string(from: self)
    }
    
    func convertYearsToString() -> String {
        let frmtr = DateFormatter()
        frmtr.locale = Locale(identifier: "en_US_POSIX")
        frmtr.dateFormat = DateFormat.yyyyMMdd.rawValue
        frmtr.timeZone = TimeZone.current
        return frmtr.string(from: self)
    }
    
    func calculateAge() -> Int {
        
        let calendar : Calendar = Calendar.current
        let unitFlags : NSCalendar.Unit = [NSCalendar.Unit.year , NSCalendar.Unit.month , NSCalendar.Unit.day]
        let dateComponentNow : DateComponents = (calendar as NSCalendar).components(unitFlags, from: Date())
        let dateComponentBirth : DateComponents = (calendar as NSCalendar).components(unitFlags, from: self)
        
        if ( (dateComponentNow.month! < dateComponentBirth.month!) ||
            ((dateComponentNow.month! == dateComponentBirth.month!) && (dateComponentNow.day! < dateComponentBirth.day!))
            )
        {
            return dateComponentNow.year! - dateComponentBirth.year! - 1
        }
        else {
            return dateComponentNow.year! - dateComponentBirth.year!
        }
    }
    
    static func zero() -> Date {
        let dateComp = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: 0, year: 0, month: 0, day: 0, hour: 0, minute: 0, second: 0, nanosecond: 0, weekday: 0, weekdayOrdinal: 0, quarter: 0, weekOfMonth: 0, weekOfYear: 0, yearForWeekOfYear: 0)
        return dateComp.date!
    }
    
    func convertToDefaultString() -> String {
        // First, get a Date from the String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.mmddyyyy.rawValue
        let local = dateFormatter.string(from: self)
        return local
    }
    
     func convertToString(inputFormat: DateFormat, outputFormat: DateFormat) -> String {
            // First, get a Date from the String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = inputFormat.rawValue

            // Now, get a new string from the Date in the proper format for the user's locale
            dateFormatter.dateFormat = outputFormat.rawValue
    //        dateFormatter.dateStyle = .long // set as desired
    //        dateFormatter.timeStyle = .medium // set as desired
            let local = dateFormatter.string(from: self)
            return local
        }
    
    func convertToNormalDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.DateFormat.dd_MM_yyyy.rawValue
        let local = dateFormatter.string(from: self)
        return local
    }
    
    var timeAgoSince : String {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: self, to: now, options: [])
        
        if let year = components.year, year >= 2 {
            return "\(year) years ago"
        }
        
        if let year = components.year, year >= 1 {
            return LocalizedString.lastYear.localized
        }
        
        if let month = components.month, month >= 2 {
            return "\(month) " + LocalizedString.monthsAgo.localized
        }
        
        if let month = components.month, month >= 1 {
            return LocalizedString.lastMonth.localized
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week) " + LocalizedString.weeksAgo.localized
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return LocalizedString.lastWeek.localized
        }
        
        if let day = components.day, day >= 2 {
            return "\(day) " + LocalizedString.daysAgo.localized
        }
        
        if let day = components.day, day >= 1 {
            return LocalizedString.yesterday.localized
        }
       
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour) " + LocalizedString.hoursAgo.localized
        }
        
        if let hour = components.hour, hour >= 1 {
            return LocalizedString.oneHourAgo.localized
        }
        
        if let minute = components.minute, minute >= 2 {
        return "\(minute) " + LocalizedString.minutesAgo.localized
        }
        
        if let minute = components.minute, minute >= 1 {
        return LocalizedString.oneMinuteAgo.localized
        }
        
        if let second = components.second, second >= 3 {
            return "\(second) " + LocalizedString.secondsAgo.localized
        }
        
        return LocalizedString.justNow.localized
    }
}


public extension Date {
    
    public func plus(seconds s: UInt) -> Date {
        return self.addComponentsToDate(seconds: Int(s), minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func minus(seconds s: UInt) -> Date {
        return self.addComponentsToDate(seconds: -Int(s), minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func plus(minutes m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: Int(m), hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func minus(minutes m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: -Int(m), hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func plus(hours h: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: Int(h), days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func minus(hours h: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: -Int(h), days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func plus(days d: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: Int(d), weeks: 0, months: 0, years: 0)
    }
    
    public func minus(days d: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: -Int(d), weeks: 0, months: 0, years: 0)
    }
    
    public func plus(weeks w: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: Int(w), months: 0, years: 0)
    }
    
    public func minus(weeks w: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: -Int(w), months: 0, years: 0)
    }
    
    public func plus(months m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: Int(m), years: 0)
    }
    
    public func minus(months m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: -Int(m), years: 0)
    }
    
    public func plus(years y: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: Int(y))
    }
    
    public func minus(years y: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: -Int(y))
    }
    
    fileprivate func addComponentsToDate(seconds sec: Int, minutes min: Int, hours hrs: Int, days d: Int, weeks wks: Int, months mts: Int, years yrs: Int) -> Date {
        var dc = DateComponents()
        dc.second = sec
        dc.minute = min
        dc.hour = hrs
        dc.day = d
        dc.weekOfYear = wks
        dc.month = mts
        dc.year = yrs
        return Calendar.current.date(byAdding: dc, to: self)!
    }
    
    func midnightUTCDate() -> Date {
        var dc: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
        dc.hour = 0
        dc.minute = 0
        dc.second = 0
        dc.nanosecond = 0
        dc.timeZone = TimeZone(secondsFromGMT: 0)
        return Calendar.current.date(from: dc)!
    }
    
    public static func secondsBetween(date1 d1:Date, date2 d2:Date) -> Int {
        let dc = Calendar.current.dateComponents([.second], from: d1, to: d2)
        return dc.second!
    }
    
    public static func minutesBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.minute], from: d1, to: d2)
        return dc.minute!
    }
    
    public static func hoursBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.hour], from: d1, to: d2)
        return dc.hour!
    }
    
    public static func daysBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.day], from: d1, to: d2)
        return dc.day!
    }
    
    public static func weeksBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.weekOfYear], from: d1, to: d2)
        return dc.weekOfYear!
    }
    
    public static func monthsBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.month], from: d1, to: d2)
        return dc.month!
    }
    
    public static func yearsBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.year], from: d1, to: d2)
        return dc.year!
    }
    
    //MARK- Comparison Methods
    
    public func isGreaterThan(_ date: Date) -> Bool {
        return (self.compare(date) == .orderedDescending)
    }
    
    public func isLessThan(_ date: Date) -> Bool {
        return (self.compare(date) == .orderedAscending)
    }
    
}


// The date components available to be retrieved or modifed
public enum DateComponentType {
    case second, minute, hour, day, weekday, nthWeekday, week, month, year
}

extension Calendar{
    static let gregorian = Calendar(identifier: .gregorian)
}

extension Date {
    
    public func toMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    public init(millis: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(millis / 1000))
        self.addTimeInterval(TimeInterval(Double(millis % 1000) / 1000 ))
    }
    
    func convertTo12HrsTime() -> Date {
        let date = self.toString(dateFormat: Date.DateFormat.yyyyMMddHHmmss.rawValue, timeZone: TimeZone.current)
        let local = date.toDate(dateFormat: Date.DateFormat.hhmma.rawValue, timeZone: TimeZone.current)
        return local ?? Date()
    }
    
    func createMidNightTimeStampForDate(value: Date) -> Date {
        var dc = DateComponents()
        dc.second = 00
        dc.minute = 59
        dc.hour = 23
        dc.day = value.day
        dc.weekOfYear = value.weekOfYear
        dc.month = value.month
        dc.year = value.year
        return Calendar.current.date(from: dc)!
    }
    
    func adjustedDate(_ component:DateComponentType, offset:Int) -> Date {
        var dateComp = DateComponents()
        switch component {
        case .second:
            dateComp.second = offset
        case .minute:
            dateComp.minute = offset
        case .hour:
            dateComp.hour = offset
        case .day:
            dateComp.day = offset
        case .weekday:
            dateComp.weekday = offset
        case .nthWeekday:
            dateComp.weekdayOrdinal = offset
        case .week:
            dateComp.weekOfYear = offset
        case .month:
            dateComp.month = offset
        case .year:
            dateComp.year = offset
        }
        return Calendar.current.date(byAdding: dateComp, to: self)!
    }
    
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
  
    var iso8601withFractionalSeconds: String {
        return Formatter.iso8601withFractionalSeconds.string(from: self)
    }
    
}

extension Int64 {
    var stringValue : String {
        return String(self)
    }
    
    func convertMillisecondsToTime() -> String {
        let timeStamp = self / 1000
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.DateFormat.hhmma.rawValue
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
}

extension ISO8601DateFormatter {
   
    convenience init(_ formatOptions: Options, timeZone: TimeZone = .current) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}

extension Formatter {
    static let iso8601 = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var startOfMonth: Date {

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)

        return  calendar.date(from: components)!
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }

    func isMonday() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 2
    }
}

extension Date {

    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    func getSecondFromTwoDate(fromDate: Date,toDate: Date) -> Int{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second]
        formatter.unitsStyle = .full
        let difference = formatter.string(from: fromDate, to: toDate)
        let splitSecond = difference?.split(separator: " ")
        return Int((splitSecond?.first as! NSString).intValue)
    }
    
    func convertToTimeString() -> String {
        // First, get a Date from the String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.hhmma.rawValue
        
        //        // Now, get a new string from the Date in the proper format for the user's locale
        //        dateFormatter.dateFormat = nil
        //        dateFormatter.dateStyle = .long // set as desired
        //        dateFormatter.timeStyle = .medium // set as desired
        let local = dateFormatter.string(from: self)
        return local
    }
}

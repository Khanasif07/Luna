//
//  Double+Extension.swift
//  Luna
//
//  Created by Admin on 03/06/21.
//

import Foundation

extension Double {
    var stringValue : String {
        return "\(self)"
    }
    
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
    
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
    
    func nextMultiple(of num: Double)-> Double {
        guard self.remainder(dividingBy: num) != 0 else { return self }
        return num * Double(Int(self/num) + 1)
    }
    
    func previousMultiple(of num: Double)-> Double {
        return self - abs(self.remainder(dividingBy: num))
    }
    
    public func getDateTimeFromTimeInterval(_ dateFormat: String)-> String{
        //Convert to Date
        //let date = NSDate(timeIntervalSince1970: self / 1000.0)
        let date = NSDate(timeIntervalSince1970: TimeInterval(self))
        //Date formatting
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd, MMMM yyyy HH:mm:a"
//        dateFormatter.dateFormat = "hh a"
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.current
        //dateFormatter.timeZone = TimeZone.current
        let dateString = dateFormatter.string(from: date as Date)
//        print("formatted date is =  \(dateString)")
        return dateString.lowercased()
       
    }
    
    public func getDateFromTimeInterval()-> Date{
        //Convert to Date
        //let date = NSDate(timeIntervalSince1970: self / 1000.0)
        let date = NSDate(timeIntervalSince1970: TimeInterval(self))
        //Date formattin
        return date as Date
    }
    
    public func getChatDateTimeFromTimeInterval(_ dateFormat: String)-> String{
        //Convert to Date
        //let date = NSDate(timeIntervalSince1970: self / 1000.0)
        let nsDate = NSDate(timeIntervalSince1970: TimeInterval(self))
        //Date formatting
        let date = nsDate as Date
        return date.timeAgoSince
       
    }
    
    public func getMonthInterval(_ dateFormat: String = "hh a")-> String{
        //Convert to Date
        //let date = NSDate(timeIntervalSince1970: self / 1000.0)
        let date = NSDate(timeIntervalSince1970: TimeInterval(self))
        return "\((Calendar.current as NSCalendar).components(.month, from: date as Date).month!)"
    }
}

extension Int {
    var stringValue : String {
        return "\(self)"
    }
}

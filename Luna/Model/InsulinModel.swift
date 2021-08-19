//
//  InsulinModel.swift
//  Luna
//
//  Created by Admin on 10/08/21.
//

import Foundation
/// id: minutes from sensor start
struct InsulinModel: Identifiable, Codable {
    let id: Int
    let date: Date
    var value: Int = 0
    var source: String = "Luna"

    init(raw: Int, id: Int = 0, date: Date = Date(),source: String = "DiaBLE") {
        self.id = id
        self.date = date
        self.value = raw / 10
        self.source = source
    }
    
    init(_ value: Int, id: Int = 0, date: Date = Date(), source: String = "DiaBLE") {
        self.init(raw: value * 10, id: id, date: date)
        self.source = source
    }
}

extension Double {
    
    public func getDateTimeFromTimeInterval()-> String{
        //Convert to Date
        //let date = NSDate(timeIntervalSince1970: self / 1000.0)
        let date = NSDate(timeIntervalSince1970: TimeInterval(self))
        //Date formatting
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd, MMMM yyyy HH:mm:a"
        dateFormatter.dateFormat = "hh a"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        //dateFormatter.timeZone = TimeZone.current
        let dateString = dateFormatter.string(from: date as Date)
//        print("formatted date is =  \(dateString)")
        return dateString.lowercased()
       
    }
}


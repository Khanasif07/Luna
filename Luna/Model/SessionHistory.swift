//
//  SessionHistory.swift
//  Luna
//
//  Created by Admin on 05/10/21.
//

import Foundation

struct SessionHistory :Codable{
    var sessionId: String?
    var endDate: Double = 0.0
    var startDate: Double = 0.0
    var range: Double = 0.0
    var insulin: Double = 0
    var title: String{
        if  "\(startDate.getDateTimeFromTimeInterval(Date.DateFormat.mmdd.rawValue))" == "\(endDate.getDateTimeFromTimeInterval(Date.DateFormat.mmdd.rawValue))"{
            return "\(startDate.getDateTimeFromTimeInterval(Date.DateFormat.mmdd.rawValue))"
        }else{
            return  "\(startDate.getDateTimeFromTimeInterval(Date.DateFormat.mmdd.rawValue)) " + "-" + " \(endDate.getDateTimeFromTimeInterval(Date.DateFormat.mmdd.rawValue))"
        }
    }
    var actualInsulin: String{
        return (Double(insulin) / 2).roundToDecimal(1).stringValue
    }
    
    init(){
    }
    
    init (dict: JSONDictionary){
        self.startDate = dict[ApiKey.startDate] as? Double ?? 0.0
        self.endDate = dict[ApiKey.endDate] as? Double ?? 0.0
        self.range = dict[ApiKey.range] as? Double ?? 0.0
        self.insulin = dict[ApiKey.insulin] as? Double ?? 0.0
        self.sessionId = dict[ApiKey.sessionId] as? String ?? ""
    }
   
}

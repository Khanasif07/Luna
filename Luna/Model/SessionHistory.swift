//
//  SessionHistory.swift
//  Luna
//
//  Created by Admin on 05/10/21.
//

import Foundation

struct SessionHistory :Codable{
    
    var date: Double = 0.0
    var endDate: Double = 0.0
    var startDate: Double = 0.0
    var range: Double = 0.0
    var insulin: Double = 0
    
    init(){
    }
    
    init (dict: JSONDictionary){
        self.date = dict[ApiKey.date] as? Double ?? 0.0
        self.startDate = dict[ApiKey.startDate] as? Double ?? 0.0
        self.endDate = dict[ApiKey.endDate] as? Double ?? 0.0
        self.range = dict[ApiKey.range] as? Double ?? 0.0
        self.insulin = dict[ApiKey.insulin] as? Double ?? 0.0
    }
   
}

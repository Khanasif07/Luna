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
    var insulin: Int = 0
    
    init(){
    }
    
    init (dict: JSONDictionary){
        self.date = dict[ApiKey._id] as? Double ?? 0.0
        self.startDate = dict[ApiKey.authToken] as? Double ?? 0.0
        self.endDate = dict[ApiKey.createdAt] as? Double ?? 0.0
        self.range = dict[ApiKey.email] as? Double ?? 0.0
        self.insulin = dict[ApiKey.emailVerified] as? Int ?? 0
    }
   
}

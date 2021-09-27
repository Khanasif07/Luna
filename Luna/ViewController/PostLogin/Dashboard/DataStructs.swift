//
//  DataStructs.swift
//  Luna
//
//  Created by Admin on 21/09/21.
//

import Foundation

class DataStructs {
    
    // Pie Chart Data
    struct pieData: Codable {
        var name: String
        var value: Double
    }
    
    //NS Basal Profile  Struct
    struct basal2DayProfile: Codable {
        var basalRate: Double
        var startDate: TimeInterval
        var endDate: TimeInterval
    }
    
    //NS Timestamp Only Data  Struct
    struct timestampOnlyStruct: Codable {
        var date: TimeInterval
        var sgv: Int
    }
    
    //NS Note Data  Struct
    struct noteStruct: Codable {
        var date: TimeInterval
        var sgv: Int
        var note: String
    }
    
    //NS Override Data  Struct
    struct overrideStruct: Codable {
        var insulNeedsScaleFactor: Double
        var date: TimeInterval
        var endDate: TimeInterval
        var duration: Double
        var correctionRange: [Int]
        var enteredBy: String
        var reason: String
        var sgv: Float
    }
    
}

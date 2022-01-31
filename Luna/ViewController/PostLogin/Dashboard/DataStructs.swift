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
}

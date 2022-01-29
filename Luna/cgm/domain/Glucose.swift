//
//  Glucose.swift
//  Luna
//
//  Created by Francis Pascual on 1/29/22.
//

import Foundation

enum Trend : String, CaseIterable, Identifiable {
    case unknown = "Unknown"
    case none = "None"
    case doubleUp = "DoubleUp"
    case singleUp = "SingleUp"
    case fortyFiveUp = "FortyFiveUp"
    case flat = "Flat"
    case fortyFiveDown = "FortyFiveDown"
    case singleDown = "SingleDown"
    case doubleDown = "DoubleDown"
    
    var id: Trend { self }
}

struct Glucose: Identifiable {
    let id: String
    let time: Date
    let egv: Double
    let trend: Trend
    let trendRate: Double?
    
    static let CREATE_ID = ""
}

struct Record<T : Identifiable> {
    var id: T.ID { value.id }
    let value: T
    let sourceId: String
    let sourceType: String
    let sourceEntityId: String?
    let receiveTime: Date
    let timeZone: TimeZone
}

struct ReceiveTimeRecord<T> {
    let value: T
    let receiveTime: Date
    
    init(_ value: T, receiveTime: Date) {
        self.value = value
        self.receiveTime = receiveTime
    }
}


extension Glucose {
    static var previewDate: Date = Date()
    static var previews: [Glucose] {
        return [
            Glucose(id: UUID().uuidString, time: previewDate.advanced(by: -(60.0*60.0*2)), egv: 150.0, trend: .flat, trendRate: 0.0),
            Glucose(id: UUID().uuidString, time: previewDate.advanced(by: -300.0), egv: 130.0, trend: .flat, trendRate: 0.0),
            Glucose(id: UUID().uuidString, time: previewDate, egv: 120.0, trend: .flat, trendRate: 0.0)
        ]
    }
    
    static var allTrends: [Glucose] {
        return Trend.allCases.map { trend in
            Glucose(id: UUID().uuidString, time: previewDate, egv: 120.0, trend: trend, trendRate: 0.0)
        }
    }
}

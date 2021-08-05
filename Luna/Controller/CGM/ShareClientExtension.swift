//
//  ShareClientExtension.swift
//  LoopFollow
//
//  Created by Jose Paredes on 7/13/20.
//  Copyright © 2020 Jon Fawcett. All rights reserved.
//

import Foundation

public struct ShareGlucoseData: Codable {
   var sgv: Int
   var date: TimeInterval
   var direction: String?
}

private var TrendTable: [String] = [
   "NONE",             // 0
   "DoubleUp",         // 1
   "SingleUp",         // 2
   "FortyFiveUp",      // 3
   "Flat",             // 4
   "FortyFiveDown",    // 5
   "SingleDown",       // 6
   "DoubleDown",       // 7
   "NOT COMPUTABLE",   // 8
   "RATE OUT OF RANGE" // 9
]

public struct globalVariables {
    static var debugLog = ""
    
    static var dexVerifiedAlert: TimeInterval = 0
    static var nsVerifiedAlert: TimeInterval = 0
    
    // Graph Settings
    static let dotBG: Float = 3
    static let dotCarb: Float = 5
    static let dotBolus: Float = 5
    static let dotOther: Float = 5
    
    
}

public class bgUnits {
    
    static func toDisplayUnits(_ value: String) -> String {
        if UserDefaultsRepository.units.value == "mg/dL" {
            return removeDecimals(value)
        } else {
            // convert mg/dL to mmol/l
            let floatValue : Float = Float(value)! * 0.0555
            //TODO - Aanchal
            return ""//String(floatValue.cleanValue)
        }
    }
    
    // if a "." is contained, simply takes the left part of the string only
    static func removeDecimals(_ value : String) -> String {
        if !value.contains(".") {
            return value
        }
        
        return String(value[..<value.firstIndex(of: ".")!])
    }
    
    static func removePeriodForBadge(_ value: String) -> String {
        return value.replacingOccurrences(of: ".", with: "")
    }
}

// TODO: probably better to make this an inherited class rather than an extension
extension ShareClient {

    public func fetchData(_ entries: Int, callback: @escaping (ShareError?, [ShareGlucoseData]?) -> Void) {
        
        self.fetchLast(entries) { (error, result) -> () in
            guard error == nil || result != nil else {
                return callback(error, nil)
            }
            
            // parse data to conanical form
            var shareData = [ShareGlucoseData]()
            for i in 0..<result!.count {
                
                var trend = Int(result![i].trend)
                if(trend < 0 || trend > TrendTable.count-1) {
                    trend = 0
                }
            
                let newShareData = ShareGlucoseData(
                    sgv: Int(result![i].glucose),
                    date: result![i].timestamp.timeIntervalSince1970,
                    direction: TrendTable[trend]
                )
                shareData.append(newShareData)
            }
            callback(nil,shareData)
         }
    }
}
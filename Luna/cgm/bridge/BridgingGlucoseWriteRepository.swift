//
//  BridgingGlucoseWriteRepository.swift
//  Luna
//
//  Created by Francis Pascual on 1/30/22.
//

import Foundation

class BridgingGlucoseWriteRepository : GlucoseWriteRepository {
    func writeGlucose(records: [Record<Glucose, GlucoseSource>]) async throws {
        print("Received records to write: \(records)")
        
        let cgmData = records.map { record in record.value.toShareGlucoseData() }
        
        DispatchQueue.main.async {
            if var original = SystemInfoModel.shared.cgmData {
                original.append(contentsOf: cgmData)
                SystemInfoModel.shared.cgmData = original
            } else {
                SystemInfoModel.shared.cgmData = cgmData
            }
            
            NotificationCenter.default.post(name: Notification.Name.cgmSimData, object: [ApiKey.cgmData: cgmData])
        }
    }
    
    func deleteAllGlucose(sourceId: String) async throws {
    }
}

private extension Glucose {
    func toShareGlucoseData() -> ShareGlucoseData {
        let direction: String
        switch(self.trend) {
        case .unknown:
            direction = "None"
        case .none:
            direction = "None"
        case .doubleUp:
            direction = "DoubleUp"
        case .singleUp:
            direction = "SingleUp"
        case .fortyFiveUp:
            direction = "FortyFiveUp"
        case .flat:
            direction = "Flat"
        case .fortyFiveDown:
            direction = "FortyFiveDown"
        case .singleDown:
            direction = "SingleDown"
        case .doubleDown:
            direction = "DoubleDown"
        }
        
        return ShareGlucoseData(sgv: Int(self.egv), date: self.time.timeIntervalSince1970, direction: direction)
    }
}

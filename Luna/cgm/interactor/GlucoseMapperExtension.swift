//
//  BleSimulatorGlucoseExtension.swift
//  Luna
//
//  Created by Francis Pascual on 1/30/22.
//

import LunaBluetooth

private let isoFormatter : ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withFullDate,
                               .withTime,
                               .withDashSeparatorInDate,
                               .withColonSeparatorInTime,
                               .withTimeZone]
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}()


extension BleSimulatorGlucose {

    func toGlucose() -> Glucose {
        let id = Glucose.CREATE_ID
        return Glucose(id: id, time: self.time, egv: self.egv, trend: self.trend.toTrend(), trendRate: nil)
    }
    
    var entityId: String {
        let dateString = isoFormatter.string(from: self.time)
        return "\(dateString)_\(egv)"
    }
}

extension BleSimulatorTrend {
    func toTrend() -> Trend {
        switch(self) {
        case .unknown:
            return .unknown
        case .none:
            return .none
        case .doubleUp:
            return .doubleUp
        case .singleUp:
            return .singleUp
        case .fortyFiveUp:
            return .fortyFiveUp
        case .flat:
            return .flat
        case .fortyFiveDown:
            return .fortyFiveDown
        case .singleDown:
            return .singleDown
        case .doubleDown:
            return .doubleDown
        }
    }
}

//
//  GlucoseFormatter.swift
//  Luna
//
//  Created by Francis Pascual on 1/29/22.
//

import Foundation

class GlucoseFormatter {
    let mgdlFormatter = NumberFormatter()
    
    init() {
        mgdlFormatter.positiveFormat = "0"
        mgdlFormatter.negativeFormat = "0"
    }
    
    func string(mgdl value: Double) -> String {
        return mgdlFormatter.string(from: NSNumber(value: value))!
    }
}

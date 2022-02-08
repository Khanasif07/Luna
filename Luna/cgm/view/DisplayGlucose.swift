//
//  DisplayGlucose.swift
//  Luna
//
//  Created by Francis Pascual on 1/29/22.
//

import Foundation

protocol DisplayGlucose {
    var id: String { get }
    var egv: Double { get }
    var time: Date { get }
    var trend: Trend { get }
}

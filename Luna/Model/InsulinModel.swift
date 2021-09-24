//
//  InsulinModel.swift
//  Luna
//
//  Created by Admin on 10/08/21.
//

import Foundation
struct InsulinModel: Identifiable, Codable {
    let id: Int
    let date: Date
    var value: Int = 0
    var source: String = "Luna"

    init(raw: Int, id: Int = 0, date: Date = Date(),source: String = "DiaBLE") {
        self.id = id
        self.date = date
        self.value = raw / 10
        self.source = source
    }
    
    init(_ value: Int, id: Int = 0, date: Date = Date(), source: String = "DiaBLE") {
        self.init(raw: value * 10, id: id, date: date)
        self.source = source
    }
}

//
//  PairingError.swift
//  Luna
//
//  Created by Francis Pascual on 1/30/22.
//

import Foundation

enum CgmError : Error {
    case invalidState
    case connectError(_ message: String)
}

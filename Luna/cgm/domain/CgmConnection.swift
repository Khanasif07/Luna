//
//  CgmConnection.swift
//  Luna
//
//  Created by Francis Pascual on 1/26/22.
//

import Foundation

enum CgmConnection {
    case dexcomG6(credentialId: String)
    case dexcomG7
    case freestyleLibre2
    case freestyleLibre3
    case lunaSimulator(deviceId: UUID, deviceName: String)
}

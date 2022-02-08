//
//  UICgmExtensions.swift
//  Luna
//
//  Created by Francis Pascual on 1/26/22.
//

import Foundation

extension CgmConnection {
    var localizedString: LocalizedString {
        switch(self) {
        case .dexcomG6:
            return .dexcomG6
        case .dexcomG7:
            return .dexcomG7
        case .freestyleLibre2:
            return .freestyle_Libre2
        case .freestyleLibre3:
            return .freestyle_Libre3
        case .lunaSimulator:
            return .lunaSimulator
        }
    }
}

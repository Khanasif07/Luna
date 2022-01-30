//
//  CgmService.swift
//  Luna
//
//  Created by Francis Pascual on 1/30/22.
//

import Foundation
import Combine
import LunaBluetooth

class CgmService {
    private let cgmRepository: CgmRepository
    let lunaCgmSimulator = LunaCgmSimulatorService()
    
    init(cgmRepository: CgmRepository) {
        self.cgmRepository = cgmRepository
    }
    
    func load() async throws {
        guard let cgmConnection = try await cgmRepository.getCgmConnection() else { return }
        
        switch(cgmConnection) {
        case .dexcomG6(_):
            // TODO: Not handled yet
            break
        case .dexcomG7:
            break
        case .freestyleLibre2:
            break
        case .freestyleLibre3:
            break
        case .lunaSimulator(let deviceId, _):
            lunaCgmSimulator.restore(deviceId: deviceId)
        }
    }
}

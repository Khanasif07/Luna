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
    private let glucoseRepository: GlucoseWriteRepository
    let lunaCgmSimulator: LunaCgmSimulatorService
    private let queue = DispatchQueue(label: "CgmService")
    
    init(cgmRepository: CgmRepository, glucoseRepository: GlucoseWriteRepository) {
        self.cgmRepository = cgmRepository
        self.glucoseRepository = glucoseRepository
        self.lunaCgmSimulator = LunaCgmSimulatorService(glucoseRepository: glucoseRepository, queue: queue)
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

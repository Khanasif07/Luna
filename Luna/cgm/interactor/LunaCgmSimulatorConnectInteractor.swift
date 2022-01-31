//
//  LunaCgmSimulatorConnectInteractor.swift
//  Luna
//
//  Created by Francis Pascual on 1/28/22.
//

import Foundation
import LunaBluetooth
import Combine

class LunaCgmSimulatorConnectInteractor : PairingConnectInteractor {
    private let service: LunaCgmSimulatorService
    private let userRepository: UserRepository
    private let cgmRepository: CgmRepository
    private var connectCancellable: AnyCancellable? = nil
    
    
    init(service: LunaCgmSimulatorService, userRepository: UserRepository, cgmRepository: CgmRepository) {
        self.service = service
        self.userRepository = userRepository
        self.cgmRepository = cgmRepository
    }
    
    func observeLatestGlucose(for peripheralId: UUID) -> AnyPublisher<Glucose?, Never> {
        return self.observeActivations(for: peripheralId)
            .flatMap { peripheral in peripheral.latestGlucose }
            .map { bleGlucose in bleGlucose?.toGlucose() }
            .eraseToAnyPublisher()
    }
    
    func observeConnectionState(for peripheralId: UUID) -> AnyPublisher<ConnectionState, Never> {
        return self.observeActivations(for: peripheralId)
            .flatMap { peripheral in peripheral.connectionState }
            .eraseToAnyPublisher()
    }
    
    private func observeActivations(for peripheralId: UUID) -> AnyPublisher<SimulatorPeripheral, Never> {
        return self.service.peripheralEvents
            .compactMap { event -> SimulatorPeripheral? in
                switch(event) {
                case .activated(let peripheral):
                    if(peripheral.id == peripheralId) {
                        return peripheral
                    } else {
                        return nil
                    }
                case .deactivated(_):
                    return nil
                }
            }.eraseToAnyPublisher()
    }
    
    func connect(to result: ViewScanResult) {
        guard let peripheral = result.handle as? SimulatorPeripheral else { return }
        self.service.connect(to: peripheral)
    }
    
    func disconnect(from peripheralId: UUID) {
        self.service.disconnect(from: peripheralId)
    }
    
    func saveCgmConnection(for scan: ViewScanResult) async throws {
        let cgmConnection = CgmConnection.lunaSimulator(deviceId: scan.id, deviceName: scan.name)
        print("Saving \(scan.id)")
        try await cgmRepository.setCgmConnection(connection: cgmConnection)
    }
}

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
    private let central: BluetoothCentral<SimulatorPeripheral>
    private let userRepository: UserRepository
    private let cgmRepository: CgmRepository
    private var connectCancellable: AnyCancellable? = nil
    
    
    init(central: BluetoothCentral<SimulatorPeripheral>, userRepository: UserRepository, cgmRepository: CgmRepository) {
        self.central = central
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
        return self.central.peripheralEvents
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
        self.central.connect(to: peripheral)
    }
    
    func disconnect(from peripheralId: UUID) {
        self.central.disconnect(from: peripheralId)
    }
    
    func saveCgmConnection(for scan: ViewScanResult) async throws {
        let cgmConnection = CgmConnection.lunaSimulator(deviceId: scan.id, deviceName: scan.name)
        try await cgmRepository.setCgmConnection(connection: cgmConnection)
    }
}


fileprivate extension BleSimulatorGlucose {

    func toGlucose() -> Glucose {
        let id = Glucose.CREATE_ID
        return Glucose(id: id, time: self.time, egv: self.egv, trend: self.trend.toTrend(), trendRate: nil)
    }
    
}

fileprivate extension BleSimulatorTrend {
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

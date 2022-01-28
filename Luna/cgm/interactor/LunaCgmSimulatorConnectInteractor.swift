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
    
    private var connectCancellable: AnyCancellable? = nil
    
    init(central: BluetoothCentral<SimulatorPeripheral>) {
        self.central = central
    }
    
    func observeConnectionState(for peripheralId: UUID) -> AnyPublisher<ConnectionState, Never> {
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
            }
            .flatMap { peripheral in peripheral.connectionState }
            .eraseToAnyPublisher()
    }
    
    func connect(to result: ViewScanResult) {
        guard let peripheral = result.handle as? SimulatorPeripheral else { return }
        self.central.connect(to: peripheral)
    }
    
    func disconnect(from result: ViewScanResult) {
        guard let peripheral = result.handle as? SimulatorPeripheral else { return }
        self.central.disconnect(from: peripheral)
    }
    
    enum PairingError : Error {
        case connectError(_ message: String)
    }
}

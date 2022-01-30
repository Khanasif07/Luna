//
//  LunaCgmSimulatorService.swift
//  Luna
//
//  Created by Francis Pascual on 1/30/22.
//

import Combine
import Foundation
import LunaBluetooth

class LunaCgmSimulatorService {
    private let central = BluetoothCentral<SimulatorPeripheral>(centralId: "LunaCgmSimulator")
    
    var scanResults: AnyPublisher<ScanResult<SimulatorPeripheral>, Never> {
        central.scanResults
    }
    
    var peripheralEvents : AnyPublisher<PeripheralEvent<SimulatorPeripheral>, Never> {
        central.peripheralEvents
    }
    
    func restore(deviceId: UUID) {
        central.restoreConnect(to: deviceId)
    }
    
    func scan() {
        central.scan()
    }
    
    func stopScan() {
        central.stopScan()
    }

    func connect(to peripheral: SimulatorPeripheral) {
        central.connect(to: peripheral)
    }
    
    func disconnect(from peripheralId: UUID) {
        central.disconnect(from: peripheralId)
    }
}

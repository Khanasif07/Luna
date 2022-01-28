//
//  LunaBleScanInteractor.swift
//  Luna
//
//  Created by Francis Pascual on 1/28/22.
//

import Foundation
import LunaBluetooth
import Combine

class LunaCgmSimulatorScanningInteractor : PairingScannerInteractor {
    private let central: BluetoothCentral<SimulatorPeripheral>
    private let _scanResults = PassthroughSubject<ViewScanResult, Never>()
    var scanResults: AnyPublisher<ViewScanResult, Never>
    
    private var scanResultsCancellable: AnyCancellable? = nil
    
    init(central: BluetoothCentral<SimulatorPeripheral>) {
        self.central = central
        self.scanResults = _scanResults.eraseToAnyPublisher()
        
        self.scanResultsCancellable = central.scanResults
            .receive(on: RunLoop.main)
            .sink { scanResult in
                let viewResult = ViewScanResult(id: scanResult.id, name: scanResult.name, handle: scanResult.peripheral)
                self._scanResults.send(viewResult)
            }
    }
    
    func scan() {
        self.central.scan()
    }
    
    func stopScan() {
        self.central.stopScan()
    }
}

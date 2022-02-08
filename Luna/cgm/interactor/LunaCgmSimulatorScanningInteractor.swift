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
    private let service: LunaCgmSimulatorService
    private let _scanResults = PassthroughSubject<ViewScanResult, Never>()
    var scanResults: AnyPublisher<ViewScanResult, Never>
    
    private var scanResultsCancellable: AnyCancellable? = nil
    
    init(service: LunaCgmSimulatorService) {
        self.service = service
        self.scanResults = _scanResults.eraseToAnyPublisher()
        
        self.scanResultsCancellable = service.scanResults
            .receive(on: RunLoop.main)
            .sink { scanResult in
                let viewResult = ViewScanResult(id: scanResult.id, name: scanResult.name, handle: scanResult.peripheral)
                self._scanResults.send(viewResult)
            }
    }
    
    func scan() {
        service.scan()
    }
    
    func stopScan() {
        service.stopScan()
    }
}

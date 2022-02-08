//
//  LunaCgmSimulatorScanInteractor.swift
//  Luna
//
//  Created by Francis Pascual on 1/28/22.
//

import Combine
import LunaBluetooth

struct ViewScanResult : Identifiable {
    let id: UUID
    let name: String
    let handle: AnyObject
}

protocol PairingScannerInteractor {
    var scanResults: AnyPublisher<ViewScanResult, Never> { get }
    
    func scan()
    
    func stopScan()
}

#if DEBUG

struct MockBleScanInteractor : PairingScannerInteractor {
    private var _scanResults = PassthroughSubject<ViewScanResult, Never>()
    var scanResults: AnyPublisher<ViewScanResult, Never> { _scanResults.eraseToAnyPublisher() }
    
    func scan() {
    }
    
    func stopScan() {
    }
}

#endif

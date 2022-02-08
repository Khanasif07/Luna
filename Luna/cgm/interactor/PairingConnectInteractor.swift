//
//  PairingConnectInteractor.swift
//  Luna
//
//  Created by Francis Pascual on 1/28/22.
//

import Foundation
import LunaBluetooth
import Combine

protocol PairingConnectInteractor {
    func connect(to: ViewScanResult)
    
    func disconnect(from peripheralId: UUID)
    
    func observeLatestGlucose(for peripheralId: UUID) -> AnyPublisher<Glucose?, Never>
    func observeConnectionState(for peripheralId: UUID) -> AnyPublisher<ConnectionState, Never>
    
    func saveCgmConnection(for: ViewScanResult) async throws
}


#if DEBUG

struct MockPairingConnectInteractor : PairingConnectInteractor {
    func connect(to: ViewScanResult) {
    }
    
    func disconnect(from peripheralId: UUID) {
    }
    
    func observeLatestGlucose(for peripheralId: UUID) -> AnyPublisher<Glucose?, Never> {
        return Just(nil).eraseToAnyPublisher()
    }
    
    func observeConnectionState(for peripheralId: UUID) -> AnyPublisher<ConnectionState, Never> {
        return Empty().eraseToAnyPublisher()
    }
    
    func saveCgmConnection(for: ViewScanResult) async throws {
        
    }
}

extension MockPairingConnectInteractor {
    static var preview : PairingConnectInteractor { MockPairingConnectInteractor() }
}

#endif

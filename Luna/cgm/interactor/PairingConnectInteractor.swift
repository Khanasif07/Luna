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
    
    func disconnect(from: ViewScanResult)
    
    func observeConnectionState(for peripheralId: UUID) -> AnyPublisher<ConnectionState, Never>
}


#if DEBUG

struct MockPairingConnectInteractor : PairingConnectInteractor {
    func connect(to: ViewScanResult) {
    }
    
    func disconnect(from: ViewScanResult) {
    }
    
    func observeConnectionState(for peripheralId: UUID) -> AnyPublisher<ConnectionState, Never> {
        return Empty().eraseToAnyPublisher()
    }
}

extension MockPairingConnectInteractor {
    static var preview : PairingConnectInteractor { MockPairingConnectInteractor() }
}

#endif

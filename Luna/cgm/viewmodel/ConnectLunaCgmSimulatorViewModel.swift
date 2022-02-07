//
//  ConnectLunaCgmSimulatorViewModel.swift
//  Luna
//
//  Created by Francis Pascual on 1/28/22.
//

import Foundation
import Combine

enum ConnectLunaCgmSimulatorViewState {
    case connecting
    case connected(glucose: Glucose?)
    case error
}

class ConnectLunaCgmSimulatorViewModel : ObservableObject {
    let scanResult: ViewScanResult
    private let pairing: PairingConnectInteractor
    private var connectCancellable: AnyCancellable? = nil
    
    @Published var state: ConnectLunaCgmSimulatorViewState = .connecting
    
    init(scanResult: ViewScanResult, pairing: PairingConnectInteractor) {
        self.scanResult = scanResult
        self.pairing = pairing
    }
    
    @MainActor
    func connect() {
        connectCancellable = pairing.observeConnectionState(for: scanResult.id)
            .combineLatest(pairing.observeLatestGlucose(for: scanResult.id))
            .receive(on: RunLoop.main)
            .sink { connectionState, glucose in
                if(connectionState == .interactive) {
                    Task {
                        do {
                            try await self.pairing.saveCgmConnection(for: self.scanResult)
                            self.state = .connected(glucose: glucose)
                        } catch {
                            self.state = .error
                        }
                    }
                }
            }
        
        pairing.connect(to: scanResult)
    }
    
    func disconnect() {
        connectCancellable = nil
        pairing.disconnect(from: scanResult.id)
    }
}

#if DEBUG

extension ConnectLunaCgmSimulatorViewModel {
    static var preview : ConnectLunaCgmSimulatorViewModel {
        class MockObject { }
        let scanResult = ViewScanResult(id: UUID(), name: "Preview Simulator", handle: MockObject())
        return ConnectLunaCgmSimulatorViewModel(scanResult: scanResult, pairing: MockPairingConnectInteractor())
    }
}

#endif

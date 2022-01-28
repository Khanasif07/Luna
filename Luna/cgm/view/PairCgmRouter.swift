//
//  PairCgmRouterView.swift
//  Luna
//
//  Created by Francis Pascual on 1/27/22.
//

import Foundation
import SwiftUI
import Combine
import LunaBluetooth

protocol PairCgmScreenRouter {
    func exitPairing()
    func pairLunaCgmSimulator() -> PairLunaCgmSimulatorView
    func connectLunaCgmSimulator(scanResult: ViewScanResult) -> ConnectLunaCgmSimulatorView
}

class PairCgmRouter : ObservableObject, PairCgmScreenRouter, Exitable {
    private let lunaCgmScanner: () -> PairingScannerInteractor
    private let lunaCgmConnect: () -> PairingConnectInteractor
    let exiting = PassthroughSubject<Void, Never>()
    
    init(
        lunaCgmScanner: @escaping () -> PairingScannerInteractor,
        lunaCgmConnect: @escaping () -> PairingConnectInteractor
    ) {
        self.lunaCgmScanner = lunaCgmScanner
        self.lunaCgmConnect = lunaCgmConnect
    }
    
    func exitPairing() {
        exiting.send(Void())
    }
    
    @ViewBuilder func pairLunaCgmSimulator() -> PairLunaCgmSimulatorView {
        let vm = PairLunaCgmSimulatorViewModel(scanner: lunaCgmScanner())
        PairLunaCgmSimulatorView(router: self, viewModel: vm)
    }
    
    @ViewBuilder func connectLunaCgmSimulator(scanResult: ViewScanResult) -> ConnectLunaCgmSimulatorView {
        let vm = ConnectLunaCgmSimulatorViewModel(scanResult: scanResult, pairing: lunaCgmConnect())
        ConnectLunaCgmSimulatorView(router: self, viewModel: vm)
    }
}

struct PairCgmRouterView : View {
    var router: PairCgmRouter
    
    var body: some View {
        NavigationView {
            self.router.pairLunaCgmSimulator()
        }
    }
}


extension PairCgmRouter {
    static var preview: PairCgmRouter {
        PairCgmRouter(
            lunaCgmScanner: { MockBleScanInteractor() },
            lunaCgmConnect: { MockPairingConnectInteractor() }
        )
    }
}

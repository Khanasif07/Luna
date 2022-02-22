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
    func connectLunaCgmSimulator(scanResult: ViewScanResult, showModal: Binding<Bool>) -> ConnectLunaCgmSimulatorView
}

enum PairCgmRouterScreen {
    case loading
    case lunaCgmSimulatorPairing
    case lunaCgmSimulatorConnected(deviceId: UUID, deviceName: String)
    case error
}

class PairCgmRouter : ObservableObject, PairCgmScreenRouter, Exitable {
    @Published var screen: PairCgmRouterScreen = .loading
    private let cgmRepository: CgmRepository
    private let lunaCgmScanner: () -> PairingScannerInteractor
    private let lunaCgmConnect: () -> PairingConnectInteractor
    let exiting = PassthroughSubject<Void, Never>()
    
    init(
        cgmRepository: CgmRepository,
        lunaCgmScanner: @escaping () -> PairingScannerInteractor,
        lunaCgmConnect: @escaping () -> PairingConnectInteractor
    ) {
        self.cgmRepository = cgmRepository
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
    
    @ViewBuilder func connectLunaCgmSimulator(scanResult: ViewScanResult, showModal: Binding<Bool>) -> ConnectLunaCgmSimulatorView {
        let vm = ConnectLunaCgmSimulatorViewModel(scanResult: scanResult, pairing: lunaCgmConnect())
        ConnectLunaCgmSimulatorView(router: self, viewModel: vm, showModal: showModal)
    }
    
    @ViewBuilder func connectedLunaCgmSimulator(deviceId: UUID, deviceName: String) -> ConnectedLunaCgmSimulatorView {
        let vm = ConnectedLunaCgmSimulatorViewModel(deviceId: deviceId, deviceName: deviceName, cgmRepository: cgmRepository, connection: lunaCgmConnect())
        ConnectedLunaCgmSimulatorView(router: self, viewModel: vm)
    }
    
    @MainActor
    func loadStartupScreen() async {
        do {
            if let cgmConnection = try await cgmRepository.getCgmConnection() {
                switch(cgmConnection) {
                case .dexcomG6(_):
                    throw CgmError.invalidState
                case .dexcomG7:
                    throw CgmError.invalidState
                case .freestyleLibre2:
                    throw CgmError.invalidState
                case .freestyleLibre3:
                    throw CgmError.invalidState
                case .lunaSimulator(deviceId: let deviceId, deviceName: let deviceName):
                    screen = .lunaCgmSimulatorConnected(deviceId: deviceId, deviceName: deviceName)
                }
            } else {
                screen = .lunaCgmSimulatorPairing // TODO: This would normally route to the CGM selection screen but need to update that screen to Swift UI first.
            }
        } catch {
            screen = .error
        }
    }
}

struct PairCgmRouterView : View {
    @StateObject var router: PairCgmRouter
    
    var body: some View {
        NavigationView {
            switch(router.screen) {
            case .loading:
                EmptyView()
            case .lunaCgmSimulatorPairing:
                router.pairLunaCgmSimulator()
            case .lunaCgmSimulatorConnected(let deviceId, let deviceName):
                router.connectedLunaCgmSimulator(deviceId: deviceId, deviceName: deviceName)
            case .error:
                Text("An error has occured")
            }
            EmptyView()
        }
        .onAppear {
            Task { await router.loadStartupScreen() }
        }
    }
}

#if DEBUG
extension PairCgmRouter {
    static var preview: PairCgmRouter {
        PairCgmRouter(
            cgmRepository: MockCgmRepository(),
            lunaCgmScanner: { MockBleScanInteractor() },
            lunaCgmConnect: { MockPairingConnectInteractor() }
        )
    }
}
#endif

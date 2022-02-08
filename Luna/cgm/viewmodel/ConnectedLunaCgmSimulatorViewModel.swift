//
//  ConnectedLunaCgmSimulatorViewModel.swift
//  Luna
//
//  Created by Francis Pascual on 1/30/22.
//

import Foundation

class ConnectedLunaCgmSimulatorViewModel : ObservableObject {
    let deviceId: UUID
    let deviceName: String
    let cgmRepository: CgmRepository
    let connection: PairingConnectInteractor
    @Published var shouldExit = false
    @Published var showError = false
    
    init(deviceId: UUID, deviceName: String, cgmRepository: CgmRepository, connection: PairingConnectInteractor) {
        self.deviceId = deviceId
        self.deviceName = deviceName
        self.cgmRepository = cgmRepository
        self.connection = connection
    }
    
    @MainActor
    func disconnect() async {
        do {
            connection.disconnect(from: deviceId)
            try await cgmRepository.clearCgmConnection()
            shouldExit = true
        } catch {
            showError = true
        }
    }
}

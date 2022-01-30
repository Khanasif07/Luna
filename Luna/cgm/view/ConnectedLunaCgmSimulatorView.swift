//
//  ConnectedLunaCgmSimulatorView.swift
//  Luna
//
//  Created by Francis Pascual on 1/29/22.
//

import SwiftUI

struct ConnectedLunaCgmSimulatorView: View {
    let router: PairCgmScreenRouter
    @StateObject var viewModel: ConnectedLunaCgmSimulatorViewModel
    
    var body: some View {
        ConnectedLunaCgmSimulatorContentView(
            deviceName: viewModel.deviceName,
            showError: $viewModel.showError,
            disconnect: { Task { await viewModel.disconnect() } }
        )
            .padding()
            .navigationTitle("Luna CGM Simulator")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: LunaBackButton(action: { router.exitPairing() }))
            .onChange(of: viewModel.shouldExit) { newValue in
                router.exitPairing()
            }
    }
}

private struct ConnectedLunaCgmSimulatorContentView: View {
    let deviceName: String
    @Binding var showError: Bool
    var disconnect: () -> Void = {}
    
    var body: some View {
        VStack {
            Spacer()
            Text("Connecting to \(deviceName)")
            Spacer()
            Button("Disconnect") {
                disconnect()
            }
            .fullWidthButton()
        }
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Failed to disconnect"),
                message: Text("Please try again"),
                dismissButton: .default(Text("Dismiss"))
            )
        }
    }
}

struct ConnectedLunaCgmSimulatorView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectedLunaCgmSimulatorView(
            router: PairCgmRouter.preview,
            viewModel: ConnectedLunaCgmSimulatorViewModel(
                deviceId: UUID(),
                deviceName: "Test Device",
                cgmRepository: MockCgmRepository(),
                connection: MockPairingConnectInteractor()
            )
        )
    }
}

struct ConnectedLunaCgmSimulatorAlertView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectedLunaCgmSimulatorContentView(
            deviceName: "Test Device",
            showError: .constant(true)
        ).padding()
    }
}

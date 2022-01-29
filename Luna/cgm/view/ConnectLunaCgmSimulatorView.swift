//
//  ConnectLunaCgmSimulatorView.swift
//  Luna
//
//  Created by Francis Pascual on 1/28/22.
//

import SwiftUI

struct ConnectLunaCgmSimulatorView: View {
    let router: PairCgmScreenRouter
    @StateObject var viewModel: ConnectLunaCgmSimulatorViewModel
    @Binding var showModal: Bool
    
    var body: some View {
        _ConnectLunaCgmSimulatorView(
            name: viewModel.scanResult.name,
            state: viewModel.state,
            cancel: {
                viewModel.disconnect()
                showModal = false
            }
        )
            .onAppear { viewModel.connect() }
    }
}

private struct _ConnectLunaCgmSimulatorView : View {
    let name: String
    let state: ConnectLunaCgmSimulatorViewState
    var cancel: () -> Void
    
    var body: some View {
        switch state {
        case .connecting:
            VStack {
                Text("Connecting to \(name)")
                Button("Cancel") {
                    cancel()
                }
                .fullWidthButton()
            }
        case .connected(let glucose):
            VStack {
                Text("Connected to \(name)")
                GlucoseView(glucose: glucose)
                Button("Done") {
                    cancel()
                }
                .fullWidthButton()
            }
        case .error:
            VStack {
                Text("Failed to connect to \(name)")
                Button("Close") {
                    cancel()
                }
                .fullWidthButton()
            }
        }
    }
}

struct ConnectLunaCgmSimulatorView_Previews: PreviewProvider {
    static var previews: some View {
        
        ConnectLunaCgmSimulatorView(
            router: PairCgmRouter.preview,
            viewModel: ConnectLunaCgmSimulatorViewModel.preview,
            showModal: .constant(true)
        )
    }
}

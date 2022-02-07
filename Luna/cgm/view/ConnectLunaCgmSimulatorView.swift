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
            },
            complete: {
                showModal = false
                router.exitPairing()
            }
        )
            .onAppear { viewModel.connect() }
    }
}

private struct _ConnectLunaCgmSimulatorView : View {
    let name: String
    let state: ConnectLunaCgmSimulatorViewState
    var cancel: () -> Void
    var complete: () -> Void
    
    var body: some View {
        switch state {
        case .connecting:
            VStack {
                CornerCancelButton(LocalizedString.cancel.localizedKey) {
                    cancel()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                    
                Text("Connecting to \(name)") // i18n: Localizable.strings
                
                ProgressView()
                    .progressViewStyle(.circular)
                    .padding()
            }
        case .connected(let glucose):
            VStack {
                Text("Connected to \(name)") // i18n: Localizable.strings
                GlucoseView(glucose: glucose)
                Button(LocalizedString.done.localizedKey) {
                    complete()
                }
                .fullWidthButton()
            }
        case .error:
            VStack {
                Text("Failed to connect to \(name)") // i18n: Localizable.strings
                Button(LocalizedString.close.localizedKey) {
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

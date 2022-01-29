//
//  ConnectLunaCgmSimulatorView.swift
//  Luna
//
//  Created by Francis Pascual on 1/28/22.
//

import SwiftUI

struct ConnectLunaCgmSimulatorView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let router: PairCgmScreenRouter
    @StateObject var viewModel: ConnectLunaCgmSimulatorViewModel
    
    var body: some View {
        _ConnectLunaCgmSimulatorView(
            name: viewModel.scanResult.name,
            state: viewModel.state
        )
            .onAppear { viewModel.connect() }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: LunaBackButton(action: {
                    viewModel.disconnect()
                    presentationMode.wrappedValue.dismiss()
                })
            )
    }
}

private struct _ConnectLunaCgmSimulatorView : View {
    let name: String
    let state: ConnectLunaCgmSimulatorViewState
    
    var body: some View {
        switch state {
        case .connecting:
            Text("Connecting to \(name)")
        case .connected(let glucose):
            VStack {
                Text("Connected to \(name)")
                GlucoseView(glucose: glucose)
            }
        case .error:
            Text("Failed to connect to \(name)")
        }
    }
}

struct ConnectLunaCgmSimulatorView_Previews: PreviewProvider {
    static var previews: some View {
        
        ConnectLunaCgmSimulatorView(
            router: PairCgmRouter.preview,
            viewModel: ConnectLunaCgmSimulatorViewModel.preview
        )
    }
}

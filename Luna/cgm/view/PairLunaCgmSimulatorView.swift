//
//  PairLunaCgmSimulatorView.swift
//  Luna
//
//  Created by Francis Pascual on 1/27/22.
//

import SwiftUI
import LunaBluetooth

struct PairLunaCgmSimulatorView : View {
    let router: PairCgmScreenRouter
    @StateObject var viewModel: PairLunaCgmSimulatorViewModel
    
    var body: some View {
        _PairLunaCgmSimulatorView(
            router: router,
            scanResults: viewModel.scanResults
        )
            .onAppear { viewModel.scan() }
            .onDisappear { viewModel.stopScan() }
            .navigationTitle(LocalizedString.pair_cgm_simulator.localizedKey)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: LunaBackButton(action: { router.exitPairing() }))
    }
}

private struct _PairLunaCgmSimulatorView : View {
    let router: PairCgmScreenRouter
    let scanResults: [ViewScanResult]
    @State var connectTo: ViewScanResult? = nil
    @State var showModal: Bool = false
    
    var body : some View {
        ZStack(alignment: .center) {
            VStack {
                Text(LocalizedString.pairLunaCgmSimExplanation.localizedKey)
                
                ZStack {
                    List(scanResults) { scanResult in
                        Button(scanResult.name) {
                            connectTo = scanResult
                            showModal = true
                        }
                    }
                    
                    if(scanResults.isEmpty) {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                }
            }
            .padding(.vertical, 8)
            .onChange(of: showModal) { newValue in
                if(!newValue) {
                    connectTo = nil
                }
            }
            .fullScreenCover(
                isPresented: $showModal,
                onDismiss: { connectTo = nil },
                content: {
                    ZStack {
                        if let connectTo = connectTo {
                            router.connectLunaCgmSimulator(scanResult: connectTo, showModal: $showModal)
                        }
                    }
                    .alertModal()
                }
            )
        }
    }
}

#if DEBUG
struct PairLunaCgmSimulatorView_Previews: PreviewProvider {
    static var previews: some View {
        PairLunaCgmSimulatorView(router: PairCgmRouter.preview, viewModel: PairLunaCgmSimulatorViewModel.preview)
    }
}

#endif

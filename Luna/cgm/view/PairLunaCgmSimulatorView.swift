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
            .navigationTitle("Pair CGM Simulator")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: LunaBackButton(action: { router.exitPairing() }))
    }
}

private struct _PairLunaCgmSimulatorView : View {
    let router: PairCgmScreenRouter
    let scanResults: [ViewScanResult]
    
    var body : some View {
        VStack {
            Text("To pair your Luna CGM Simulator, enable the simulator on your mac or iOS device")
            
            ZStack {
                List(scanResults) { scanResult in
                    NavigationLink(scanResult.name) {
                        router.connectLunaCgmSimulator(scanResult: scanResult)
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
        
    }
}

struct PairLunaCgmSimulatorView_Previews: PreviewProvider {
    static var previews: some View {
        PairLunaCgmSimulatorView(router: PairCgmRouter.preview, viewModel: PairLunaCgmSimulatorViewModel.preview)
    }
}

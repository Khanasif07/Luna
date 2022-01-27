//
//  PairCgmRouterView.swift
//  Luna
//
//  Created by Francis Pascual on 1/27/22.
//

import Foundation
import SwiftUI
import Combine

protocol PairCgmScreenRouter {
    func exitPairing()
    func pairLunaCgmSimulator() -> PairLunaCgmSimulatorView
}

class PairCgmRouter : ObservableObject, PairCgmScreenRouter, Exitable {
    let exiting = PassthroughSubject<Void, Never>()
    
    func exitPairing() {
        exiting.send(Void())
    }
    
    @ViewBuilder func pairLunaCgmSimulator() -> PairLunaCgmSimulatorView {
        PairLunaCgmSimulatorView(router: self, viewModel: PairLunaCgmSimulatorViewModel())
    }
}

struct PairCgmRouterView : View {
    var router: PairCgmRouter
    
    var body: some View {
        NavigationView {
            self.router.pairLunaCgmSimulator()
                .navigationTitle("Pair CGM Simulator")
        }
    }
}

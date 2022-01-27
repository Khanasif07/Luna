//
//  PairLunaCgmSimulatorView.swift
//  Luna
//
//  Created by Francis Pascual on 1/27/22.
//

import SwiftUI

struct PairLunaCgmSimulatorView : View {
    let router: PairCgmScreenRouter
    @StateObject var viewModel: PairLunaCgmSimulatorViewModel
    
    var body: some View {
        
        ZStack {
            Text("Hello World")
        }
        .navigationTitle(LocalizedString.pair_cgm_simulator.localizedKey)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: LunaBackButton(action: { router.exitPairing() }))
    }
}


struct PairLunaCgmSimulatorView_Previews: PreviewProvider {
    static var previews: some View {
        PairLunaCgmSimulatorView(router: PairCgmRouter(), viewModel: PairLunaCgmSimulatorViewModel())
    }
}

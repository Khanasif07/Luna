//
//  AppState.swift
//  Luna
//
//  Created by Francis Pascual on 1/26/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import LunaBluetooth

class AppState {
    
    let firebaseApp: FirebaseApp
    let firestore : Firestore
    let cgmRepository : CgmRepository
    
    lazy var lunaCgmCentral : BluetoothCentral<SimulatorPeripheral> = { BluetoothCentral<SimulatorPeripheral>(centralId: "LunaCGM") }()
    
    init(firebaseApp: FirebaseApp) {
        self.firebaseApp = firebaseApp
        self.firestore = Firestore.firestore(app: firebaseApp)
        self.cgmRepository = FirestoreCgmRepository(firestore: self.firestore)
    }
    
    func pairCgmRouter() -> PairCgmRouter {
        PairCgmRouter(
            lunaCgmScanner: { LunaCgmSimulatorScanningInteractor(central: self.lunaCgmCentral) },
            lunaCgmConnect: { LunaCgmSimulatorConnectInteractor(central: self.lunaCgmCentral) }
        )
    }
}

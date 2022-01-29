//
//  AppState.swift
//  Luna
//
//  Created by Francis Pascual on 1/26/22.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import LunaBluetooth

class AppState {
    
    let firebaseApp: FirebaseApp
    let firebaseAuth: Auth
    let firestore : Firestore
    let userRepository : UserRepository
    let cgmRepository : CgmRepository
    
    private lazy var lunaCgmCentral : BluetoothCentral<SimulatorPeripheral> = { BluetoothCentral<SimulatorPeripheral>(centralId: "LunaCGM") }()
    
    init(firebaseApp: FirebaseApp) {
        self.firebaseApp = firebaseApp
        self.firebaseAuth = Auth.auth(app: firebaseApp)
        self.firestore = Firestore.firestore(app: firebaseApp)
        self.userRepository = FirebaseUserRepository(auth: self.firebaseAuth)
        self.cgmRepository = FirestoreCgmRepository(firestore: self.firestore)
    }
    
    func pairCgmRouter() -> PairCgmRouter {
        PairCgmRouter(
            lunaCgmScanner: { LunaCgmSimulatorScanningInteractor(central: self.lunaCgmCentral) },
            lunaCgmConnect: { LunaCgmSimulatorConnectInteractor(central: self.lunaCgmCentral) }
        )
    }
}

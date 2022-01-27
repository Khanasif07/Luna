//
//  AppState.swift
//  Luna
//
//  Created by Francis Pascual on 1/26/22.
//

import Foundation
import Firebase
import FirebaseFirestore

class AppState {
    
    let firebaseApp: FirebaseApp
    let firestore : Firestore
    let cgmRepository : CgmRepository
    
    init(firebaseApp: FirebaseApp) {
        self.firebaseApp = firebaseApp
        self.firestore = Firestore.firestore(app: firebaseApp)
        self.cgmRepository = FirestoreCgmRepository(firestore: self.firestore)
    }
}

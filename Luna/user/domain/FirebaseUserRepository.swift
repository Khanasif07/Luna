//
//  LegacyUserRepository.swift
//  Luna
//
//  Created by Francis Pascual on 1/29/22.
//

import Foundation
import FirebaseAuth

class FirebaseUserRepository : UserRepository {
    private let auth: Auth
    
    init(auth: Auth) {
        self.auth = auth
    }
    
    func getCurrentUid() async throws -> String? {
        
        return auth.currentUser?.uid
    }
}

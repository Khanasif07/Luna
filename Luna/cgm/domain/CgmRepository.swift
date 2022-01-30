//
//  CgmRepository.swift
//  Luna
//
//  Created by Francis Pascual on 1/26/22.
//

import Foundation

protocol CgmRepository {
    func getCgmConnection() async throws -> CgmConnection?
    func setCgmConnection(connection: CgmConnection) async throws
    func clearCgmConnection() async throws
}

#if DEBUG

struct MockCgmRepository : CgmRepository {
    func getCgmConnection() async throws -> CgmConnection? {
        return nil
    }
    
    func setCgmConnection(connection: CgmConnection) async throws {
    }
    
    func clearCgmConnection() async throws {
        
    }
}

#endif

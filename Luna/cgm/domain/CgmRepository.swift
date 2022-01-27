//
//  CgmRepository.swift
//  Luna
//
//  Created by Francis Pascual on 1/26/22.
//

import Foundation

protocol CgmRepository {
    func getCgmConnection(uid: String) async throws -> CgmConnection?
    func setCgmConnection(uid: String, connection: CgmConnection) throws
}

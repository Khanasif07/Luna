//
//  UserRepository.swift
//  Luna
//
//  Created by Francis Pascual on 1/29/22.
//

import Foundation

protocol UserRepository {
    func getCurrentUid() async throws -> String?
}

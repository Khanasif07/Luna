//
//  FirestoreCgmRepository.swift
//  Luna
//
//  Created by Francis Pascual on 1/26/22.
//

import os
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreCgmRepository : CgmRepository {
    private let firestore: Firestore
    private let userRepository: UserRepository
    
    init(firestore: Firestore, userRepository: UserRepository) {
        self.firestore = firestore
        self.userRepository = userRepository
    }
    
    func getCgmConnection() async throws -> CgmConnection? {
        guard let uid = try await userRepository.getCurrentUid() else { throw UserError.userNotLoggedIn }
        let document = try await cgmSettingsRef(uid: uid).getDocument()
        
        do {
            let cgmSettings = try document.data(as: FirestoreCgmSettings.self)
            return cgmSettings?.toCgmConnection()
        } catch {
            print("Failed to parse connection")
            return nil
        }
    }
    
    func setCgmConnection(connection: CgmConnection) async throws {
        guard let uid = try await userRepository.getCurrentUid() else { throw UserError.userNotLoggedIn }
        let data = connection.toFirestoreCgmSettings(uid: uid)
        
        let document = cgmSettingsRef(uid: uid)
        try document.setData(from: data)
    }
    
    func clearCgmConnection() async throws {
        guard let uid = try await userRepository.getCurrentUid() else { throw UserError.userNotLoggedIn }
        let document = cgmSettingsRef(uid: uid)
        try await document.delete()
    }
    
    private func cgmSettingsRef(uid: String) -> DocumentReference {
        return firestore
            .collection(FirestoreCollections.users)
            .document(uid)
            .collection(FirestoreCollections.settings)
            .document(FirestoreCgmSettings.name)
    }
}

private enum FirestoreCgmSource : String, Codable {
    case dexcomG6 = "DexcomG6"
    case dexcomG7 = "DexcomG7"
    case freestyleLibre2 = "FreestyleLibre2"
    case freestyleLibre3 = "FreestyleLibre3"
    case lunaSimulator = "LunaSimulator"
}

private struct FirestoreCgmSettings : Codable {
    static let name = "cgm"
    
    var uid: String
    var lastModifiedTime: Date = Date()
    var cgmSource: FirestoreCgmSource? = nil
    var dexcomG6: DexcomG6Settings? = nil
    var lunaSimulator: LunaSimulatorSettings? = nil
    
    struct DexcomG6Settings : Codable {
        var os: FirestoreOperatingSystem
        var credentialId: String
    }
    
    struct LunaSimulatorSettings : Codable {
        var os: FirestoreOperatingSystem
        var deviceId: String
        var deviceName: String
    }
}

extension FirestoreCgmSettings {
    func toCgmConnection() -> CgmConnection? {
        guard let cgmSource = cgmSource else { return nil }
        switch(cgmSource) {
        case .dexcomG6:
            guard let settings = dexcomG6 else { return nil }
            guard settings.os == .ios else { return nil }
            return .dexcomG6(credentialId: settings.credentialId)
        case .dexcomG7:
            return .dexcomG7
        case .freestyleLibre2:
            return .freestyleLibre2
        case .freestyleLibre3:
            return .freestyleLibre3
        case .lunaSimulator:
            guard let settings = lunaSimulator else { return nil }
            guard settings.os == .ios else { return nil }
            guard let deviceId = UUID(uuidString: settings.deviceId) else { return nil }
            return .lunaSimulator(deviceId: deviceId, deviceName: settings.deviceName)
        }
    }
}

extension CgmConnection {
    fileprivate func toFirestoreCgmSettings(uid: String) -> FirestoreCgmSettings {
        switch(self) {
        case .dexcomG6(let credentialId):
            let settings = FirestoreCgmSettings.DexcomG6Settings(os: .ios, credentialId: credentialId)
            return FirestoreCgmSettings(uid: uid, cgmSource: .dexcomG6, dexcomG6: settings)
        case .dexcomG7:
            return FirestoreCgmSettings(uid: uid, cgmSource: .dexcomG7)
        case .freestyleLibre2:
            return FirestoreCgmSettings(uid: uid, cgmSource: .freestyleLibre2)
        case .freestyleLibre3:
            return FirestoreCgmSettings(uid: uid, cgmSource: .freestyleLibre3)
        case .lunaSimulator(let deviceId, let deviceName):
            let settings = FirestoreCgmSettings.LunaSimulatorSettings(os: .ios, deviceId: deviceId.uuidString, deviceName: deviceName)
            return FirestoreCgmSettings(uid: uid, cgmSource: .lunaSimulator, lunaSimulator: settings)
        }
    }
}

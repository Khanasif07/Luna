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
    
    init(firestore: Firestore) {
        self.firestore = firestore
    }
    
    func getCgmConnection(uid: String) async throws -> CgmConnection? {
        let document = try await cgmSettingsRef(uid: uid).getDocument()
        
        do {
            let cgmSettings = try document.data(as: FirestoreCgmSettings.self)
            return cgmSettings?.toCgmConnection()
        } catch {
            print("Failed to parse connection")
            return nil
        }
    }
    
    func setCgmConnection(uid: String, connection: CgmConnection) throws {
        let data = connection.toFirestoreCgmSettings(uid: uid)
        
        let document = cgmSettingsRef(uid: uid)
        try document.setData(from: data)
    }
    
    private func cgmSettingsRef(uid: String) -> DocumentReference {
        return firestore
            .collection(FirestoreCollections.users)
            .document(uid)
            .collection(FirestoreCollections.settings)
            .document(FirestoreCgmSettings.name)
    }
}

private enum FirestoreCgmType : String, Codable {
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
    var cgmType: FirestoreCgmType? = nil
    var dexcomG6: DexcomG6Settings? = nil
    var lunaSimulator: LunaSimulatorSettings? = nil
    
    struct DexcomG6Settings : Codable {
        var os: FirestoreOperatingSystem
        var credentialId: String
    }
    
    struct LunaSimulatorSettings : Codable {
        var os: FirestoreOperatingSystem
        var deviceId: String
        var deviceName: String? = nil
    }
}

extension FirestoreCgmSettings {
    func toCgmConnection() -> CgmConnection? {
        guard let cgmType = cgmType else { return nil }
        switch(cgmType) {
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
            return FirestoreCgmSettings(uid: uid, cgmType: .dexcomG6, dexcomG6: settings)
        case .dexcomG7:
            return FirestoreCgmSettings(uid: uid, cgmType: .dexcomG7)
        case .freestyleLibre2:
            return FirestoreCgmSettings(uid: uid, cgmType: .freestyleLibre2)
        case .freestyleLibre3:
            return FirestoreCgmSettings(uid: uid, cgmType: .freestyleLibre3)
        case .lunaSimulator(let deviceId, let deviceName):
            let settings = FirestoreCgmSettings.LunaSimulatorSettings(os: .ios, deviceId: deviceId.uuidString, deviceName: deviceName)
            return FirestoreCgmSettings(uid: uid, cgmType: .lunaSimulator, lunaSimulator: settings)
        }
    }
}

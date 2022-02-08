//
//  FirestoreConstants.swift
//  Luna
//
//  Created by Francis Pascual on 1/26/22.
//

import Foundation

struct FirestoreCollections {
    static let users = "users"
    static let settings = "settings"
}

enum FirestoreOperatingSystem : String, Codable {
    case ios = "iOS"
    case android = "Android"
}

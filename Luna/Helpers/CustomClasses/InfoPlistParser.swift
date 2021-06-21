//
//  InfoPlistParser.swift
//  Luna
//
//  Created by Admin on 21/06/21.
//

import Foundation
struct InfoPlistParser {
    static func getStringValue(forKey key: String)-> String{
        guard let value  = Bundle.main.infoDictionary?[key] as? String else {
            fatalError("could not find value for \(key) in the info.plist")
        }
        return value
    }
}

//
//  AppUserDefaults.swift
//  Luna
//
//  Created by Admin on 03/06/21.
//

import Foundation
import Foundation
import SwiftyJSON

enum AppUserDefaults {
    
    static func value(forKey key: Key,
                      file : String = #file,
                      line : Int = #line,
                      function : String = #function) -> JSON {
        
        guard let value = UserDefaults.standard.object(forKey: key.rawValue) else {
            
            debugPrint("No Value Found in UserDefaults\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
            
            return JSON.null
        }
        
        return JSON(value)
    }
    
    static func value<T>(forKey key: Key,
                      fallBackValue : T,
                      file : String = #file,
                      line : Int = #line,
                      function : String = #function) -> JSON {
        
        guard let value = UserDefaults.standard.object(forKey: key.rawValue) else {
            
            debugPrint("No Value Found in UserDefaults\nFile : \(file) \nFunction : \(function)")
            return JSON(fallBackValue)
        }
        
        return JSON(value)
    }
    
    static func save(value : Any, forKey key : Key) {
        
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func removeValue(forKey key : Key) {
        
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func removeAllValuesExceptInstallationTokenDateAndFCMToken() {
//        let array = [Key.appInstalled, Key.date, Key.fcmToken, Key.firstRun, Key.currentLocationLattitude, Key.currentLocationLongitude, Key.bluetoothPromptShown]
//        for key in self.Key.allCases {
//            if array.contains(key) { continue }
////            if key == self.Key.appInstalled || key == self.Key.date || key == self.Key.fcmToken { continue }
//            UserDefaults.standard.removeObject(forKey: key.rawValue)
//            UserDefaults.standard.synchronize()
//        }
    }
    
    static func removeAllValues() {
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        UserDefaults.standard.synchronize()
    }
}

// MARK:- KEYS
//==============
extension AppUserDefaults {
    
    enum Key : String, CaseIterable {
        case authVerificationID
        case authorization
        case accesstoken
        case isTermsAndConditionSelected
        case isBiometricSelected
        case isBiometricCompleted
        case isProfileStepCompleted
        case isSystemSetupCompleted
        case isSignupCompleted
        case isGuestMode
        case tutorialDisplayed
        case userType
        case currentUserType
        case phoneNoVerified
        case emailVerified
        case isGarrage
        case fullUserProfile
        case forgotPassword
        case checkInDetails
        case loggedIn
        case appInstalled
        case latitude
        case uid
        case roomId
        case defaultEmail
        case defaultPassword
        case fcmToken
        case token
        case longitude
        case language
        case loggedOut
        case garageName
        case garageAddress
        case name
        case userId
        case contactFetchDate
        case pushNotificationStatus
        case canChangePassword
        case unreadCount
    }
}


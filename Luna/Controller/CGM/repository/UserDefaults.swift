//
//  UserDefaults.swift
//  LoopFollow
//
//  Created by Jon Fawcett on 6/4/20.
//  Copyright © 2020 Jon Fawcett. All rights reserved.
//

import Foundation
import UIKit

struct DosingHistory: Codable {
    var sessionStatus: String
    var sessionTime: Double
    var insulin: String
    var sessionExpired: Bool
    var sessionCreated: Bool
    
    init(sessionStatus:String, sessionTime: Double, insulin: String, sessionExpired: Bool,sessionCreated: Bool = false){
        self.sessionTime = sessionTime
        self.sessionStatus = sessionStatus
        self.insulin = insulin
        self.sessionExpired = sessionExpired
        self.sessionCreated = sessionCreated
    }
}

class UserDefaultsRepository {

    // Nightscout Settings
    static let url = UserDefaultsValue<String>(key: "url", default: "")
    static let token = UserDefaultsValue<String>(key: "token", default: "")
    static let units = UserDefaultsValue<String>(key: "units", default: "mg/dl")
    
    // Dexcom Share Settings
    static let sessionStartDate = UserDefaultsValue<Double>(key: "sessionStartDate", default: 0.0)
    static let sessionEndDate = UserDefaultsValue<Double>(key: "sessionEndDate", default: 0.0)
    
    // Dexcom Share Settings
    static let shareUserName = UserDefaultsValue<String>(key: "shareUserName", default: "")
    static let sharePassword = UserDefaultsValue<String>(key: "sharePassword", default: "")
    static let shareServer = UserDefaultsValue<String>(key: "shareServer", default: "US")
    // Graph Settings
    static let chartScaleX = UserDefaultsValue<Float>(key: "chartScaleX", default: 4.0)
    static let showDots = UserDefaultsValue<Bool>(key: "showDots", default: true)
    static let minBGScale = UserDefaultsValue<Float>(key: "minBGScale", default: 350.0)
    static let lowLine = UserDefaultsValue<Float>(key: "lowLine", default: 70.0)
    static let highLine = UserDefaultsValue<Float>(key: "highLine", default: 180.0)
    // General Settings
    static let colorBGText = UserDefaultsValue<Bool>(key: "colorBGText", default: true)
    static let backgroundRefreshFrequency = UserDefaultsValue<Double>(key: "backgroundRefreshFrequency", default: 1)
    static let backgroundRefresh = UserDefaultsValue<Bool>(key: "backgroundRefresh", default: true)
    static let appBadge = UserDefaultsValue<Bool>(key: "appBadge", default: true)
    static let persistentNotification = UserDefaultsValue<Bool>(key: "persistentNotification", default: true)
    static let persistentNotificationLastBGTime = UserDefaultsValue<TimeInterval>(key: "persistentNotificationLastBGTime", default: 0)
    static let screenlockSwitchState = UserDefaultsValue<Bool>(
        key: "screenlockSwitchState",
        default: UIApplication.shared.isIdleTimerDisabled,
        onChange: { screenlock in
            UIApplication.shared.isIdleTimerDisabled = screenlock
    })
    
    // Advanced Settings
    static let onlyDownloadBG = UserDefaultsValue<Bool>(key: "onlyDownloadBG", default: false)
    static let alwaysDownloadAllBG = UserDefaultsValue<Bool>(key: "alwaysDownloadAllBG", default: true)
    static let bgUpdateDelay = UserDefaultsValue<Int>(key: "bgUpdateDelay", default: 10)
    static let downloadDays = UserDefaultsValue<Int>(key: "downloadDays", default: 1)
    
}

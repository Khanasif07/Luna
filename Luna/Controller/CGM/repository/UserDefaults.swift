//
//  UserDefaults.swift
//  LoopFollow
//
//  Created by Jon Fawcett on 6/4/20.
//  Copyright © 2020 Jon Fawcett. All rights reserved.
//

import Foundation
import UIKit

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
    
    static let dosingDataArray = UserDefaultsValue<Array>(key: "dosingDataArray", default: [["jnj"]])
    // Graph Settings
    static let chartScaleX = UserDefaultsValue<Float>(key: "chartScaleX", default: 4.0)
    static let showDots = UserDefaultsValue<Bool>(key: "showDots", default: true)
//    static let smallGraphTreatments = UserDefaultsValue<Bool>(key: "smallGraphTreatments", default: true)
//    static let showValues = UserDefaultsValue<Bool>(key: "showValues", default: true)
//    static let showAbsorption = UserDefaultsValue<Bool>(key: "showAbsorption", default: true)
//    static let showLines = UserDefaultsValue<Bool>(key: "showLines", default: true)
//    static let hoursToLoad = UserDefaultsValue<Int>(key: "hoursToLoad", default: 24)
//    static let predictionToLoad = UserDefaultsValue<Double>(key: "predictionToLoad", default: 1)
//    static let minBasalScale = UserDefaultsValue<Double>(key: "minBasalScale", default: 5.0)
    static let minBGScale = UserDefaultsValue<Float>(key: "minBGScale", default: 350.0)
//    static let showDIALines = UserDefaultsValue<Bool>(key: "showDIAMarkers", default: true)
    static let lowLine = UserDefaultsValue<Float>(key: "lowLine", default: 70.0)
    static let highLine = UserDefaultsValue<Float>(key: "highLine", default: 180.0)
//    static let smallGraphHeight = UserDefaultsValue<Int>(key: "smallGraphHeight", default: 40)
    
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
    static let alwaysDownloadAllBG = UserDefaultsValue<Bool>(key: "alwaysDownloadAllBG", default: false)
    static let bgUpdateDelay = UserDefaultsValue<Int>(key: "bgUpdateDelay", default: 10)
    
}

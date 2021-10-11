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

    // DisplayValues total
    static let infoDataTotal = UserDefaultsValue<Int>(key: "infoDataTotal", default: 0)
    static let infoNames = UserDefaultsValue<[String]>(key: "infoNames", default: [
        "IOB",
        "COB",
        "Basal",
        "Override",
        "Battery",
        "Pump",
        "SAGE",
        "CAGE",
        "Rec. Bolus",
        "Pred."])
    static let infoSort = UserDefaultsValue<[Int]>(key: "infoSort", default: [0,1,2,3,4,5,6,7,8,9])
    static let infoVisible = UserDefaultsValue<[Bool]>(key: "infoVisible", default: [true,true,true,true,true,true,true,true,true,true])
    
    // Nightscout Settings
    static let url = UserDefaultsValue<String>(key: "url", default: "")
    static let token = UserDefaultsValue<String>(key: "token", default: "")
    static let units = UserDefaultsValue<String>(key: "units", default: "mg/dl")
    
    // Dexcom Share Settings
    static let shareUserName = UserDefaultsValue<String>(key: "shareUserName", default: "")
    static let sharePassword = UserDefaultsValue<String>(key: "sharePassword", default: "")
    static let shareServer = UserDefaultsValue<String>(key: "shareServer", default: "US")
    
    // Graph Settings
    static let chartScaleX = UserDefaultsValue<Float>(key: "chartScaleX", default: 4.0)
    static let showDots = UserDefaultsValue<Bool>(key: "showDots", default: true)
    static let smallGraphTreatments = UserDefaultsValue<Bool>(key: "smallGraphTreatments", default: true)
    static let showValues = UserDefaultsValue<Bool>(key: "showValues", default: true)
    static let showAbsorption = UserDefaultsValue<Bool>(key: "showAbsorption", default: true)
    static let showLines = UserDefaultsValue<Bool>(key: "showLines", default: true)
    static let hoursToLoad = UserDefaultsValue<Int>(key: "hoursToLoad", default: 24)
    static let predictionToLoad = UserDefaultsValue<Double>(key: "predictionToLoad", default: 1)
    static let minBasalScale = UserDefaultsValue<Double>(key: "minBasalScale", default: 5.0)
    static let minBGScale = UserDefaultsValue<Float>(key: "minBGScale", default: 350.0)
    static let showDIALines = UserDefaultsValue<Bool>(key: "showDIAMarkers", default: true)
    static let lowLine = UserDefaultsValue<Float>(key: "lowLine", default: 70.0)
    static let highLine = UserDefaultsValue<Float>(key: "highLine", default: 180.0)
    static let smallGraphHeight = UserDefaultsValue<Int>(key: "smallGraphHeight", default: 40)
    
    
    // General Settings
    static let colorBGText = UserDefaultsValue<Bool>(key: "colorBGText", default: true)
    static let showStats = UserDefaultsValue<Bool>(key: "showStats", default: true)
    static let useIFCC = UserDefaultsValue<Bool>(key: "useIFCC", default: false)
    static let showSmallGraph = UserDefaultsValue<Bool>(key: "showSmallGraph", default: true)
    static let speakBG = UserDefaultsValue<Bool>(key: "speakBG", default: false)
    static let backgroundRefreshFrequency = UserDefaultsValue<Double>(key: "backgroundRefreshFrequency", default: 1)
    static let backgroundRefresh = UserDefaultsValue<Bool>(key: "backgroundRefresh", default: true)
    static let appBadge = UserDefaultsValue<Bool>(key: "appBadge", default: true)
    static let dimScreenWhenIdle = UserDefaultsValue<Int>(key: "dimScreenWhenIdle", default: 0)
    static let forceDarkMode = UserDefaultsValue<Bool>(key: "forceDarkMode", default: true)
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
    static let downloadTreatments = UserDefaultsValue<Bool>(key: "downloadTreatments", default: true)
    static let downloadPrediction = UserDefaultsValue<Bool>(key: "downloadPrediction", default: true)
    static let graphOtherTreatments = UserDefaultsValue<Bool>(key: "graphOtherTreatments", default: true)
    static let graphBasal = UserDefaultsValue<Bool>(key: "graphBasal", default: true)
    static let graphBolus = UserDefaultsValue<Bool>(key: "graphBolus", default: true)
    static let graphCarbs = UserDefaultsValue<Bool>(key: "graphCarbs", default: true)
    static let debugLog = UserDefaultsValue<Bool>(key: "debugLog", default: false)
    static let alwaysDownloadAllBG = UserDefaultsValue<Bool>(key: "alwaysDownloadAllBG", default: true)
    static let bgUpdateDelay = UserDefaultsValue<Int>(key: "bgUpdateDelay", default: 10)
    
    
    // Watch Calendar Settings
    static let calendarIdentifier = UserDefaultsValue<String>(key: "calendarIdentifier", default: "")
    static let savedEventID = UserDefaultsValue<String>(key: "savedEventID", default: "")
    static let lastCalendarStartDate = UserDefaultsValue<Date?>(key: "lastCalendarStartDate", default: nil)
    static let writeCalendarEvent = UserDefaultsValue<Bool>(key: "writeCalendarEvent", default: false)
    static let watchLine1 = UserDefaultsValue<String>(key: "watchLine1", default: "%BG% %DIRECTION% %DELTA% %MINAGO%")
    static let watchLine2 = UserDefaultsValue<String>(key: "watchLine2", default: "C:%COB% I:%IOB% B:%BASAL%")
    static let saveImage = UserDefaultsValue<Bool>(key: "saveImage", default: false)
    
    // Alarm Settings
    static let systemOutputVolume = UserDefaultsValue<Float>(key: "systemOutputVolume", default: 0.5)
    static let fadeInTimeInterval = UserDefaultsValue<TimeInterval>(key: "fadeInTimeInterval", default: 0)
    static let vibrate = UserDefaultsValue<Bool>(key: "vibrate", default: true)
    static let overrideSystemOutputVolume = UserDefaultsValue<Bool>(key: "overrideSystemOutputVolume", default: true)
    static let forcedOutputVolume = UserDefaultsValue<Float>(key: "forcedOutputVolume", default: 0.5)
    
    
}

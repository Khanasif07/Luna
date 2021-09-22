//
//  CarbBolusArrays.swift
//  Luna
//
//  Created by Admin on 21/09/21.
//

import Foundation


extension BottomSheetVC {
    
    func findNearestBGbyTime(needle: TimeInterval, haystack: [ShareGlucoseData], startingIndex: Int) -> (sgv: Double, foundIndex: Int) {
        
        // If we can't find a match or things fail, put it at 100 BG
        for i in startingIndex..<haystack.count {
            // i has reached the end without a result. Put the dot at 100
            if i == haystack.count - 1 { return (100.00, 0) }
            
            if needle >= haystack[i].date && needle < haystack[i + 1].date {
                return (Double(haystack[i].sgv), i)
            }
        }
        
        return (100.00, 0)
    }
    
    
    func findNearestBolusbyTime(timeWithin: Int, needle: TimeInterval, haystack: [bolusGraphStruct], startingIndex: Int) -> (offset: Bool, foundIndex: Int) {
        
        // If we can't find a match or things fail, put it at 100 BG
        for i in startingIndex..<haystack.count {
            // i has reached the end without a result. return 0
            let timeDiff = needle - haystack[i].date
            if timeDiff <= Double(timeWithin) && timeDiff >= Double(-timeWithin) { return (true, i)}
            
            if i == haystack.count - 1 { return (false, 0) }
            if timeDiff < Double(-timeWithin) { return (false, 0)}
            
        }
        
        return (false, 0 )
    }
    
    static func findNextCarbTime(timeWithin: Int, needle: TimeInterval, haystack: [carbGraphStruct], startingIndex: Int) -> Bool {
        
        if startingIndex > haystack.count - 2 { return false }
        if haystack[startingIndex + 1].date -  needle < Double(timeWithin) {
            return true
        }

        return false
    }
    
   static  func findNextBolusTime(timeWithin: Int, needle: TimeInterval, haystack: [bolusGraphStruct], startingIndex: Int) -> Bool {
        
        var last = false
        var next = true
        if startingIndex > haystack.count - 2 { return false }
        if startingIndex == 0 { return false }
        
        // Nothing to right that requires shift
        if haystack[startingIndex + 1].date -  needle > Double(timeWithin) {
            return false
        } else {
            // Nothing to left preventing shift
            if needle - haystack[startingIndex - 1].date > Double(timeWithin) {
                return true
            }
        }
        
        return false
    }
    
}


class AppStateController {
   
   // add app states & methods here

   // General Settings States
   var generalSettingsChanged : Bool = false
   var generalSettingsChanges : Int = 0

   // Chart Settings State
   var chartSettingsChanged : Bool = false // settings change has ocurred
   var chartSettingsChanges: Int = 0      // what settings have changed
   
   // Info Data Settings State; no need for flags
   var infoDataSettingsChanged: Bool = false
}

// General Settings Flags
enum GeneralSettingsChangeEnum: Int {
   case colorBGTextChange = 1
   case speakBGChange = 2
   case backgroundRefreshFrequencyChange = 4
   case backgroundRefreshChange = 8
   case appBadgeChange = 16
   case dimScreenWhenIdleChange = 32
   case forceDarkModeChang = 64
   case persistentNotificationChange = 128
   case persistentNotificationLastBGTimeChange = 256
   case screenlockSwitchStateChange = 512
    case showStatsChange = 1024
    case showSmallGraphChange = 2048
    case useIFCCChange = 4096
}

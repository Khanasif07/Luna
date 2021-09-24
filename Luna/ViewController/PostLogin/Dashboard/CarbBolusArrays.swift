//
//  CarbBolusArrays.swift
//  Luna
//
//  Created by Admin on 21/09/21.
//

import Foundation

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

//
//  Alarms.swift
//  Luna
//
//  Created by Admin on 22/09/21.
//

import Foundation
import AVFoundation

extension BottomSheetVC{
    
    func checkAlarms(bgs: [ShareGlucoseData]){
        // Don't check or fire alarms within 1 minute of prior alarm
//        if checkAlarmTimer.isValid {  return }
        
        _ = Date()
//        let now = date.timeIntervalSince1970
//        let currentBG = bgs[bgs.count - 1].sgv
//        let lastBG = bgs[bgs.count - 2].sgv
        
        var deltas: [Int] = []
        if bgs.count > 3 {
            deltas.append(bgs[bgs.count - 1].sgv - bgs[bgs.count - 2].sgv)
            deltas.append(bgs[bgs.count - 2].sgv - bgs[bgs.count - 3].sgv)
            deltas.append(bgs[bgs.count - 3].sgv - bgs[bgs.count - 4].sgv)
        } else if bgs.count > 2 {
            deltas.append(bgs[bgs.count - 1].sgv - bgs[bgs.count - 2].sgv)
            deltas.append(bgs[bgs.count - 2].sgv - bgs[bgs.count - 3].sgv)
            // Set remainder to match the last delta we have
            deltas.append(bgs[bgs.count - 2].sgv - bgs[bgs.count - 3].sgv)
        } else if bgs.count > 1 {
            deltas.append(bgs[bgs.count - 1].sgv - bgs[bgs.count - 2].sgv)
            // Set remainder to match the last delta we have
            deltas.append(bgs[bgs.count - 1].sgv - bgs[bgs.count - 2].sgv)
            deltas.append(bgs[bgs.count - 1].sgv - bgs[bgs.count - 2].sgv)
        } else {
            // We only have 1 reading, set all to 0.
            deltas.append(0)
            deltas.append(0)
            deltas.append(0)
        }
        
        
        let currentBGTime = bgs[bgs.count - 1].date
//        var alarmTriggered = false
//        var numLoops = 0
//        checkQuietHours()
//        clearOldSnoozes()
        
        // Exit if all is snoozed
        // still send persistent notification with all snoozed
//        if UserDefaultsRepository.alertSnoozeAllIsSnoozed.value {
//            persistentNotification(bgTime: currentBGTime)
//            return
//        }
        // still send persistent notification if no alarms trigger and persistent notification is on
        self.persistentNotification(bgTime: currentBGTime)
        
    }
}

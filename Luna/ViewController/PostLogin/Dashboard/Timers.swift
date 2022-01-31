//
//  HomeBottomSheetVC+Extension1.swift
//  Luna
//
//  Created by Admin on 21/09/21.
//

import Foundation
import UIKit

extension BottomSheetVC {
    func restartAllTimers() {
        if !UserDefaultsRepository.shareUserName.value.isEmpty && !UserDefaultsRepository.sharePassword.value.isEmpty {
            if !bgTimer.isValid { self.startBGTimer(time: 10) }
            if !minAgoTimer.isValid { self.startMinAgoTimer(time: minAgoTimeInterval) }
        } else {
        }
    }
    // min Ago Timer
    func startMinAgoTimer(time: TimeInterval) {
        minAgoTimer = Timer.scheduledTimer(timeInterval: time,
                                           target: self,
                                           selector: #selector(self.minAgoTimerDidEnd(_:)),
                                           userInfo: nil,
                                           repeats: true)
    }
    // Updates Min Ago display
    @objc func minAgoTimerDidEnd(_ timer:Timer) {
        // print("min ago timer ended")
        if bgData.count > 0 {
            let bgSeconds = bgData.last!.date
            let now = Date().timeIntervalSince1970
            let secondsAgo = now - bgSeconds
            //MARK:- Importants
//            print("SecondsAgo:\(secondsAgo)")
            if secondsAgo >= 360 || (bgData.last!.sgv == -1){
                self.cgmDirectionlbl.text = ""
                self.cgmValueLbl.text = "--"
            }
            // Update Min Ago Displays
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .positional // Use the appropriate positioning for the current locale
            
            if secondsAgo < 300 {
                formatter.allowedUnits = [ .minute] // Units to display in the formatted string
            } else {
                formatter.allowedUnits = [ .minute, .second] // Units to display in the formatted string
            }
            //formatter.zeroFormattingBehavior = [ .pad ] // Pad with zeroes where appropriate for the locale
            let formattedDuration = formatter.string(from: secondsAgo)
            self.timeAgoLbl.text = (formattedDuration ?? "") + " min ago"
            latestMinAgoString = formattedDuration ?? ""
            if UserDefaultsRepository.shareUserName.value.isEmpty && UserDefaultsRepository.sharePassword.value.isEmpty{
                SystemInfoModel.shared.previousCgmReadingTime = "0"
            }else{
                SystemInfoModel.shared.previousCgmReadingTime = latestMinAgoString.isEmpty ? "0" : latestMinAgoString
            }
            latestMinAgoString += " min ago"
        } else {
            self.timeAgoLbl.text = ""
        }
        
    }
    
    func startBGTimer(time: TimeInterval =  60 * 5) {
        bgTimer = Timer.scheduledTimer(timeInterval: time,
                                               target: self,
                                               selector: #selector(self.bgTimerDidEnd(_:)),
                                               userInfo: nil,
                                               repeats: false)
    }
    
    @objc func bgTimerDidEnd(_ timer:Timer) {
        
        // reset timer to 1 minute if settings aren't entered
        if UserDefaultsRepository.shareUserName.value.isEmpty && UserDefaultsRepository.sharePassword.value.isEmpty && UserDefaultsRepository.url.value.isEmpty {
            startBGTimer(time: 5 * 60)
            return
        }
        var onlyPullLastRecord = false
        // Check if the last reading is less than 10 minutes ago
        // to only pull 1 reading if that's all we need
        if bgData.count > 0 {
            let now = dateTimeUtils.getNowTimeIntervalUTC()
            let lastReadingTime = bgData.last!.date
            let secondsAgo = now - lastReadingTime
            if secondsAgo < 10*60 {
                onlyPullLastRecord = true
            }
        }
        if UserDefaultsRepository.alwaysDownloadAllBG.value { onlyPullLastRecord = false }
        if !UserDefaultsRepository.shareUserName.value.isEmpty && !UserDefaultsRepository.sharePassword.value.isEmpty {
            webLoadDexShare(onlyPullLastRecord: onlyPullLastRecord)
        } else {
            webLoadNSBGData(onlyPullLastRecord: onlyPullLastRecord)
        }
        
    }
    
    // Device Status Timer
    // Runs to 5:10 after last reading timestamp
    // Failed or no update re-attempts after 10 second delay
    // Changes to 30 second increments after 7:00
    // Changes to 1 minute increments after 10:00
    // Changes to 5 minute increments after 20:00 stale data
    func startDeviceStatusTimer(time: TimeInterval =  60 * 5) {
//        deviceStatusTimer = Timer.scheduledTimer(timeInterval: time,
//                                               target: self,
//                                               selector: #selector(self.deviceStatusTimerDidEnd(_:)),
//                                               userInfo: nil,
//                                               repeats: false)
    }
    
    @objc func deviceStatusTimerDidEnd(_ timer:Timer) {
        // reset timer to 1 minute if settings aren't entered
        if UserDefaultsRepository.url.value == "" || UserDefaultsRepository.onlyDownloadBG.value {
            startDeviceStatusTimer(time: 60)
            return
        }
        if UserDefaultsRepository.url.value != "" {
//            webLoadNSDeviceStatus()
        }
    }
    
    // Profile Timer
    // Runs on 10 minute intervals
    // Pauses with stale BG data
    func startProfileTimer(time: TimeInterval =  60 * 10) {
//        profileTimer = Timer.scheduledTimer(timeInterval: time,
//                                               target: self,
//                                               selector: #selector(self.profileTimerDidEnd(_:)),
//                                               userInfo: nil,
//                                               repeats: false)
    }
    
    @objc func profileTimerDidEnd(_ timer:Timer) {
        
        // reset timer to 1 minute if settings aren't entered
        if UserDefaultsRepository.url.value == "" || UserDefaultsRepository.onlyDownloadBG.value {
            startProfileTimer(time: 60)
            return
        }
        
        if !isStaleData() && UserDefaultsRepository.url.value != "" {
            webLoadNSProfile()
            startProfileTimer()
        }
    }

}

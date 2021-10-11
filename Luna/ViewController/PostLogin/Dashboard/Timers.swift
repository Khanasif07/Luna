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
        if UserDefaultsRepository.shareUserName.value != "" && UserDefaultsRepository.sharePassword.value != "" {
            if !bgTimer.isValid { self.startBGTimer(time: 2) }
            if !minAgoTimer.isValid { self.startMinAgoTimer(time: minAgoTimeInterval) }
            // if !alarmTimer.isValid { self.startAlarmTimer(time: 30) }
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
    
    // Runs a 60 second timer when an alarm is snoozed
    // Prevents the alarm from triggering again while saving the snooze time to settings
    // End function needs nothing done
//    func startCheckAlarmTimer(time: TimeInterval = 60) {
//
//        checkAlarmTimer = Timer.scheduledTimer(timeInterval: time,
//                                               target: self,
//                                               selector: #selector(self.checkAlarmTimerDidEnd(_:)),
//                                               userInfo: nil,
//                                               repeats: false)
//    }
    
//    @objc func checkAlarmTimerDidEnd(_ timer:Timer) {
//    }
    
    // BG Timer
    // Runs to 5:10 after last reading timestamp
    // Failed or no reading re-attempts after 10 second delay
    // Changes to 30 second increments after 7:00
    // Changes to 1 minute increments after 10:00
    // Changes to 5 minute increments after 20:00 stale data
    func startBGTimer(time: TimeInterval =  60 * 5) {
        bgTimer = Timer.scheduledTimer(timeInterval: time,
                                               target: self,
                                               selector: #selector(self.bgTimerDidEnd(_:)),
                                               userInfo: nil,
                                               repeats: false)
    }
    
    private func getRangeValue(isShowPer: Bool = false)-> Double{
        if self.bgData.endIndex > 0 {
            let rangeArray = self.bgData.filter { (glucoseValue) -> Bool in
                return glucoseValue.sgv >= Int((UserDefaultsRepository.lowLine.value)) && glucoseValue.sgv <= Int((UserDefaultsRepository.highLine.value))
            }
            if isShowPer {
                let rangePercentValue = ((100 * (rangeArray.endIndex)) / (self.bgData.endIndex))
                return Double(rangePercentValue)
            } else {
                let rangePercentValue = (Double(rangeArray.endIndex) / Double(self.bgData.endIndex))
                return rangePercentValue
            }
        }
        return 0.0
    }
    
    @objc func bgTimerDidEnd(_ timer:Timer) {
        
        // reset timer to 1 minute if settings aren't entered
        if UserDefaultsRepository.shareUserName.value == "" && UserDefaultsRepository.sharePassword.value == "" && UserDefaultsRepository.url.value == "" {
            startBGTimer(time: 60)
            return
        }
        
        var onlyPullLastRecord = false
        
        // Check if the last reading is less than 10 minutes ago
        // to only pull 1 reading if that's all we need
        if bgData.count > 0 {
            //MARK:- Importants
//            let date = Date(timeIntervalSince1970: bgData.last!.date)
//            let cgmDate = Date(timeIntervalSince1970: AppUserDefaults.value(forKey: .latestCgmDate).doubleValue)
            print(bgData.last!.date - AppUserDefaults.value(forKey: .lastUpdatedCGMDate).doubleValue)
            let lastUpdatedDate = AppUserDefaults.value(forKey: .lastUpdatedCGMDate).doubleValue
//            print(Calendar.current.isDate(date, inSameDayAs: cgmDate))
//            if !Calendar.current.isDate(date, equalTo: cgmDate, toGranularity: .day) {
            if (bgData.last!.date - lastUpdatedDate) >= 86400 {
                AppUserDefaults.save(value: (self.bgData[self.bgData.count - 1].date), forKey: .lastUpdatedCGMDate)
                FirestoreController.updateLastUpdatedCGMDate(currentDate: (self.bgData[self.bgData.count - 1].date))
                FirestoreController.addBatchData(currentDate: String(bgData.last!.date), array: bgData) {
                    print(" Add Batch Data Commited successfully")
                    FirestoreController.addCgmDateData(currentDate: (self.bgData.last!.date), range: self.getRangeValue(isShowPer: true), startDate: (self.bgData.first!.date), endDate: (self.bgData.last!.date), insulin: 0)
                }
            }
            let now = dateTimeUtils.getNowTimeIntervalUTC()
            let lastReadingTime = bgData.last!.date
            let secondsAgo = now - lastReadingTime
            if secondsAgo < 10*60 {
                onlyPullLastRecord = true
            }
        }
        
        if UserDefaultsRepository.alwaysDownloadAllBG.value { onlyPullLastRecord = false }
        
        if UserDefaultsRepository.shareUserName.value != "" && UserDefaultsRepository.sharePassword.value != "" {
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
        deviceStatusTimer = Timer.scheduledTimer(timeInterval: time,
                                               target: self,
                                               selector: #selector(self.deviceStatusTimerDidEnd(_:)),
                                               userInfo: nil,
                                               repeats: false)
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
        profileTimer = Timer.scheduledTimer(timeInterval: time,
                                               target: self,
                                               selector: #selector(self.profileTimerDidEnd(_:)),
                                               userInfo: nil,
                                               repeats: false)
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
    
    // Alarm Timer
    // Run the alarm checker every 15 seconds
//    func startAlarmTimer(time: TimeInterval) {
//        alarmTimer = Timer.scheduledTimer(timeInterval: time,
//                                         target: self,
//                                         selector: #selector(self.alarmTimerDidEnd(_:)),
//                                         userInfo: nil,
//                                         repeats: true)
//
//    }
    
//    @objc func alarmTimerDidEnd(_ timer:Timer) {
//        if bgData.count > 0 {
//            self.checkAlarms(bgs: bgData)
//        }
//    }
}

//
//  HomeBottomSheetVC+Extension.swift
//  Luna
//
//  Created by Admin on 21/09/21.
//

import UIKit
import UserNotifications

extension BottomSheetVC {
    
    @objc func appMovedToBackground() {
        // Allow screen to turn off
        UIApplication.shared.isIdleTimerDisabled = false;
        
        // Cancel the current timer and start a fresh background timer using the settings value only if background task is enabled
        
        if UserDefaultsRepository.backgroundRefresh.value {
            backgroundTask.startBackgroundTask()
        }
        
    }

    @objc func appCameToForeground() {
        // reset screenlock state if needed
        UIApplication.shared.isIdleTimerDisabled = UserDefaultsRepository.screenlockSwitchState.value;
        
        // Cancel the background tasks, start a fresh timer
        if UserDefaultsRepository.backgroundRefresh.value {
            backgroundTask.stopBackgroundTask()
        }
        restartAllTimers()

    }
    
    //update Min Ago Text. We need to call this separately because it updates between readings
    func updateMinAgo(){
        if bgData.count > 0 {
            let deltaTime = (TimeInterval(Date().timeIntervalSince1970)-bgData[bgData.count - 1].date) / 60
            minAgoBG = Double(TimeInterval(Date().timeIntervalSince1970)-bgData[bgData.count - 1].date)
            self.timeAgoLbl.text = String(Int(deltaTime)) + " min ago"
            latestMinAgoString = String(Int(deltaTime)) + " min ago"
        } else {
            self.timeAgoLbl.text = ""
            latestMinAgoString = ""
        }
    }
    
    //Clear the info data before next pull. This ensures we aren't displaying old data if something fails.
    func clearLastInfoData(index: Int){
//        tableData[index].value = ""
    }

    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    func setBGTextColor() {
        if bgData.count > 0 {
            let latestBG = bgData[bgData.count - 1].sgv
            var color: NSUIColor = NSUIColor.label
            if UserDefaultsRepository.colorBGText.value {
                if Float(latestBG) >= UserDefaultsRepository.highLine.value {
                    color = NSUIColor.systemYellow
                } else if Float(latestBG) <= UserDefaultsRepository.lowLine.value {
                    color = NSUIColor.systemRed
                } else {
                    color = AppColors.appGreenColor
                }
            }
                self.cgmValueLbl.textColor = color
                self.cgmDirectionlbl.textColor = color
        }
    }
    
    func bgDirectionGraphic(_ value:String)->String
    {
        let 
        graphics:[String:String]=["Flat":"→","DoubleUp":"↑↑","SingleUp":"↑","FortyFiveUp":"↗","FortyFiveDown":"↘︎","SingleDown":"↓","DoubleDown":"↓↓","None":"-","NONE":"-","NOT COMPUTABLE":"-","RATE OUT OF RANGE":"-", "": "-"]
        return graphics[value]!
    }
    
    func persistentNotification(body: String){
//        if UserDefaultsRepository.persistentNotification.value && bgTime > UserDefaultsRepository.persistentNotificationLastBGTime.value && bgData.count > 0 {
        self.sendNotification(self, bgVal: bgUnits.toDisplayUnits(String(bgData[bgData.count - 1].sgv)), directionVal: latestDirectionString,body: body)
//        }
    }
    
    func sendNotification(_ sender: Any, bgVal: String, directionVal: String,body: String) {
        
        UNUserNotificationCenter.current().delegate = self
        
        let content = UNMutableNotificationContent()
        content.title = ""
        content.subtitle = ""
        content.categoryIdentifier = "category"
        content.body = body
//        content.badge = 1
        // This is needed to trigger vibrate on watch and phone
        // TODO:
        // See if we can use .Critcal
        // See if we should use this method instead of direct sound player
        content.sound = .defaultCritical
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        let action = UNNotificationAction(identifier: "snooze", title: "Snooze", options: [])
        let category = UNNotificationCategory(identifier: "category", actions: [action], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
//    }
}
    
    
    // General Notifications
    
    func sendGeneralNotification(_ sender: Any, title: String, subtitle: String, body: String, timer: TimeInterval) {
        
        UNUserNotificationCenter.current().delegate = self
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.categoryIdentifier = "noAction"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timer, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

    }
}


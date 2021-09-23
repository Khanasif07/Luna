//
//  HomeBottomSheetVC+Extension.swift
//  Luna
//
//  Created by Admin on 21/09/21.
//

import UIKit
import Charts
import EventKit
import UserNotifications

extension BottomSheetVC : UNUserNotificationCenterDelegate{
    
    @objc func appMovedToBackground() {
        // Allow screen to turn off
        UIApplication.shared.isIdleTimerDisabled = false;
        
        // We want to always come back to the home screen
//        tabBarController?.selectedIndex = 0
        
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
        if UserDefaultsRepository.debugLog.value {
            print("Update min ago text")
        }
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
    
    func updateBadge(val: Int) {
        DispatchQueue.main.async {
        if UserDefaultsRepository.appBadge.value {
            let latestBG = String(val)
            UIApplication.shared.applicationIconBadgeNumber = Int(bgUnits.removePeriodForBadge(bgUnits.toDisplayUnits(latestBG))) ?? val
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
//        if UserDefaultsRepository.debugLog.value { self.writeDebugLog(value: "updated badge") }
        }
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
        let //graphics:[String:String]=["Flat":"\u{2192}","DoubleUp":"\u{21C8}","SingleUp":"\u{2191}","FortyFiveUp":"\u{2197}\u{FE0E}","FortyFiveDown":"\u{2198}\u{FE0E}","SingleDown":"\u{2193}","DoubleDown":"\u{21CA}","None":"-","NOT COMPUTABLE":"-","RATE OUT OF RANGE":"-"]
        graphics:[String:String]=["Flat":"→","DoubleUp":"↑↑","SingleUp":"↑","FortyFiveUp":"↗","FortyFiveDown":"↘︎","SingleDown":"↓","DoubleDown":"↓↓","None":"-","NONE":"-","NOT COMPUTABLE":"-","RATE OUT OF RANGE":"-", "": "-"]
        return graphics[value]!
    }
    
    // Test code to save an image of graph for viewing on watch
//    func saveChartImage() {
////        if let cell = self.mainTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? BottomSheetChartCell{
//            var originalColor = self.cgmChartView.backgroundColor
////            self.cgmChartView.backgroundColor = NSUIColor.black
//            guard var image = self.cgmChartView.getChartImage(transparent: true) else {
////                self.cgmChartView.backgroundColor = originalColor
//                return }
////            var newImage = image.resizeImage(448.0, landscape: false, opaque: false, contentMode: .scaleAspectFit)
////            self.cgmChartView.backgroundColor = originalColor
////        }
//
//
//        createAlbums(name1: "Loop Follow", name2: "Loop Follow Old")
//        if let collection1 = fetchAssetCollection("Loop Follow"), let collection2 = fetchAssetCollection("Loop Follow Old") {
//            deleteExistingImagesFromCollection(collection: collection1)
////            saveImageToAssetCollection(image, collection1: collection1, collection2: collection2)
//        }
//
//
//    }
    
//    func createAlbums(name1: String, name2: String) {
//        if let collection1 = fetchAssetCollection(name1) {
//        } else {
//            // Album does not exist, create it and attempt to save the image
//            PHPhotoLibrary.shared().performChanges({
//                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name1)
//            }, completionHandler: { (success: Bool, error: Error?) in
//                guard success == true && error == nil else {
//                    NSLog("Could not create the album")
//                    if let err = error {
//                        NSLog("Error: \(err)")
//                    }
//                    return
//                }
//
//                if let newCollection1 = self.fetchAssetCollection(name1) {
//                }
//            })
//        }
//
//        if let collection2 = fetchAssetCollection(name2) {
//        } else {
//            // Album does not exist, create it and attempt to save the image
//            PHPhotoLibrary.shared().performChanges({
//                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name2)
//            }, completionHandler: { (success: Bool, error: Error?) in
//                guard success == true && error == nil else {
//                    NSLog("Could not create the album")
//                    if let err = error {
//                        NSLog("Error: \(err)")
//                    }
//                    return
//                }
//
//                if let newCollection2 = self.fetchAssetCollection(name2) {
//                }
//            })
//        }
//    }
    
//    func fetchAssetCollection(_ name: String) -> PHAssetCollection? {
//
//        let fetchOption = PHFetchOptions()
//        fetchOption.predicate = NSPredicate(format: "title == '" + name + "'")
//
//        let fetchResult = PHAssetCollection.fetchAssetCollections(
//            with: PHAssetCollectionType.album,
//            subtype: PHAssetCollectionSubtype.albumRegular,
//            options: fetchOption)
//
//        return fetchResult.firstObject
//    }
    
//    func deleteOldImages() {
//        if let collection = fetchAssetCollection("Loop Follow Old") {
//            let library = PHPhotoLibrary.shared()
//            library.performChanges({
//                let fetchOptions = PHFetchOptions()
//                let allPhotos = PHAsset.fetchAssets(in: collection, options: .none)
//                PHAssetChangeRequest.deleteAssets(allPhotos)
//            }, completionHandler: { (success: Bool, error: Error?) in
//                guard success == true && error == nil else {
//                    NSLog("Could not delete the image")
//                    if let err = error {
//                        NSLog("Error: " + err.localizedDescription)
//                    }
//                    return
//                }
//            })
//        }
//
////        self.sendGeneralNotification(self, title: "Watch Face Cleanup", subtitle: "", body: "Delete old watch face graph images", timer: 86400)
//
//
//    }
    
//    func deleteExistingImagesFromCollection(collection: PHAssetCollection) {
//
//        // This code removes existing photos from collection but does not delete them
//        if collection.estimatedAssetCount < 1 { return }
//
//        PHPhotoLibrary.shared().performChanges( {
//
//            if let request = PHAssetCollectionChangeRequest(for: collection) {
//                request.removeAssets(at: [0])
//            }
//
//        }, completionHandler: { (success: Bool, error: Error?) in
//            guard success == true && error == nil else {
//                NSLog("Could not delete the image")
//                if let err = error {
//                    NSLog("Error: " + err.localizedDescription)
//                }
//                return
//            }
//        })
//    }

//    func saveImageToAssetCollection(_ image: UIImage, collection1: PHAssetCollection, collection2: PHAssetCollection) {
//
//        PHPhotoLibrary.shared().performChanges({
//
//            let creationRequest = PHAssetCreationRequest.creationRequestForAsset(from: image)
//            if let request = PHAssetCollectionChangeRequest(for: collection1),
//               let placeHolder = creationRequest.placeholderForCreatedAsset {
//                request.addAssets([placeHolder] as NSFastEnumeration)
//            }
//            if let request2 = PHAssetCollectionChangeRequest(for: collection2),
//               let placeHolder2 = creationRequest.placeholderForCreatedAsset {
//                request2.addAssets([placeHolder2] as NSFastEnumeration)
//            }
//        }, completionHandler: { (success: Bool, error: Error?) in
//            guard success == true && error == nil else {
//                NSLog("Could not save the image")
//                if let err = error {
//                    NSLog("Error: " + err.localizedDescription)
//                }
//                return
//            }
//        })
//    }
    
    // Write calendar
//    func writeCalendar() {
////        if UserDefaultsRepository.debugLog.value { self.writeDebugLog(value: "Write calendar start") }
//        store.requestAccess(to: .event) {(granted, error) in
//            if !granted { return }
//
//            if UserDefaultsRepository.calendarIdentifier.value == "" { return }
//
//            if self.bgData.count < 1 { return }
//
//            // This lets us fire the method to write Min Ago entries only once a minute starting after 6 minutes but allows new readings through
//            if self.lastCalDate == self.bgData[self.bgData.count - 1].date
//                && (self.calTimer.isValid || (dateTimeUtils.getNowTimeIntervalUTC() - self.lastCalDate) < 360) {
//                return
//            }
//
//                // Create Event info
//                let deltaBG = self.bgData[self.bgData.count - 1].sgv -  self.bgData[self.bgData.count - 2].sgv as Int
//                let deltaTime = (TimeInterval(Date().timeIntervalSince1970) - self.bgData[self.bgData.count - 1].date) / 60
//                var deltaString = ""
//                if deltaBG < 0 {
//                    deltaString = bgUnits.toDisplayUnits(String(deltaBG))
//                }
//                else
//                {
//                    deltaString = "+" + bgUnits.toDisplayUnits(String(deltaBG))
//                }
//                let direction = self.bgDirectionGraphic(self.bgData[self.bgData.count - 1].direction ?? "")
//
//                var eventStartDate = Date(timeIntervalSince1970: self.bgData[self.bgData.count - 1].date)
////                if UserDefaultsRepository.debugLog.value { self.writeDebugLog(value: "Calendar start date") }
//                var eventEndDate = eventStartDate.addingTimeInterval(60 * 10)
//                var  eventTitle = UserDefaultsRepository.watchLine1.value + "\n" + UserDefaultsRepository.watchLine2.value
//                eventTitle = eventTitle.replacingOccurrences(of: "%BG%", with: bgUnits.toDisplayUnits(String(self.bgData[self.bgData.count - 1].sgv)))
//                eventTitle = eventTitle.replacingOccurrences(of: "%DIRECTION%", with: direction)
//                eventTitle = eventTitle.replacingOccurrences(of: "%DELTA%", with: deltaString)
//                if self.currentOverride != 1.0 {
//                    let val = Int( self.currentOverride*100)
//                    // let overrideText = String(format:"%f1", self.currentOverride*100)
//                    let text = String(val) + "%"
//                    eventTitle = eventTitle.replacingOccurrences(of: "%OVERRIDE%", with: text)
//                } else {
//                    eventTitle = eventTitle.replacingOccurrences(of: "%OVERRIDE%", with: "")
//                }
//                eventTitle = eventTitle.replacingOccurrences(of: "%LOOP%", with: self.latestLoopStatusString)
//                var minAgo = ""
//                if deltaTime > 9 {
//                    // write old BG reading and continue pushing out end date to show last entry
//                    minAgo = String(Int(deltaTime)) + " min"
//                    eventEndDate = eventStartDate.addingTimeInterval((60 * 10) + (deltaTime * 60))
//                }
//                var cob = "0"
//                if self.latestCOB != "" {
//                    cob = self.latestCOB
//                }
//                var basal = "~"
//                if self.latestBasal != "" {
//                    basal = self.latestBasal
//                }
//                var iob = "0"
//                if self.latestIOB != "" {
//                    iob = self.latestIOB
//                }
//                eventTitle = eventTitle.replacingOccurrences(of: "%MINAGO%", with: minAgo)
//                eventTitle = eventTitle.replacingOccurrences(of: "%IOB%", with: iob)
//                eventTitle = eventTitle.replacingOccurrences(of: "%COB%", with: cob)
//                eventTitle = eventTitle.replacingOccurrences(of: "%BASAL%", with: basal)
//
//
//
//                // Delete Events from last 2 hours and 2 hours in future
//                var deleteStartDate = Date().addingTimeInterval(-60*60*2)
//                var deleteEndDate = Date().addingTimeInterval(60*60*2)
//                // guard solves for some ios upgrades removing the calendar
//                guard let deleteCalendar = self.store.calendar(withIdentifier: UserDefaultsRepository.calendarIdentifier.value) as? EKCalendar else { return }
//                var predicate2 = self.store.predicateForEvents(withStart: deleteStartDate, end: deleteEndDate, calendars: [deleteCalendar])
//                var eVDelete = self.store.events(matching: predicate2) as [EKEvent]?
//                if eVDelete != nil {
//                    for i in eVDelete! {
//                        do {
//                            try self.store.remove(i, span: EKSpan.thisEvent, commit: true)
//                            //if UserDefaultsRepository.debugLog.value { self.writeDebugLog(value: "Calendar Delete") }
//                        } catch let error {
//                            //if UserDefaultsRepository.debugLog.value { self.writeDebugLog(value: "Error - Calendar Delete") }
//                            print(error)
//                        }
//                    }
//                }
//
//                // Write New Event
//                var event = EKEvent(eventStore: self.store)
//                event.title = eventTitle
//                event.startDate = eventStartDate
//                event.endDate = eventEndDate
//                event.calendar = self.store.calendar(withIdentifier: UserDefaultsRepository.calendarIdentifier.value)
//                do {
//                    try self.store.save(event, span: .thisEvent, commit: true)
//                    self.calTimer.invalidate()
//                    self.startCalTimer(time: (60 * 1))
//
//                    self.lastCalDate = self.bgData[self.bgData.count - 1].date
//                    //if UserDefaultsRepository.debugLog.value { self.writeDebugLog(value: "Calendar Write: " + eventTitle) }
//                    //UserDefaultsRepository.savedEventID.value = event.eventIdentifier //save event id to access this particular event later
//                } catch {
//                    // Display error to user
//                    //if UserDefaultsRepository.debugLog.value { self.writeDebugLog(value: "Error: Calendar Write") }
//                }
//
////            if UserDefaultsRepository.saveImage.value {
////                DispatchQueue.main.async {
////               self.saveChartImage()
////                }
////            }
//        }
//    }
    
    
    func persistentNotification(bgTime: TimeInterval){
        if UserDefaultsRepository.persistentNotification.value && bgTime > UserDefaultsRepository.persistentNotificationLastBGTime.value && bgData.count > 0 {
            self.sendNotification(self, bgVal: bgUnits.toDisplayUnits(String(bgData[bgData.count - 1].sgv)), directionVal: latestDirectionString, deltaVal: bgUnits.toDisplayUnits(String(latestDeltaString)), minAgoVal: latestMinAgoString, alertLabelVal: "Latest BG")
        }
    }
    
    func sendNotification(_ sender: Any, bgVal: String, directionVal: String, deltaVal: String, minAgoVal: String, alertLabelVal: String) {
        
        UNUserNotificationCenter.current().delegate = self
        
        let content = UNMutableNotificationContent()
        content.title = alertLabelVal
        content.subtitle += bgVal + " "
        content.subtitle += directionVal + " "
        content.subtitle += deltaVal
        content.categoryIdentifier = "category"
        // This is needed to trigger vibrate on watch and phone
        // TODO:
        // See if we can use .Critcal
        // See if we should use this method instead of direct sound player
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        let action = UNNotificationAction(identifier: "snooze", title: "Snooze", options: [])
        let category = UNNotificationCategory(identifier: "category", actions: [action], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    func writeDebugLog(value: String) {
        DispatchQueue.main.async {
            var logText = "\n" + dateTimeUtils.printNow() + " - " + value
            print(logText)
//            guard let debug = self.tabBarController!.viewControllers?[2] as? SnoozeViewController else { return }
//            if debug.debugTextView.text.lengthOfBytes(using: .utf8) > 20000 {
//                debug.debugTextView.text = ""
//                    }
//            debug.debugTextView.text += logText
        }

        
        
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


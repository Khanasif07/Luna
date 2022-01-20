//
//  NightScout.swift
//  Luna
//
//  Created by Admin on 21/09/21.
//

import Foundation
import AVFoundation

extension  BottomSheetVC{
    
    func isStaleData() -> Bool {
        if bgData.count > 0 {
            let now = dateTimeUtils.getNowTimeIntervalUTC()
            let lastReadingTime = bgData.last!.date
            let secondsAgo = now - lastReadingTime
            if secondsAgo >= 20*60 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    
    // Dex Share Web Call
    func webLoadDexShare(onlyPullLastRecord: Bool = false) {
        var count = 288
        if onlyPullLastRecord { count = 1 }
        dexShare?.fetchData(count) { (err, result) -> () in
            
            // TODO: add error checking
             if(err == nil) {
                let data = result!
                self.ProcessNSBGData(data: data, onlyPullLastRecord: onlyPullLastRecord)
            } else {
                if let lastData = self.bgData.last{
                    if lastData.date < dateTimeUtils.getNowTimeIntervalUTC() && dateTimeUtils.getNowTimeIntervalUTC() - lastData.date > 5 * 60{
                        self.bgData.removeFirst()
                        SystemInfoModel.shared.cgmData?.removeFirst()
                        self.bgData.append(ShareGlucoseData(sgv: -1, date: lastData.date + 300.0, direction: lastData.direction ?? "", insulin: lastData.insulin ?? ""))
                        SystemInfoModel.shared.cgmData?.append(ShareGlucoseData(sgv: -1, date: lastData.date + 300.0, direction: lastData.direction ?? "", insulin: lastData.insulin ?? ""))
                        DispatchQueue.main.async {
                        self.updateBGGraph()
                        }
                    }
                }
                guard let actualError = err else { return }
                switch actualError {
                case .dataError(reason: let luna):
                    print(luna)
                    self.errMessage = luna
                case .loginError(errorCode: let luna):
                    print(luna)
                    self.errMessage = luna
                case .httpError(let err):
                    print(err.localizedDescription)
                    self.errMessage = err.localizedDescription
                default:
                    print(actualError.localizedDescription)
                    self.errMessage = actualError.localizedDescription
                }
                CommonFunctions.showToastWithMessage(self.errMessage)
                // If we get an error, immediately try to pull NS BG Data
                self.webLoadNSBGData(onlyPullLastRecord: onlyPullLastRecord)
                
//                if globalVariables.dexVerifiedAlert < dateTimeUtils.getNowTimeIntervalUTC() + 300 {
//                    globalVariables.dexVerifiedAlert = dateTimeUtils.getNowTimeIntervalUTC()
////                    DispatchQueue.main.async {
//                        //                        self.sendNotification(title: "Dexcom Share Error", body: "Please double check user name and password, internet connection, and sharing status.")
////                    }
//                }
            }
        }
    }
    
    // NS BG Data Web call
    func webLoadNSBGData(onlyPullLastRecord: Bool = false) {
        // Set the count= in the url either to pull 24 hours or only the last record
        var points = "1"
        if !onlyPullLastRecord {
            points = String(self.graphHours * 12 + 1)
        }
        
        // URL processor
        var urlBGDataPath: String = UserDefaultsRepository.url.value + "/api/v1/entries/sgv.json?"
        if token.isEmpty {
            urlBGDataPath = urlBGDataPath + "count=" + points
        } else {
            urlBGDataPath = urlBGDataPath + "token=" + token + "&count=" + points
        }
        guard let urlBGData = URL(string: urlBGDataPath) else {
//            if globalVariables.nsVerifiedAlert < dateTimeUtils.getNowTimeIntervalUTC() + 300 {
//                globalVariables.nsVerifiedAlert = dateTimeUtils.getNowTimeIntervalUTC()
//                //self.sendNotification(title: "Nightscout Error", body: "Please double check url, token, and internet connection. This may also indicate a temporary Nightscout issue")
//            }
            DispatchQueue.main.async {
                if self.bgTimer.isValid {
                    self.bgTimer.invalidate()
                }
                self.startBGTimer(time: 60)
            }
            return
        }
        var request = URLRequest(url: urlBGData)
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
        // Downloader
        let getBGTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
//                if globalVariables.nsVerifiedAlert < dateTimeUtils.getNowTimeIntervalUTC() + 300 {
//                    globalVariables.nsVerifiedAlert = dateTimeUtils.getNowTimeIntervalUTC()
//                    self.sendNotification(title: "Nightscout Error", body: "Please double check url, token, and internet connection. This may also indicate a temporary Nightscout issue")
//                }
                DispatchQueue.main.async {
                    if self.bgTimer.isValid {
                        self.bgTimer.invalidate()
                    }
                    self.startBGTimer(time: 60)
                }
                return
                
            }
            guard let data = data else {
//                if globalVariables.nsVerifiedAlert < dateTimeUtils.getNowTimeIntervalUTC() + 300 {
//                    globalVariables.nsVerifiedAlert = dateTimeUtils.getNowTimeIntervalUTC()
//                    //self.sendNotification(title: "Nightscout Error", body: "Please double check url, token, and internet connection. This may also indicate a temporary Nightscout issue")
//                }
                DispatchQueue.main.async {
                    if self.bgTimer.isValid {
                        self.bgTimer.invalidate()
                    }
                    self.startBGTimer(time: 60)
                }
                return
                
            }
            
            let decoder = JSONDecoder()
            let entriesResponse = try? decoder.decode([ShareGlucoseData].self, from: data)
            if let entriesResponse = entriesResponse {
                DispatchQueue.main.async {
                    // trigger the processor for the data after downloading.
                    self.ProcessNSBGData(data: entriesResponse, onlyPullLastRecord: onlyPullLastRecord, isNS: true)
                    
                }
            } else {
//                if globalVariables.nsVerifiedAlert < dateTimeUtils.getNowTimeIntervalUTC() + 300 {
//                    globalVariables.nsVerifiedAlert = dateTimeUtils.getNowTimeIntervalUTC()
//                    //self.sendNotification(title: "Nightscout Failure", body: "Please double check url, token, and internet connection. This may also indicate a temporary Nightscout issue")
//                }
                DispatchQueue.main.async {
                    if self.bgTimer.isValid {
                        self.bgTimer.invalidate()
                    }
                    self.startBGTimer(time: 60)
                }
                return
                
            }
        }
        getBGTask.resume()
    }
    
    // NS BG Data Response processor
    func ProcessNSBGData(data: [ShareGlucoseData], onlyPullLastRecord: Bool, isNS: Bool = false){
        var pullDate = data[data.count - 1].date
        if isNS {
            pullDate = data[data.count - 1].date / 1000
            pullDate.round(FloatingPointRoundingRule.toNearestOrEven)
        }
        
        var latestDate = data[0].date
        if isNS {
            latestDate = data[0].date / 1000
            latestDate.round(FloatingPointRoundingRule.toNearestOrEven)
        }
        
        let now = dateTimeUtils.getNowTimeIntervalUTC()
        if !isNS && (latestDate + 330) < now {
            //
            if let lastData = self.bgData.last{
                if lastData.date < dateTimeUtils.getNowTimeIntervalUTC() && dateTimeUtils.getNowTimeIntervalUTC() - lastData.date > 5 * 60{
                    self.bgData.removeFirst()
                    SystemInfoModel.shared.cgmData?.removeFirst()
                    self.bgData.append(ShareGlucoseData(sgv: -1, date: lastData.date + 300.0, direction: lastData.direction ?? "", insulin: lastData.insulin ?? ""))
                    SystemInfoModel.shared.cgmData?.append(ShareGlucoseData(sgv: -1, date: lastData.date + 300.0, direction: lastData.direction ?? "", insulin: lastData.insulin ?? ""))
                    DispatchQueue.main.async {
                    self.updateBGGraph()
                    }
                }
            }
            //
            webLoadNSBGData(onlyPullLastRecord: onlyPullLastRecord)
            CommonFunctions.showToastWithMessage("Dexcom CGM data unavailable")
            //MARK:- TO DO
            return
        }
        
        // Start the BG timer based on the reading
        let secondsAgo = now - latestDate
        
        DispatchQueue.main.async {
            // if reading is overdue over: 20:00, re-attempt every 5 minutes
            if secondsAgo >= (20 * 60) {
                self.startBGTimer(time: (5 * 60))
                print("##### started 5 minute bg timer")
                
                // if the reading is overdue: 10:00-19:59, re-attempt every minute
            } else if secondsAgo >= (10 * 60) {
                self.startBGTimer(time: 60)
                print("##### started 1 minute bg timer")
                
                // if the reading is overdue: 7:00-9:59, re-attempt every 30 seconds
            } else if secondsAgo >= (7 * 60) {
                self.startBGTimer(time: 30)
                print("##### started 30 second bg timer")
                
                // if the reading is overdue: 5:00-6:59 re-attempt every 10 seconds
            } else if secondsAgo >= (5 * 60) {
                self.startBGTimer(time: 10)
                print("##### started 10 second bg timer")
                
                // We have a current reading. Set timer to 5:10 from last reading
            } else {
                self.startBGTimer(time: 300 - secondsAgo + Double(UserDefaultsRepository.bgUpdateDelay.value))
                let timerVal = 310 - secondsAgo
                print("##### started 5:10 bg timer: \(timerVal)")
            }
        }
        
        // If we already have data, we're going to pop it to the end and remove the first. If we have old or no data, we'll destroy the whole array and start over. This is simpler than determining how far back we need to get new data from in case Dex back-filled readings
        if !onlyPullLastRecord {
            bgData.removeAll()
            SystemInfoModel.shared.cgmData?.removeAll()
        } else if bgData[bgData.count - 1].date != pullDate {
            bgData.removeFirst()
            SystemInfoModel.shared.cgmData?.removeFirst()
//            if data.count > 0 && UserDefaultsRepository.speakBG.value {
//                speakBG(sgv: data[data.count - 1].sgv)
//            }
        } else {
//            if data.count > 0 {
//              self.updateBadge(val: data[data.count - 1].sgv)
//            }
            return
        }
        
        // loop through the data so we can reverse the order to oldest first for the graph and convert the NS timestamp to seconds instead of milliseconds. Makes date comparisons easier for everything else.
        for i in 0..<data.count{
            var dateString = data[data.count - 1 - i].date
            if isNS {
                dateString = data[data.count - 1 - i].date / 1000
                dateString.round(FloatingPointRoundingRule.toNearestOrEven)
            }
            if dateString >= dateTimeUtils.getTimeInterval24HoursAgo() {
                let reading = ShareGlucoseData(sgv: data[data.count - 1 - i].sgv, date: dateString, direction: data[data.count - 1 - i].direction ?? "")
                bgData.append(reading)
            }
            
        }
        //MARK:- Important
        SystemInfoModel.shared.cgmData = bgData
        //
        print(SystemInfoModel.shared.dosingData)
        if SystemInfoModel.shared.dosingData.isEmpty{
            if let fetchedData = UserDefaults.standard.data(forKey: ApiKey.dosingHistoryData) {
                let fetchedDosingData = try! JSONDecoder().decode([DosingHistory].self, from: fetchedData)
                if !fetchedDosingData.isEmpty{
                    SystemInfoModel.shared.dosingData = fetchedDosingData.filter({ (now - $0.sessionTime <= 86400.0)})}
            }
        }
        SystemInfoModel.shared.dosingData.forEach { (dosingHistory) in
           if let indexx = SystemInfoModel.shared.cgmData?.firstIndex(where: { (bgData) -> Bool in
            bgData.date == dosingHistory.sessionTime
           }){
            SystemInfoModel.shared.cgmData?[indexx].insulin = dosingHistory.insulin
            bgData[indexx].insulin = dosingHistory.insulin
           }
        }
        //
        //MARK:- Important
        let insulinDataArray = self.bgData.filter { (bgData) -> Bool in
            return bgData.insulin == "0.25" || bgData.insulin == "0.5" || bgData.insulin == "0.75"
        }
        SystemInfoModel.shared.insulinData = SystemInfoModel.shared.cgmData?.filter({$0.insulin == "0.5"}) ?? []
        SystemInfoModel.shared.insulinData = SystemInfoModel.shared.insulinData.reversed()
        viewUpdateNSBG(isNS: isNS)
        let customXAxisRender = XAxisCustomRenderer(viewPortHandler: self.cgmChartView.viewPortHandler,
                                                    xAxis: cgmChartView.xAxis,
                                                    transformer: self.cgmChartView.getTransformer(forAxis: .left),
                                                    cgmData: self.bgData,insulinData: insulinDataArray)
        self.cgmChartView.xAxisRenderer = customXAxisRender
    }
    
    // NS BG Data Front end updater
    func viewUpdateNSBG (isNS: Bool) {
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
            let entries = self.bgData
            if entries.count < 1 { return }
            self.updateBGGraph()
            //            self.updateStats()
            
            let latestEntryi = entries.count - 1
            let latestBG = entries[latestEntryi].sgv
            let priorBG = entries[latestEntryi - 1].sgv
            _ = latestBG - priorBG as Int
            let latestDate = entries[latestEntryi].date
            //MARK: - Important
            self.cgmValueLbl.text = bgUnits.toDisplayUnits(String(latestBG),true)
            self.setBGTextColor()
            //MARK:- Importants
            //Send time stamps to Luna Hardware
//            let randomBGValue = Int.random(in: 275..<325)
//            let updatedBG = latestBG > 120 ? randomBGValue : latestBG + 100
            BleManager.sharedInstance.writeCGMTimeStampValue(value: bgUnits.toSendCGMTimeStampsUnits(String(latestDate), String(latestBG)))
//            BleManager.sharedInstance.writeCGMTimeStampValue(value: bgUnits.toSendCGMTimeStampsUnits(String(latestDate), String(randomBGValue)))
            if let directionBG = entries[latestEntryi].direction {
                self.cgmDirectionlbl.text = self.bgDirectionGraphic(directionBG)
                self.latestDirectionString = self.bgDirectionGraphic(directionBG)
            }
            else{
                self.cgmDirectionlbl.text = ""
                self.latestDirectionString = ""
            }
            //            self.updateBadge(val: latestBG)
        }
        
    }
    
    // NS Profile Web Call
    func webLoadNSProfile() {
        let urlUser = UserDefaultsRepository.url.value
        var urlString = urlUser + "/api/v1/profile/current.json"
        if token != "" {
            urlString = urlUser + "/api/v1/profile/current.json?token=" + token
        }
        
        let escapedAddress = urlString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        guard let url = URL(string: escapedAddress!) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            
            
            let json = try? JSONSerialization.jsonObject(with: data) as? Dictionary<String, Any>
            
            if let json = json {
                DispatchQueue.main.async {
                    print(json)
                    //                    self.updateProfile(jsonDeviceStatus: json)
                }
            } else {
                return
            }
        }
        task.resume()
    }
    
    func clearOldTempBasal(){
    }
    
    func clearOldBolus(){
    }
    
    func clearOldCarb(){
    }
    
    func clearOldBGCheck(){
        self.bgCheckData.removeAll()
       // self.updateBGCheckGraph()
    }
    
    func clearOldOverride(){
    }
    
    func clearOldSuspend(){
    }
    
    func clearOldResume(){
    }
    
    func clearOldSensor(){
    }
    
    func clearOldNotes(){}
    
    // NS BG Check Response Processor
    func processNSBGCheck(entries: [[String:AnyObject]]) {
        // because it's a small array, we're going to destroy and reload every time.
        bgCheckData.removeAll()
        for i in 0..<entries.count {
            let currentEntry = entries[entries.count - 1 - i] as [String : AnyObject]?
            var date: String
            if currentEntry?["timestamp"] != nil {
                date = currentEntry?["timestamp"] as! String
            } else if currentEntry?["created_at"] != nil {
                date = currentEntry?["created_at"] as! String
            } else {
                return
            }
            // Fix for FreeAPS milliseconds in timestamp
            var strippedZone = String(date.dropLast())
            strippedZone = strippedZone.components(separatedBy: ".")[0]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let dateString = dateFormatter.date(from: strippedZone)
            let dateTimeStamp = dateString!.timeIntervalSince1970
            
            guard let sgv = currentEntry?["glucose"] as? Int else {
                continue
            }
            
            if dateTimeStamp < (dateTimeUtils.getNowTimeIntervalUTC() + (60 * 60)) {
                // Make the dot
                //let dot = ShareGlucoseData(value: Double(carbs), date: Double(dateTimeStamp), sgv: Int(sgv.sgv))
                let dot = ShareGlucoseData(sgv: sgv, date: Double(dateTimeStamp), direction: "")
                bgCheckData.append(dot)
            }
        }
        
    }
    
    func speakBG(sgv: Int) {
        let speechSynthesizer = AVSpeechSynthesizer()
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: "Current BG is " + bgUnits.toDisplayUnits(String(sgv)))
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(speechUtterance)
    }
}

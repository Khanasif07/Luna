//
//  CGMConnectedVC.swift
//  Luna
//
//  Created by Admin on 07/07/21.


import UIKit
import Firebase
import AVFoundation

class CGMConnectedVC: UIViewController {
    
    // MARK: - IBOutles
    //===========================
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var okBtn: AppButton!
    @IBOutlet weak var ValueLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var directionText : UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Variables
    //===========================
    var vcObj:UIViewController = UIViewController()
    var cgmConnectedSuccess: ((UIButton, String)->())?
    var cgmData : String = ""
    var directionString : String = ""
    
    var dexShare: ShareClient?;
    var bgData: [ShareGlucoseData] = []
    var bgTimer = Timer()
    var graphHours:Int = 24
    var latestDirectionString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
        overrideUserInterfaceStyle = .light
        }
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        outerView.round(radius: 10.0)
        outerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        self.okBtn.round(radius: 10.0)
        self.okBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            if userInterfaceStyle == .dark{
                return .darkContent
            }else{
                return .darkContent
            }
        } else {
            return .lightContent
        }
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func okBtnTapped(_ sender: AppButton) {
        UserDefaultsRepository.shareUserName.value = AppUserDefaults.value(forKey: .shareUserName).stringValue
        UserDefaultsRepository.sharePassword.value = AppUserDefaults.value(forKey: .sharePassword).stringValue
        FirestoreController.updateDexcomCreds(shareUserName: AppUserDefaults.value(forKey: .shareUserName).stringValue, sharePassword: AppUserDefaults.value(forKey: .sharePassword).stringValue)
        self.dismiss(animated: true) {
            if let handle = self.cgmConnectedSuccess{
                AppUserDefaults.save(value: self.cgmData, forKey: .cgmValue)
                AppUserDefaults.save(value: self.directionString, forKey: .directionString)
                handle(sender,self.cgmData)
            }
        }
    }

    @IBAction func crossBtnTapped(_ sender: AppButton) {
        self.dismiss(animated: false, completion: nil)

    }
}

// MARK: - Extension For Functions
//===========================
extension CGMConnectedVC {
    
    private func initialSetup() {
        if #available(iOS 13.0, *) {
        overrideUserInterfaceStyle = .light
        }
        self.dataSetup()
        self.connectDexcomAccount()
    }
    
    private func dataSetup(){
        activityIndicator.isHidden = true
        self.titleLbl.textColor = UIColor.black
        self.subTitleLbl.textColor = AppColors.fontPrimaryColor
        if SystemInfoModel.shared.previousCgmReadingTime == "0" {
            self.subTitleLbl.text = "CGM Reading time - \(Date().convertToDefaultTimeString())"
        }else {
            self.subTitleLbl.text = "Your last CGM reading was from \(SystemInfoModel.shared.previousCgmReadingTime) minutes ago"
        }
        self.okBtn.isEnabled = true
    }
    
    func connectDexcomAccount(){
        okBtn.isEnabled = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        titleLbl.text = "Connecting..."
        // TODO: need non-us server ?
        let shareUserName = AppUserDefaults.value(forKey: .shareUserName).stringValue
        let sharePassword = AppUserDefaults.value(forKey: .sharePassword).stringValue
        let shareServer = KnownShareServers.US.rawValue
        dexShare = ShareClient(username: shareUserName, password: sharePassword, shareServer: shareServer )
        
        var onlyPullLastRecord = false
        if UserDefaultsRepository.alwaysDownloadAllBG.value { onlyPullLastRecord = false }
        if !shareUserName.isEmpty && !sharePassword.isEmpty {
            webLoadDexShare(onlyPullLastRecord: onlyPullLastRecord)
        } else {
            webLoadNSBGData(onlyPullLastRecord: onlyPullLastRecord)
        }
    }
    
    // NS BG Data Response processor
    func ProcessNSBGData(data: [ShareGlucoseData], onlyPullLastRecord: Bool, isNS: Bool = false){
//        if UserDefaultsRepository.debugLog.value { self.writeDebugLog(value: "Process: BG") }
        
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
            webLoadNSBGData(onlyPullLastRecord: onlyPullLastRecord)
            print("dex didn't load, triggered NS attempt")
            return
        }
        
        // Start the BG timer based on the reading
//        let secondsAgo = now - latestDate
        
//        DispatchQueue.main.async {
//            // if reading is overdue over: 20:00, re-attempt every 5 minutes
//            if secondsAgo >= (20 * 60) {
//                self.startBGTimer(time: (5 * 60))
//                print("##### started 5 minute bg timer")
//
//            // if the reading is overdue: 10:00-19:59, re-attempt every minute
//            } else if secondsAgo >= (10 * 60) {
//                self.startBGTimer(time: 60)
//                print("##### started 1 minute bg timer")
//
//            // if the reading is overdue: 7:00-9:59, re-attempt every 30 seconds
//            } else if secondsAgo >= (7 * 60) {
//                self.startBGTimer(time: 30)
//                print("##### started 30 second bg timer")
//
//            // if the reading is overdue: 5:00-6:59 re-attempt every 10 seconds
//            } else if secondsAgo >= (5 * 60) {
//                self.startBGTimer(time: 10)
//                print("##### started 10 second bg timer")
//
//            // We have a current reading. Set timer to 5:10 from last reading
//            } else {
//                self.startBGTimer(time: 300 - secondsAgo + Double(UserDefaultsRepository.bgUpdateDelay.value))
//                let timerVal = 310 - secondsAgo
//                print("##### started 5:10 bg timer: \(timerVal)")
//            }
//        }
        
        // If we already have data, we're going to pop it to the end and remove the first. If we have old or no data, we'll destroy the whole array and start over. This is simpler than determining how far back we need to get new data from in case Dex back-filled readings
        if !onlyPullLastRecord {
            bgData.removeAll()
        } else if bgData[bgData.count - 1].date != pullDate {
            bgData.removeFirst()
//            if data.count > 0 && UserDefaultsRepository.speakBG.value {
//                speakBG(sgv: data[data.count - 1].sgv)
//            }
        } else {
//            if data.count > 0 {
//                self.updateBadge(val: data[data.count - 1].sgv)
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
                let reading = ShareGlucoseData(sgv: data[data.count - 1 - i].sgv, direction: data[data.count - 1 - i].direction ?? "", date: dateString)
                bgData.append(reading)
            }
            
        }
        
        viewUpdateNSBG(isNS: isNS)
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
                // If we get an error, immediately try to pull NS BG Data
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.titleLbl.text = "Connection failed!"
                    self.showAlert(title: "Dexcom Share Error", msg: "Please double check user name and password, internet connection, and sharing status.") {
                        
                        SystemInfoModel.shared.cgmUnit = Int(self.ValueLbl.text ?? "") ?? 0
                        self.dismiss(animated: true) {
                            
                        }
                    }
                }
                
                self.webLoadNSBGData(onlyPullLastRecord: onlyPullLastRecord)
                
                if globalVariables.dexVerifiedAlert < dateTimeUtils.getNowTimeIntervalUTC() + 300 {
                    globalVariables.dexVerifiedAlert = dateTimeUtils.getNowTimeIntervalUTC()
                }
            }
        }
    }
    
    // NS BG Data Web call
    func webLoadNSBGData(onlyPullLastRecord: Bool = false) {
//        if UserDefaultsRepository.debugLog.value { self.writeDebugLog(value: "Download: BG") }
        // Set the count= in the url either to pull 24 hours or only the last record
        var points = "1"
        if !onlyPullLastRecord {
            points = String(self.graphHours * 12 + 1)
        }
        
        // URL processor
        var urlBGDataPath: String = UserDefaultsRepository.url.value + "/api/v1/entries/sgv.json?"
//        if token == "" {
            urlBGDataPath = urlBGDataPath + "count=" + points
//        } else {
//            urlBGDataPath = urlBGDataPath + "token=" + token + "&count=" + points
//        }
        guard let urlBGData = URL(string: urlBGDataPath) else {
            if globalVariables.nsVerifiedAlert < dateTimeUtils.getNowTimeIntervalUTC() + 300 {
                globalVariables.nsVerifiedAlert = dateTimeUtils.getNowTimeIntervalUTC()
                //self.sendNotification(title: "Nightscout Error", body: "Please double check url, token, and internet connection. This may also indicate a temporary Nightscout issue")
            }
            return
        }
        var request = URLRequest(url: urlBGData)
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
        // Downloader
        let getBGTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                if globalVariables.nsVerifiedAlert < dateTimeUtils.getNowTimeIntervalUTC() + 300 {
                    globalVariables.nsVerifiedAlert = dateTimeUtils.getNowTimeIntervalUTC()
                    //self.sendNotification(title: "Nightscout Error", body: "Please double check url, token, and internet connection. This may also indicate a temporary Nightscout issue")
                }
                return
                
            }
            guard let data = data else {
                if globalVariables.nsVerifiedAlert < dateTimeUtils.getNowTimeIntervalUTC() + 300 {
                    globalVariables.nsVerifiedAlert = dateTimeUtils.getNowTimeIntervalUTC()
                    //self.sendNotification(title: "Nightscout Error", body: "Please double check url, token, and internet connection. This may also indicate a temporary Nightscout issue")
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
                if globalVariables.nsVerifiedAlert < dateTimeUtils.getNowTimeIntervalUTC() + 300 {
                    globalVariables.nsVerifiedAlert = dateTimeUtils.getNowTimeIntervalUTC()
                    //self.sendNotification(title: "Nightscout Failure", body: "Please double check url, token, and internet connection. This may also indicate a temporary Nightscout issue")
                }
                return
                
            }
        }
        getBGTask.resume()
    }
    
    // NS BG Data Front end updater
    func viewUpdateNSBG (isNS: Bool) {
        DispatchQueue.main.async {
            let entries = self.bgData
            if entries.count < 1 { return }
            //MARK:- Important
            UserDefaultsRepository.shareUserName.value = AppUserDefaults.value(forKey: .shareUserName).stringValue
            UserDefaultsRepository.sharePassword.value = AppUserDefaults.value(forKey: .sharePassword).stringValue
            NotificationCenter.default.post(name: Notification.Name.cgmConnectedSuccessfully, object: [ApiKey.cgmData:entries])
//            SystemInfoModel.shared.cgmData = self.bgData
//            if SystemInfoModel.shared.isFromSetting {
//                for cgmModel in entries {
//                    FirestoreController.createCGMDataNode(direction: cgmModel.direction ?? "", sgv: cgmModel.sgv, date: cgmModel.date)
//                }
//            }
//            NotificationCenter.default.post(name: Notification.Name.CgmDataReceivedSuccessfully, object: [:])
//            self.updateBGGraph()
//            self.updateStats()
            
            let latestEntryi = entries.count - 1
            let latestBG = entries[latestEntryi].sgv
            
            self.okBtn.isEnabled = true
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.titleLbl.text = "Your Dexcom G6 CGM is connected"
            self.ValueLbl.text = bgUnits.toDisplayUnits(String(latestBG))
            self.cgmData = bgUnits.toDisplayUnits(String(latestBG))
//            snoozerBG = bgUnits.toDisplayUnits(String(latestBG))
            self.setBGTextColor()
            
            if let directionBG = entries[latestEntryi].direction {
                self.directionText.text = self.bgDirectionGraphic(directionBG)
                self.directionString = self.bgDirectionGraphic(directionBG)
//                snoozerDirection = self.bgDirectionGraphic(directionBG)
                self.latestDirectionString = self.bgDirectionGraphic(directionBG)
            }
            else
            {
                self.directionText.text = ""
                self.directionString = ""
//                snoozerDirection = ""
                self.latestDirectionString = ""
            }
            
//            if deltaBG < 0 {
//                self.DeltaText.text = bgUnits.toDisplayUnits(String(deltaBG))
//                snoozerDelta = bgUnits.toDisplayUnits(String(deltaBG))
//                self.latestDeltaString = String(deltaBG)
//            }
//            else
//            {
//                self.DeltaText.text = "+" + bgUnits.toDisplayUnits(String(deltaBG))
//                snoozerDelta = "+" + bgUnits.toDisplayUnits(String(deltaBG))
//                self.latestDeltaString = "+" + String(deltaBG)
//            }
           // self.updateBadge(val: latestBG)
        }
        
    }
    
    func setBGTextColor() {
        if bgData.count > 0 {
            let latestBG = bgData[bgData.count - 1].sgv
            var color: UIColor = UIColor.label
            if UserDefaultsRepository.colorBGText.value {
                if Float(latestBG) >= UserDefaultsRepository.highLine.value {
                    color = UIColor.systemYellow
                } else if Float(latestBG) <= UserDefaultsRepository.lowLine.value {
                    color = UIColor.systemRed
                } else {
                    color = UIColor.systemGreen
                }
            }
            
            ValueLbl.textColor = color
            directionText.textColor = color
        }
    }
    
    func bgDirectionGraphic(_ value:String)->String
    {
        let //graphics:[String:String]=["Flat":"\u{2192}","DoubleUp":"\u{21C8}","SingleUp":"\u{2191}","FortyFiveUp":"\u{2197}\u{FE0E}","FortyFiveDown":"\u{2198}\u{FE0E}","SingleDown":"\u{2193}","DoubleDown":"\u{21CA}","None":"-","NOT COMPUTABLE":"-","RATE OUT OF RANGE":"-"]
        graphics:[String:String]=["Flat":"→","DoubleUp":"↑↑","SingleUp":"↑","FortyFiveUp":"↗","FortyFiveDown":"↘︎","SingleDown":"↓","DoubleDown":"↓↓","None":"-","NONE":"-","NOT COMPUTABLE":"-","RATE OUT OF RANGE":"-", "": "-"]
        return graphics[value]!
    }
    
    
    func speakBG(sgv: Int) {
           let speechSynthesizer = AVSpeechSynthesizer()
           let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: "Current BG is " + bgUnits.toDisplayUnits(String(sgv)))
           speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2
           speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
           speechSynthesizer.speak(speechUtterance)
       }
}

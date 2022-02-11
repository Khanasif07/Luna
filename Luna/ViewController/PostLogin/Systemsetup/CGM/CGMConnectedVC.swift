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
    @IBOutlet weak var unitLbl: UILabel!
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
    var token = UserDefaultsRepository.token.value as String
    var errMessage : String = ""
    
    var dexShare: ShareClient?;
    var bgData: [ShareGlucoseData] = []
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
        FirestoreController.updateDexcomCreds(shareUserName: AppUserDefaults.value(forKey: .shareUserName).stringValue, sharePassword: AppUserDefaults.value(forKey: .sharePassword).stringValue) {
            self.dismiss(animated: true) {
                if let handle = self.cgmConnectedSuccess{
                    AppUserDefaults.save(value: self.cgmData, forKey: .cgmValue)
                    AppUserDefaults.save(value: self.directionString, forKey: .directionString)
                    handle(sender,self.cgmData)
                }
            }
        } failure: { (err) -> (Void) in
            CommonFunctions.showToastWithMessage(err.localizedDescription)
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
        self.unitLbl.text = UserDefaultsRepository.units.value
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
            self.webLoadDexShare(onlyPullLastRecord: onlyPullLastRecord)
        } else {
            self.webLoadNSBGData(onlyPullLastRecord: onlyPullLastRecord)
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
            DispatchQueue.main.async {
            CommonFunctions.showToastWithMessage("Dexcom CGM data unavailable")
            self.dismiss(animated: true, completion: nil)
            }
            return
        }
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
                let reading = ShareGlucoseData(sgv: data[data.count - 1 - i].sgv, date: dateString, direction: data[data.count - 1 - i].direction ?? "")
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
                guard let actualError = err else { return }
                switch actualError {
                case .dataError(reason: let luna):
                    if luna == "AccountPasswordInvalid"{
                        self.errMessage = "Account Password Invalid"
                    }
                    else if luna == "AccountInvalid"{
                        self.errMessage = "Account Invalid"
                    }else {
                        self.errMessage = luna
                    }
                case .loginError(errorCode: let luna):
                    if luna == "AccountPasswordInvalid"{
                        self.errMessage = "Account Password Invalid"
                    }
                    else if luna == "AccountInvalid"{
                        self.errMessage = "Account Invalid"
                    }else {
                        self.errMessage = luna
                    }
                case .httpError(let err):
                    if err.localizedDescription == "AccountPasswordInvalid"{
                        self.errMessage = "Account Password Invalid"
                    }
                    else if err.localizedDescription == "AccountInvalid"{
                        self.errMessage = "Account Invalid"
                    }else {
                        self.errMessage = err.localizedDescription
                    }
                default:
                    print(actualError.localizedDescription)
                    self.errMessage = actualError.localizedDescription
                }
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.titleLbl.text = "Connection failed!"
                    self.showAlert(title: "Dexcom Server Error", msg: self.errMessage) {
                        SystemInfoModel.shared.cgmUnit = Int(self.ValueLbl.text ?? "") ?? 0
                        self.dismiss(animated: true) {
                        }
                    }
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
        if token.isEmpty {
            urlBGDataPath = urlBGDataPath + "count=" + points
        } else {
            urlBGDataPath = urlBGDataPath + "token=" + token + "&count=" + points
        }
        guard let urlBGData = URL(string: urlBGDataPath) else {
//            if globalVariables.nsVerifiedAlert < dateTimeUtils.getNowTimeIntervalUTC() + 300 {
//                globalVariables.nsVerifiedAlert = dateTimeUtils.getNowTimeIntervalUTC()
                //self.sendNotification(title: "Nightscout Error", body: "Please double check url, token, and internet connection. This may also indicate a temporary Nightscout issue")
//            }
            return
        }
        var request = URLRequest(url: urlBGData)
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
        // Downloader
        let getBGTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
//                if globalVariables.nsVerifiedAlert < dateTimeUtils.getNowTimeIntervalUTC() + 300 {
//                    globalVariables.nsVerifiedAlert = dateTimeUtils.getNowTimeIntervalUTC()
//                    self.sendNotification(title: "Nightscout Error", body: "Please double check url, token, and internet connection. This may also indicate a temporary Nightscout issue")
//                }
                return
                
            }
            guard let data = data else {
//                if globalVariables.nsVerifiedAlert < dateTimeUtils.getNowTimeIntervalUTC() + 300 {
//                    globalVariables.nsVerifiedAlert = dateTimeUtils.getNowTimeIntervalUTC()
                    //self.sendNotification(title: "Nightscout Error", body: "Please double check url, token, and internet connection. This may also indicate a temporary Nightscout issue")
//                }
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
                    //self.sendNotification(title: "Nightscout Failure", body: "Please double check url, token, and internet connection. This may also indicate a temporary Nightscout issue")
//                }
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
            let latestEntryi = entries.count - 1
            let latestBG = entries[latestEntryi].sgv
            self.okBtn.isEnabled = true
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.titleLbl.text = "Your Dexcom G6 CGM is connected"
            self.ValueLbl.text = bgUnits.toDisplayUnits(String(latestBG),true)
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
        let
        graphics:[String:String]=["Flat":"→","DoubleUp":"↑↑","SingleUp":"↑","FortyFiveUp":"↗","FortyFiveDown":"↘︎","SingleDown":"↓","DoubleDown":"↓↓","None":"-","NONE":"-","NOT COMPUTABLE":"-","RATE OUT OF RANGE":"-", "": "-"]
        return graphics[value] ?? ""
    }
    
    
    func speakBG(sgv: Int) {
           let speechSynthesizer = AVSpeechSynthesizer()
           let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: "Current BG is " + bgUnits.toDisplayUnits(String(sgv)))
           speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2
           speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
           speechSynthesizer.speak(speechUtterance)
       }
}

//
//  BottomSheetVC.swift
//  Luna
//
//  Created by Admin on 22/09/21.
//


import Foundation
import UIKit
import Charts
import UserNotifications
import Photos

class BottomSheetVC:  UIViewController,UNUserNotificationCenterDelegate {
    
    //MARK:- OUTLETS
    //==============
    @IBOutlet weak var cgmChartView: TappableLineChartView!
    @IBOutlet weak var mainCotainerView: UIView!
    @IBOutlet weak var bottomLayoutConstraint : NSLayoutConstraint!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var timeAgoLbl: UILabel!
    @IBOutlet weak var cgmDirectionlbl: UILabel!
    @IBOutlet weak var cgmValueLbl: UILabel!
    
    //MARK:- VARIABLE
    //================
    // Variables for BG Charts
    let ScaleXMax:Float = 150.0
    var errMessage :String = ""
    var firstGraphLoad: Bool = true
    var isNotificationProgress: Bool = false
    var minAgoBG: Double = 0.0
    // Vars for NS Pull
    var graphHours:Int=24
    var urlUser = UserDefaultsRepository.url.value as String
    var token = UserDefaultsRepository.token.value as String
    var backgroundTask = BackgroundTask()
    
    // Refresh NS Data
    // check every 30 Seconds whether new bgvalues should be retrieved
    let timeInterval: TimeInterval = 30.0
    
    // Min Ago Timer
    var minAgoTimer = Timer()
    var minAgoTimeInterval: TimeInterval = 60.0
    
    // Check Alarms Timer
    // Don't check within 1 minute of alarm triggering to give the snoozer time to save data
    var bgTimer = Timer()
    
    // Info Table Setup
    var bgCheckData: [ShareGlucoseData] = []
    var bgData: [ShareGlucoseData] = []
    
    var latestDirectionString = ""
    var latestMinAgoString = ""
    var latestDeltaString = ""
    var topBG: Float = UserDefaultsRepository.minBGScale.value
    // share
    var bgDataShare: [ShareGlucoseData] = []
    var dexShare: ShareClient?;
    var dexVerifiedAlerted = false
    
    //
    var topSafeArea: CGFloat = 0.0
    var bottomSafeArea: CGFloat = 0.0
    lazy var swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(closePullUp))
    var fullView: CGFloat {
        return UIApplication.shared.statusBarHeight + 51.0
    }
    var partialView: CGFloat {
        return (textContainerHeight ?? 0.0) + UIApplication.shared.statusBarHeight + (110.5)
    }
    var textContainerHeight : CGFloat? {
        didSet{
            self.mainTableView.reloadData()
        }
    }
    //MARK:- VIEW LIFE CYCLE
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard self.isMovingToParent else { return }
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height)
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainCotainerView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 15)
        mainCotainerView.addShadowToTopOrBottom(location: .top, color: UIColor.black.withAlphaComponent(0.15))
        if #available(iOS 11.0, *) {
            topSafeArea = view.safeAreaInsets.top
            bottomSafeArea = view.safeAreaInsets.bottom
        }
    }
    
    private func cgmSetUp(){
        // TODO: need non-us server ?
        let shareUserName = UserDefaultsRepository.shareUserName.value
        let sharePassword = UserDefaultsRepository.sharePassword.value
        let shareServer = UserDefaultsRepository.shareServer.value == "US" ?KnownShareServers.US.rawValue : KnownShareServers.NON_US.rawValue
        dexShare = ShareClient(username: shareUserName, password: sharePassword, shareServer: shareServer )
        self.newChartSetUp()
        // Trigger foreground and background functions
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        // Setup the Graph
        if firstGraphLoad {
            self.createGraph()
        }
        // Load Startup Data
        restartAllTimers()
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                    self.mainTableView.isScrollEnabled = false
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                    self.mainTableView.isScrollEnabled = true
                }
                
            }) { (completion) in
            }
        }
    }
    
    //MARK:- Read Insulin from apple health kit
    private func readInsulinFromAppleHealthKit(){
        HealthKitManager.sharedInstance.readInsulinFromAppleHealthKit { (insulinData) in
            print(insulinData)
            let insulinRecords = insulinData.map({$0.value}).reduce(0, +)
            AppUserDefaults.save(value: insulinRecords, forKey: .insulinFromApple)
            BleManager.sharedInstance.writeAppleInsulinRecordsToController(value: bgUnits.toSendExternalDoseStampsUnits("", String(insulinRecords)))
        }
    }
   
    @objc func cgmDataReceivedSuccessfully(notification : NSNotification){
        if let dict = notification.object as? NSDictionary {
            if let bgData = dict[ApiKey.cgmData] as? [ShareGlucoseData]{
                self.bgData = bgData
                SystemInfoModel.shared.cgmData = bgData
                let shareUserName = UserDefaultsRepository.shareUserName.value
                let sharePassword = UserDefaultsRepository.sharePassword.value
                let shareServer = UserDefaultsRepository.shareServer.value == "US" ?KnownShareServers.US.rawValue : KnownShareServers.NON_US.rawValue
                dexShare = ShareClient(username: shareUserName, password: sharePassword, shareServer: shareServer )
                self.restartAllTimers()
            }
        }
    }
    
    @objc func cgmSimData(notification : NSNotification){
        print("Reached here in BottomSheetVC")
        DispatchQueue.main.async {
            self.bgData = SystemInfoModel.shared.cgmData ?? []
            if let latestBg = self.bgData.last {
                self.cgmValueLbl.text = bgUnits.toDisplayUnits(String(latestBg.sgv),true)
                if let direction = latestBg.direction {
                    self.cgmDirectionlbl.text = self.bgDirectionGraphic(direction)
                    self.latestDirectionString = self.bgDirectionGraphic(direction)
                } else {
                    self.cgmDirectionlbl.text = ""
                    self.latestDirectionString = ""
                }
                
                BleManager.sharedInstance.writeCGMTimeStampValue(value: bgUnits.toSendCGMTimeStampsUnits(String(latestBg.date), String(latestBg.sgv)))
            } else {
                self.cgmValueLbl.text = "--"
                self.cgmDirectionlbl.text = ""
                self.latestDirectionString = ""
            }
            
            self.mainTableView.reloadData()
            self.updateMinAgo()
            self.updateBGGraph()
        }
    }
    
    @objc func cgmDataRemovedSuccessfully(notification : NSNotification){
        self.bgData = []
        SystemInfoModel.shared.cgmData = []
        UserDefaultsRepository.shareUserName.value = ""
        UserDefaultsRepository.sharePassword.value = ""
        let shareUserName = UserDefaultsRepository.shareUserName.value
        let sharePassword = UserDefaultsRepository.sharePassword.value
        let shareServer = UserDefaultsRepository.shareServer.value == "US" ?KnownShareServers.US.rawValue : KnownShareServers.NON_US.rawValue
        dexShare = ShareClient(username: shareUserName, password: sharePassword, shareServer: shareServer )
        updateMinAgo()
        newChartSetUp()
        createGraph()
    }
}

//MARK:- Private functions
//========================
extension BottomSheetVC {
    
    private func initialSetup() {
        self.setupTableView()
        self.addObserver()
        self.setupSwipeGesture()
        self.cgmSetUp()
        self.readInsulinFromAppleHealthKit()
    }
    
    private func setupTableView() {
        self.mainTableView.isScrollEnabled = true
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.registerCell(with: BottomSheetInsulinCell.self)
        self.mainTableView.registerCell(with: BottomSheetBottomCell.self)
        setupfooterView()
    }
    
    private func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(applicationIsTerminated), name: .applicationIsTerminated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receivedPushNotification), name: .receivedPushNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(bleDidUpdateValue), name: .bleDidUpdateValue, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(batteryUpdateValue), name: .batteryUpdateValue, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reservoirUpdateValue), name: .reservoirUpdateValue, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(statusUpdateValue), name: .statusUpdateValue, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cgmDataReceivedSuccessfully), name: .cgmConnectedSuccessfully, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cgmDataRemovedSuccessfully), name: .cgmRemovedSuccessfully, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cgmSimData), name: .cgmSimData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(bLEOnOffStateChanged), name: .bLEOnOffState, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(insulinConnectedFinish), name: .insulinConnectedSuccessfully, object: nil)
    }
    
    //    @objc func xAxisLabelsDuplicateValue(notification : NSNotification){
    //        if let lastData = bgData.last{
    //            if lastData.date < dateTimeUtils.getNowTimeIntervalUTC() {
    //                bgData.removeFirst()
    //                bgData.append(ShareGlucoseData(sgv: lastData.sgv, date: lastData.date + 300.0, direction: lastData.direction ?? "", insulin: lastData.insulin ?? ""))
    //                DispatchQueue.main.async {
    //                    self.updateBGGraph()
    //                }
    //            }
    //        }
    //    }
    
    @objc func applicationIsTerminated(){
        self.persistentNotification(body: "Tap to open app. Luna will not function until the app is open. In the future, keep app running in the background, don't swipe it closed. ",title: "App is closed.")
    }
    
    @objc func receivedPushNotification(notification : NSNotification){
        if let dict = notification.object as? NSDictionary {
            self.persistentNotification(body: dict["body"] as? String ?? "" ,title: dict["title"] as? String ?? "")
        }
    }
    
    @objc func bLEOnOffStateChanged(){
        let bodyText  = "Turn on Bluetooth to receive alerts, alarms, or sensor glucose readings."
        self.persistentNotification(body: bodyText,title: "Bluetooth Off Alert")
    }
    
    @objc func insulinConnectedFinish(){
        BleManager.sharedInstance.writeTDBDValue( value: "\(SystemInfoModel.shared.insulinUnit)")
    }
    
    @objc func bleDidUpdateValue(notification : NSNotification){
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
            self.processNSBGData(data: self.bgData, onlyPullLastRecord: false)
        }
    }
    
    @objc func batteryUpdateValue(notification : NSNotification){
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
            if ((BleManager.sharedInstance.systemStatusData.contains("3") || BleManager.sharedInstance.systemStatusData.contains("5")) && Int(BleManager.sharedInstance.batteryData) ?? 0 <= 75 && (Int(BleManager.sharedInstance.batteryData) ?? 0) % 5 == 0 && SystemInfoModel.shared.dosingData.last?.sessionStatus != ApiKey.endCaps) {
                var bodyText  = "Your Luna device is only "
                bodyText += BleManager.sharedInstance.batteryData
                bodyText += "% charged and may not last the entire session."
                self.persistentNotification(body: bodyText)
                return
            }
            
            if ((BleManager.sharedInstance.systemStatusData.contains("F7") || BleManager.sharedInstance.systemStatusData.contains("F8")) && Int(BleManager.sharedInstance.batteryData) ?? 0 <= 75 && (Int(BleManager.sharedInstance.batteryData) ?? 0) % 5 == 0 && SystemInfoModel.shared.dosingData.last?.sessionStatus != ApiKey.endCaps) {
                var bodyText  = "Your Luna device is only "
                bodyText += BleManager.sharedInstance.batteryData
                bodyText += "% charged and may not last the entire session."
                self.persistentNotification(body: bodyText)
                return
            }
            
            if BleManager.sharedInstance.systemStatusData.contains("0") || BleManager.sharedInstance.systemStatusData.contains("1"){
                let bodyText  = "Your Luna device neeeds to be charged and is not being charged."
                self.persistentNotification(body: bodyText)
                return
            }
        }
    }
    
    @objc func reservoirUpdateValue(notification : NSNotification){
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
            if BleManager.sharedInstance.reservoirLevelData == "-1" && BleManager.sharedInstance.iobData > 0.0{
                var bodyText  = "Your session has been completed and you have "
                bodyText += "\(BleManager.sharedInstance.iobData)"
                bodyText += " units of active Insulin On Board. Make sure to consider this before making any diabetes related decisions for the next 6 hours."
                self.persistentNotification(body: bodyText)
                return
            }
            
            if BleManager.sharedInstance.systemStatusData.contains("F6") || BleManager.sharedInstance.systemStatusData.contains("F5"){
                self.persistentNotification(body: "Luna is not receiving CGM data. Check to see if your CGM is working and paired with Luna properly.")
                return
            }
            
            if BleManager.sharedInstance.systemStatusData.contains("FB"){
                self.persistentNotification(body: "Luna has detected that there is no insulin in the Reservoir. Please discard this Reservoir and place the Luna Controller back on the Charger for 60 seconds to reset the device.")
                return
            }
            
            if BleManager.sharedInstance.systemStatusData.contains("F3") && SystemInfoModel.shared.dosingData.last?.sessionStatus == ApiKey.beginCaps {
                self.persistentNotification(body: "Luna has detected an occlusion in the system. Please discard this reservoir and place the Luna Controller back on the Charger for 60 seconds to reset the device.")
                return
            }
            
            if (BleManager.sharedInstance.systemStatusData.contains("FA") || (BleManager.sharedInstance.systemStatusData.contains("F1") && BleManager.sharedInstance.systemStatusData.contains("F2") && BleManager.sharedInstance.systemStatusData.contains("F4") && BleManager.sharedInstance.systemStatusData.contains("F9"))) && SystemInfoModel.shared.dosingData.last?.sessionStatus != ApiKey.endCaps{
                self.persistentNotification(body: "Luna has detected a failure in the system. Please check the dashboard on the App for more information. If the problem can’t be resolved, discard this Reservoir and place the Luna Controller back on the Charger for 60 seconds to reset the device.")
                return
            }
        }
    }
    
    @objc func statusUpdateValue(notification : NSNotification){
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
            if BleManager.sharedInstance.systemStatusData.contains("F6") || BleManager.sharedInstance.systemStatusData.contains("F5"){
                self.persistentNotification(body: "Luna is not receiving CGM data. Check to see if your CGM is working and paired with Luna properly.")
                return
            }
            
            if BleManager.sharedInstance.systemStatusData.contains("F3") && SystemInfoModel.shared.dosingData.last?.sessionStatus == ApiKey.beginCaps {
                self.persistentNotification(body: "Luna has detected an occlusion in the system. Please discard this reservoir and place the Luna Controller back on the Charger for 60 seconds to reset the device.")
                return
            }
            
            if (BleManager.sharedInstance.systemStatusData.contains("FA") || (BleManager.sharedInstance.systemStatusData.contains("F1") && BleManager.sharedInstance.systemStatusData.contains("F2") && BleManager.sharedInstance.systemStatusData.contains("F4") && BleManager.sharedInstance.systemStatusData.contains("F9"))) && SystemInfoModel.shared.dosingData.last?.sessionStatus == ApiKey.beginCaps{
                self.persistentNotification(body: "Luna has detected a failure in the system. Please check the dashboard on the App for more information. If the problem can’t be resolved, discard this Reservoir and place the Luna Controller back on the Charger for 60 seconds to reset the device.")
                return
            }
        }
    }
    
    private func setupfooterView(){
        let now = dateTimeUtils.getNowTimeIntervalUTC()
        let view = UIView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: self.view.frame.width, height: 100.0)))
        self.mainTableView.tableFooterView = view
        if let fetchedData = UserDefaults.standard.data(forKey: ApiKey.dosingHistoryData) {
            let fetchedDosingData = try! JSONDecoder().decode([DosingHistory].self, from: fetchedData)
            SystemInfoModel.shared.dosingData = fetchedDosingData.filter({ (now - $0.sessionTime <= 86400.0)})
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
        }
    }
    
    private func setupSwipeGesture() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(BottomSheetVC.panGesture))
        view.addGestureRecognizer(gesture)
        swipeDown.direction = .down
        swipeDown.delegate = self
        mainTableView.addGestureRecognizer(swipeDown)
    }
    
    @objc func closePullUp() {
        UIView.animate(withDuration: 0.3, animations: {
            let frame = self.view.frame
            self.view.frame = CGRect(x: 0, y: self.partialView, width: frame.width, height: frame.height)
        })
    }
    
    func rotateLeft(dropdownView: UIView,left: CGFloat = -1) {
        UIView.animate(withDuration: 1.0, animations: {
            dropdownView.transform = CGAffineTransform(rotationAngle: ((180.0 * CGFloat(Double.pi)) / 180.0) * CGFloat(left))
            self.view.layoutIfNeeded()
        })
    }
    
}

//MARK:- UITableViewDelegate
//========================
extension BottomSheetVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? (SystemInfoModel.shared.insulinData.endIndex) : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueCell(with: BottomSheetInsulinCell.self, indexPath: indexPath)
            cell.populateCell()
            return cell
        case 1:
            let cell = tableView.dequeueCell(with: BottomSheetBottomCell.self, indexPath: indexPath)
            cell.topLineDashView.isHidden = indexPath.row == 0
            cell.populateCell(model:SystemInfoModel.shared.insulinData[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- Gesture Delegates
//========================
extension BottomSheetVC : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //Identify gesture recognizer and return true else false.
        if (!mainTableView.isDragging && !mainTableView.isDecelerating) {
            return gestureRecognizer.isEqual(self.swipeDown) ? true : false
        }
        return false
    }
}

extension BottomSheetVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // This will be called every time the user scrolls the scroll view with their finger
        // so each time this is called, contentOffset should be different.
        if self.mainTableView.contentOffset.y < 0{
            self.mainTableView.isScrollEnabled = false
        } else if self.mainTableView.contentOffset.y == 0.0 {
            self.mainTableView.isScrollEnabled = false
        } else{
            self.mainTableView.isScrollEnabled = true
        }
        //Additional workaround here.
    }
}

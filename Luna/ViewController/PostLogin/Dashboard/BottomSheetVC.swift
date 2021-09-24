//
//  BottomSheetVC.swift
//  Luna
//
//  Created by Admin on 22/09/21.
//


import Foundation
import UIKit
import Charts
import EventKit
import UserNotifications
import Photos

class BottomSheetVC:  UIViewController,UNUserNotificationCenterDelegate {
    
    //MARK:- OUTLETS
    //==============
    @IBOutlet weak var cgmChartView: LineChartView!
    @IBOutlet weak var mainCotainerView: UIView!
    @IBOutlet weak var bottomLayoutConstraint : NSLayoutConstraint!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var timeAgoLbl: UILabel!
    @IBOutlet weak var cgmDirectionlbl: UILabel!
    @IBOutlet weak var cgmValueLbl: UILabel!
    
    //MARK:- VARIABLE
    //================
    // Variables for BG Charts
    var appStateController: AppStateController?
    public var numPoints: Int = 13
    public var linePlotData: [Double] = []
    public var linePlotDataTime: [Double] = []
    var firstGraphLoad: Bool = true
    var firstBasalGraphLoad: Bool = true
    var minAgoBG: Double = 0.0
    var currentOverride = 1.0
    // Vars for NS Pull
    var graphHours:Int=24
    var mmol = false as Bool
    var urlUser = UserDefaultsRepository.url.value as String
    var token = UserDefaultsRepository.token.value as String
    var defaults : UserDefaults?
    let consoleLogging = true
    var timeofLastBGUpdate = 0 as TimeInterval
    var nsVerifiedAlerted = false
    
    var backgroundTask = BackgroundTask()
    
    // Refresh NS Data
    var timer = Timer()
    // check every 30 Seconds whether new bgvalues should be retrieved
    let timeInterval: TimeInterval = 30.0
    
    // Min Ago Timer
    var minAgoTimer = Timer()
    var minAgoTimeInterval: TimeInterval = 1.0
    
    
    // Check Alarms Timer
    // Don't check within 1 minute of alarm triggering to give the snoozer time to save data
    var checkAlarmTimer = Timer()
    var checkAlarmInterval: TimeInterval = 60.0
    
    var calTimer = Timer()
    
    var bgTimer = Timer()
    var cageSageTimer = Timer()
    var profileTimer = Timer()
    var deviceStatusTimer = Timer()
    var treatmentsTimer = Timer()
    var alarmTimer = Timer()
    var calendarTimer = Timer()
    var graphNowTimer = Timer()
    
    // Info Table Setup
    var bgCheckData: [ShareGlucoseData] = []
    var bgData: [ShareGlucoseData] = []
    var newBGPulled = false
    var lastCalDate: Double = 0
    var latestDirectionString = ""
    var latestMinAgoString = ""
    var latestDeltaString = ""
    var latestLoopStatusString = ""
    var latestLoopTime: Double = 0
    var latestCOB = ""
    var latestBasal = ""
    var latestPumpVolume: Double = 50.0
    var latestIOB = ""
    var lastOverrideStartTime: TimeInterval = 0
    var lastOverrideEndTime: TimeInterval = 0
    var topBG: Float = UserDefaultsRepository.minBGScale.value
    var lastOverrideAlarm: TimeInterval = 0
    
    // share
    var bgDataShare: [ShareGlucoseData] = []
    var dexShare: ShareClient?;
    var dexVerifiedAlerted = false
    
    // calendar setup
    let store = EKEventStore()
    //
    var topSafeArea: CGFloat = 0.0
    var bottomSafeArea: CGFloat = 0.0
    var cgmDataArray : [ShareGlucoseData] = []
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
    var cgmData : [ShareGlucoseData] = []{
        didSet{
            self.cgmDataArray = cgmData
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
        willAppearSetup()
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
        } else {
            topSafeArea = topLayoutGuide.length
            bottomSafeArea = bottomLayoutGuide.length
        }
    }
    
    private func cgmSetUp(){
        UserDefaultsRepository.infoNames.value.removeAll()
        UserDefaultsRepository.infoNames.value.append("Battery")
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
    
    private func willAppearSetup(){
        // set screen lock
        UIApplication.shared.isIdleTimerDisabled = UserDefaultsRepository.screenlockSwitchState.value;
        
        // check the app state
        // TODO: move to a function ?
        if let appState = self.appStateController {

            if appState.chartSettingsChanged {

                // can look at settings flags to be more fine tuned
//                if let cell = self.mainTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? BottomSheetChartCell{
//                self.updateBGGraphSettings()
//                }
//                self.updateBGGraphSettings()

//                if ChartSettingsChangeEnum.smallGraphHeight.rawValue != 0 {
//                    smallGraphHeightConstraint.constant = CGFloat(UserDefaultsRepository.smallGraphHeight.value)
//                    self.view.layoutIfNeeded()
//                }

                // reset the app state
                appState.chartSettingsChanged = false
                appState.chartSettingsChanges = 0
            }
            if appState.generalSettingsChanged {

                // settings for appBadge changed
                if appState.generalSettingsChanges & GeneralSettingsChangeEnum.appBadgeChange.rawValue != 0 {

                }

                // settings for textcolor changed
                if appState.generalSettingsChanges & GeneralSettingsChangeEnum.colorBGTextChange.rawValue != 0 {
                    self.setBGTextColor()
                }

                // settings for showStats changed
                if appState.generalSettingsChanges & GeneralSettingsChangeEnum.showStatsChange.rawValue != 0 {
//                    statsView.isHidden = !UserDefaultsRepository.showStats.value
                }

                // settings for useIFCC changed
                if appState.generalSettingsChanges & GeneralSettingsChangeEnum.useIFCCChange.rawValue != 0 {
//                    updateStats()
                }

                // settings for showSmallGraph changed
                if appState.generalSettingsChanges & GeneralSettingsChangeEnum.showSmallGraphChange.rawValue != 0 {
//                    BGChartFull.isHidden = !UserDefaultsRepository.showSmallGraph.value
                }

                // reset the app state
                appState.generalSettingsChanged = false
                appState.generalSettingsChanges = 0
            }
            if appState.infoDataSettingsChanged {
                self.mainTableView.reloadData()
                // reset
                appState.infoDataSettingsChanged = false
            }

            // add more processing of the app state
        }
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
}

//MARK:- Private functions
//========================
extension BottomSheetVC {
    
    private func initialSetup() {
        setupTableView()
        addObserver()
        setupSwipeGesture()
        cgmSetUp()
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
        NotificationCenter.default.addObserver(self, selector: #selector(bleDidUpdateValue), name: .BleDidUpdateValue, object: nil)
    }
    
    @objc func bleDidUpdateValue(notification : NSNotification){
        if let dict = notification.object as? NSDictionary {
                print(dict)
        }
        self.mainTableView.reloadData()
    }
    
    private func setupfooterView(){
        let view = UIView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: self.view.frame.width, height: 100.0)))
        self.mainTableView.tableFooterView = view
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
        return section == 1 ? (SystemInfoModel.shared.insulinData?.endIndex ?? 0) : 1
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
            if let insulinData = SystemInfoModel.shared.insulinData {
            cell.timeLbl.text = (Double(insulinData[indexPath.row].date) ).getDateTimeFromTimeInterval("h:mm a")
            cell.unitLbl.text = (insulinData[indexPath.row].insulinData ?? "") + " Units"
            }
            return cell
        default:
            let cell = tableView.dequeueCell(with: BottomSheetChartCell.self, indexPath: indexPath)
            return cell
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
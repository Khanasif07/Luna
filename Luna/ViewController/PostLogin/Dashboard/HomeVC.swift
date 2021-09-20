//
//  HomeVC.swift
//  Luna
//
//  Created by Admin on 24/06/21.
//
import CoreBluetooth
import UIKit
import HealthKit
import Charts

class HomeVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var topNavView: UIView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var topManualButton: UIButton!
    @IBOutlet weak var batteryTitleLbl: UILabel!
    @IBOutlet weak var batteryStatusLbl: UILabel!
    @IBOutlet weak var batteryImgView: UIImageView!
    @IBOutlet weak var reservoirStatusLbl: UILabel!
    @IBOutlet weak var reservoirImgView: UIImageView!
    @IBOutlet weak var reservoirTitleLbl: UILabel!
    @IBOutlet weak var batteryStackView: UIStackView!
    @IBOutlet weak var systemStatusLbl: UILabel!
    @IBOutlet weak var systemImgView: UIImageView!
    @IBOutlet weak var systemTitleLbl: UILabel!
    @IBOutlet weak var batteryEmptyLbl: UILabel!
    @IBOutlet weak var reservoirEmptyLbl: UILabel!
    
    // MARK: - Variables
    //==========================
    let bottomSheetVC = HomeBottomSheetVC()
    let coachMarksController = CoachMarksController()
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self.view)
        if self.bottomSheetVC.view.frame.contains(touchLocation) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadCoachMark()
        self.addBottomSheetView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        bottomSheetVC.closePullUp()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomSheetVC.view.dropShadow(color: UIColor.black16, opacity: 0.16, offSet: CGSize(width: 0, height: -3), radius: 10, scale: true)
        self.view.layoutIfNeeded()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func settingBtnTapped(_ sender: UIButton) {
        self.gotoSettingVC()
    }
    
    @IBAction func historyBtnTapped(_ sender: UIButton) {
        let vc = SessionHistoryVC.instantiate(fromAppStoryboard: .CGPStoryboard)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func manualBtnTapped(_ sender: UIButton) {
        bottomSheetVC.closePullUp()
        AppUserDefaults.save(value: false, forKey: .homeCoachMarkShown)
        self.loadCoachMark()
    }
    
    @IBAction func infoBtnTapped(_ sender: Any) {
        let vc = SessionDescriptionVC.instantiate(fromAppStoryboard: .CGPStoryboard)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Extension For Functions
//===========================
extension HomeVC {
    private func initialSetup() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.setupHealthkit()
        self.addObserver()
        BleManager.sharedInstance.delegate = self
        if BleManager.sharedInstance.myperipheral?.state == .connected{
            self.setupSystemInfo()
        }else{
            self.setupSystemInfo()
        }
        CommonFunctions.showActivityLoader()
        self.getUserInfoFromFirestore()
        self.getUserSystemFromFirestore()
        self.getCGMDataFromFirestore()
        self.getInsulinFromFirestore()
    }
    
    private func setupHealthkit(){
        HealthKitManager.sharedInstance.authorizeHealthKit { (isEnable, error) in
            if let error = error{
                print(error.localizedDescription)
            }else {
                print(isEnable)
                print(HKHealthStore.isHealthDataAvailable())
            }
        }
    }
    
    private func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(bleDidUpdateValue), name: .BleDidUpdateValue, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(bLEOnOffStateChanged), name: .BLEOnOffState, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(bLEDidDisConnected), name: .BLEDidDisConnectSuccessfully, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cgmDataReceivedSuccessfully), name: .CgmDataReceivedSuccessfully, object: nil)
    }
    
    private func getCGMDataFromFirestore(){
        FirestoreController.checkCGMDataExistInDatabase {
            FirestoreController.getFirebaseCGMData { (cgmDataArray) in
                print(cgmDataArray)
                SystemInfoModel.shared.cgmData = cgmDataArray
                self.bottomSheetVC.cgmData = cgmDataArray
            } failure: { (error) -> (Void) in
                print(error.localizedDescription)
            }
        } failure: {
            print("CGM DATA NOT Available")
            if let cgmData = SystemInfoModel.shared.cgmData {
                self.bottomSheetVC.cgmData = cgmData
                for cgmModel in cgmData {
                    FirestoreController.createCGMDataNode(direction: cgmModel.direction ?? "", sgv: cgmModel.sgv, date: cgmModel.date)
                }
            }
        }
    }
    
    private func getUserSystemFromFirestore(){
        FirestoreController.getUserSystemInfoData {
            print("Successfully")
        } failure: { (error) -> (Void) in
            CommonFunctions.showToastWithMessage(error.localizedDescription)
        }
    }
    
    private func getUserInfoFromFirestore(){
        FirestoreController.getFirebaseUserData {
            CommonFunctions.hideActivityLoader()
        } failure: { (error) -> (Void) in
            CommonFunctions.hideActivityLoader()
            CommonFunctions.showToastWithMessage(error.localizedDescription)
        }
    }
    
    private func getInsulinFromFirestore(){
        FirestoreController.getFirebaseInsulinData { (insulinDataArray) in
            print(insulinDataArray)
            SystemInfoModel.shared.insulinData = insulinDataArray
            self.bottomSheetVC.mainTableView.reloadData()
        } failure: { (error) -> (Void) in
            print(error.localizedDescription)
        }
    }
    
    @objc func bleDidUpdateValue(notification : NSNotification){
        if let dict = notification.object as? NSDictionary {
                print(dict)
        }
        self.setupSystemInfo()
    }
    
    @objc func cgmDataReceivedSuccessfully(notification : NSNotification){
        self.bottomSheetVC.cgmData = SystemInfoModel.shared.cgmData ?? []
        self.setupSystemInfo()
    }
    
    @objc func bLEOnOffStateChanged(){
        self.setupSystemInfo()
    }
    
    @objc func bLEDidDisConnected(){
        self.setupSystemInfo()
        CommonFunctions.showToastWithMessage("Bluetooth Disconnected.")
    }
    
    func addBottomSheetView() {
        guard !self.children.contains(bottomSheetVC) else {
            return
        }
        self.addChild(bottomSheetVC)
        self.view.insertSubview(bottomSheetVC.view, belowSubview: self.topNavView)
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
        if UIScreen.main.bounds.size.height <= 812 {
            bottomSheetVC.bottomLayoutConstraint.constant = self.view.safeAreaInsets.bottom + (self.tabBarController?.tabBar.height ?? 0)
        }
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: self.tabBarController?.tabBar.frame.height ?? 30, right: 0)
        bottomSheetVC.mainTableView.contentInset = adjustForTabbarInsets
        bottomSheetVC.mainTableView.scrollIndicatorInsets = adjustForTabbarInsets
        let globalPoint = bottomStackView.superview?.convert(bottomStackView.frame.origin, to: nil)
        bottomSheetVC.textContainerHeight = (globalPoint?.y ?? 0.0)
        self.view.layoutIfNeeded()
    }
    
    func gotoSettingVC(){
        let vc = SettingsVC.instantiate(fromAppStoryboard: .PostLogin)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupSystemInfo(){
        let batteryData = BleManager.sharedInstance.batteryData
        let reservoirData = BleManager.sharedInstance.reservoirLevelData
        let data = BleManager.sharedInstance.systemStatusData
        
        self.batteryImgView.image = DeviceStatus.getBatteryImage(value:batteryData).1
        if DeviceStatus.getBatteryImage(value:batteryData).0.isEmpty{
            self.batteryStatusLbl.alpha = 0
            self.batteryImgView.alpha = 0
            self.batteryEmptyLbl.isHidden = false
        }else {
            self.batteryEmptyLbl.isHidden = true
            self.batteryStatusLbl.alpha = 100
            self.batteryImgView.alpha = 100
            self.batteryStatusLbl.text = DeviceStatus.getBatteryImage(value:batteryData).0
        }
        self.batteryTitleLbl.text = DeviceStatus.Battery.titleString
        
        self.reservoirImgView.image = DeviceStatus.getReservoirImage(value:reservoirData).1
        if DeviceStatus.getReservoirImage(value:reservoirData).0.isEmpty{
            self.reservoirStatusLbl.alpha = 0
            self.reservoirImgView.alpha = 0
            self.reservoirEmptyLbl.isHidden = false
        }else {
            self.reservoirImgView.alpha = 100
            self.reservoirEmptyLbl.isHidden = true
            self.reservoirStatusLbl.alpha = 100
            self.reservoirStatusLbl.text = DeviceStatus.getReservoirImage(value:reservoirData).0
        }
        self.reservoirTitleLbl.text = DeviceStatus.ReservoirLevel.titleString
        
        self.systemImgView.image = DeviceStatus.getSystemImage(value:data).1
        if DeviceStatus.getSystemImage(value:data).0.isEmpty{
            self.systemStatusLbl.alpha = 0
        }else {
            self.systemStatusLbl.alpha = 100
            self.systemStatusLbl.text = DeviceStatus.getSystemImage(value:data).0
            self.systemStatusLbl.textColor = DeviceStatus.getSystemImage(value:data).2
        }
        self.systemTitleLbl.text = DeviceStatus.System.titleString
    }
}

// MARK: - Extension For BleProtocol
//===========================
extension HomeVC: BleProtocol{
    func didBleOff() {
        self.setupSystemInfo()
    }
    
    func didConnect(name: String) {
    }
    
    func didUpdateValue(){
    }
}

// MARK: - Extension For loadCoachMark
//===========================
extension HomeVC{
    private func loadCoachMark(){
        DispatchQueue.main.async {
            
            self.coachMarksController.dataSource = self
            self.coachMarksController.delegate = self
            self.coachMarksController.overlay.allowTap = true
            self.coachMarksController.overlay.blurEffectStyle = .light
            
            if AppUserDefaults.value(forKey: .homeCoachMarkShown).boolValue == false {
                self.coachMarksController.start(in: .window(over: self))
                AppUserDefaults.save(value: true, forKey: .homeCoachMarkShown)
            }
            
        }
    }
}

// MARK: - Extension For CoachMarksControllerDelegate
//===========================
extension HomeVC: CoachMarksControllerDataSource, CoachMarksControllerDelegate{
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 2
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        
        let coachMarkBodyView = CoachMarkViewApp()
        var coachMarkArrowView: TransparentCoachMarkArrowView? = nil
        
        switch index {
        case 0:
            coachMarkBodyView.hintLabel.text = "The battery must be fully charged prior to starting a session.It’s a good habit to plug your device into a charger whenever it’s not in use. In fact, go ahead and charge it now!"
            coachMarkBodyView.hintLabel.textAlignment = .left
            coachMarkBodyView.nextButton.setTitle(LocalizedString.ok.localized.capitalized, for: .normal)
            
        default:
            coachMarkBodyView.hintLabel.text = "Make sure you read the user manual before you start with your Luna system.You can access it now or later from the top of your screen."
            coachMarkBodyView.hintLabel.textAlignment = .right
            coachMarkBodyView.nextButton.setTitle("Got it", for: .normal)
        }
        
        if let arrowOrientation = coachMark.arrowOrientation {
            coachMarkArrowView = TransparentCoachMarkArrowView(orientation: arrowOrientation)
        }
        
        return (bodyView: coachMarkBodyView, arrowView: coachMarkArrowView)
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        
        var coachMark: CoachMark
        
        switch index {
        case 0:
            coachMark = coachMarksController.helper.makeCoachMark(for: batteryStackView)
            coachMark.arrowOrientation = .top
        default:
            coachMark = coachMarksController.helper.makeCoachMark(for: topManualButton)
            coachMark.arrowOrientation = .bottom
        }
        coachMark.gapBetweenCoachMarkAndCutoutPath = 6.0
        
        return coachMark
    }
    
}


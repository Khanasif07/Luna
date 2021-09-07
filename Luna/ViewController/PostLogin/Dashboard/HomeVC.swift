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
    
    @IBOutlet weak var batteryTitleLbl: UILabel!
    @IBOutlet weak var batteryStatusLbl: UILabel!
    @IBOutlet weak var batteryImgView: UIImageView!
    
    @IBOutlet weak var reservoirStatusLbl: UILabel!
    @IBOutlet weak var reservoirImgView: UIImageView!
    @IBOutlet weak var reservoirTitleLbl: UILabel!
    
    @IBOutlet weak var systemStatusLbl: UILabel!
    @IBOutlet weak var systemImgView: UIImageView!
    @IBOutlet weak var systemTitleLbl: UILabel!
    // MARK: - Variables
    //==========================
    let bottomSheetVC = HomeBottomSheetVC()
    
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        bottomSheetVC.closePullUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addBottomSheetView()
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
        HealthKitManager.sharedInstance.write([InsulinModel(raw: 100, id: 1, date: Date())])
        HealthKitManager.sharedInstance.read { (insulinModels) in
            print(insulinModels)
            print("Data Read successfully.")
        }
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
        }
        CommonFunctions.showActivityLoader()
        FirestoreController.getFirebaseUserData {
            CommonFunctions.hideActivityLoader()
        } failure: { (error) -> (Void) in
            CommonFunctions.hideActivityLoader()
            CommonFunctions.showToastWithMessage(error.localizedDescription)
        }
        FirestoreController.getUserSystemInfoData {
            print("Successfully")
        } failure: { (error) -> (Void) in
            CommonFunctions.showToastWithMessage(error.localizedDescription)
        }
        FirestoreController.getFirebaseCGMData { (cgmDataArray) in
            print(cgmDataArray)
            SystemInfoModel.shared.cgmData = cgmDataArray
            self.bottomSheetVC.cgmData = cgmDataArray
        } failure: { (error) -> (Void) in
            print(error.localizedDescription)
        }
        FirestoreController.getFirebaseInsulinData { (insulinDataArray) in
            print(insulinDataArray)
            SystemInfoModel.shared.insulinData = insulinDataArray
            self.bottomSheetVC.mainTableView.reloadData()
        } failure: { (error) -> (Void) in
            print(error.localizedDescription)
        }
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
    }
    
    @objc func bleDidUpdateValue(notification : NSNotification){
        if let dict = notification.object as? NSDictionary {
                print(dict)
        }
        print("BleDidUpdateValue")
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
        self.batteryStatusLbl.text = DeviceStatus.getBatteryImage(value:batteryData).0
        self.batteryTitleLbl.text = DeviceStatus.Battery.titleString
        
        self.reservoirImgView.image = DeviceStatus.getReservoirImage(value:reservoirData).1
        self.reservoirStatusLbl.text = DeviceStatus.getReservoirImage(value:reservoirData).0
        self.reservoirTitleLbl.text = DeviceStatus.ReservoirLevel.titleString
        
        self.systemImgView.image = DeviceStatus.getSystemImage(value:data).1
        self.systemStatusLbl.text = DeviceStatus.getSystemImage(value:data).0
        self.systemTitleLbl.text = DeviceStatus.System.titleString
    }
}


extension HomeVC: BleProtocol{
    func didBleOff() {
        self.setupSystemInfo()
    }
    
    func didConnect(name: String) {
        print(name)
    }
    
    func didUpdateValue(){
//        self.setupSystemInfo()
    }
}



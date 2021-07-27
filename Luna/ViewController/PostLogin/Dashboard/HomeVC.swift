//
//  HomeVC.swift
//  Luna
//
//  Created by Admin on 24/06/21.
//
import CoreBluetooth
import UIKit

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
        showAlert(msg: "Under Development")
    }
    
    @IBAction func manualBtnTapped(_ sender: UIButton) {
        showAlert(msg: "Under Development")
    }
    
    @IBAction func infoBtnTapped(_ sender: Any) {
        showAlert(msg: "Under Development")
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension HomeVC {
    
    private func initialSetup() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        FirestoreController.getFirebaseUserData {
            AppUserDefaults.save(value: UserModel.main.isBiometricOn, forKey: .isBiometricSelected)
        } failure: { (error) -> (Void) in
            CommonFunctions.showToastWithMessage(error.localizedDescription)
        }
        FirestoreController.getUserSystemInfoData {
            print("Successfully")
        } failure: { (error) -> (Void) in
            CommonFunctions.showToastWithMessage(error.localizedDescription)
        }
        BleManager.sharedInstance.delegate = self
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
        CommonFunctions.delay(delay: 0.0) {
            DispatchQueue.main.async {
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
    }
}


// MARK: - Extension For CBPeripheralDelegate
//===========================
//extension HomeVC: CBPeripheralDelegate {
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        guard let services = peripheral.services else { return }
//        for service in services {
//            print(service)
//            peripheral.discoverCharacteristics(nil, for: service)
//        }
//
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
//                    error: Error?) {
//        guard let characteristics = service.characteristics else { return }
//
//        for characteristic in characteristics {
//            print(characteristic)
//            if characteristic.properties.contains(.read) {
//                print("\(characteristic.uuid): properties contains .read")
//                peripheral.readValue(for: characteristic)
//            }
//            if characteristic.properties.contains(.notify) {
//                print("\(characteristic.uuid): properties contains .notify")
//                peripheral.setNotifyValue(true, for: characteristic)
//            }
//        }
//    }
//    
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        print(characteristic.uuid)
//        switch characteristic.uuid {
//        case batteryCharacteristicCBUUID:
//            writeValue(myCharacteristic: characteristic)
//            print(String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? "")
//            let data = String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? ""
//            self.batteryImgView.image = DeviceStatus.getBatteryImage(value:data).1
//            self.batteryStatusLbl.text = DeviceStatus.getBatteryImage(value:data).0
//            self.batteryTitleLbl.text = DeviceStatus.Battery.titleString
//            print("handled Characteristic Value for Battery: \(String(describing: characteristic.value))")
//        case ReservoirLevelCharacteristicCBUUID:
//            writeValue(myCharacteristic: characteristic,value: "3")
//            print(String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? "")
//            print("handled Characteristic Value for Reservoir Level: \(String(describing: characteristic.value))")
//            let data = String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? ""
//            self.reservoirImgView.image = DeviceStatus.getReservoirImage(value:data).1
//            self.reservoirStatusLbl.text = DeviceStatus.getReservoirImage(value:data).0
//            self.reservoirTitleLbl.text = DeviceStatus.ReservoirLevel.titleString
//        case statusCBUUID:
//            writeValue(myCharacteristic: characteristic,value: "0")
//            print(String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? "")
//            print("handled Characteristic Value for status : \(String(describing: characteristic.value))")
//            let data = String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? ""
//            self.systemImgView.image = DeviceStatus.getSystemImage(value:data).1
//            self.systemStatusLbl.text = DeviceStatus.getSystemImage(value:data).0
//            self.systemTitleLbl.text = DeviceStatus.System.titleString
//        default:
//            print("Unhandled Characteristic UUID: \(characteristic.value)")
//        }
//    }
//}



// MARK: - Extension For CBCentralManagerDelegate
//===========================
//extension HomeVC: CBCentralManagerDelegate {
//
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        switch central.state {
//          case .unknown:
//            print("central.state is .unknown")
//          case .resetting:
//            print("central.state is .resetting")
//          case .unsupported:
//            print("central.state is .unsupported")
//          case .unauthorized:
//            print("central.state is .unauthorized")
//          case .poweredOff:
//            print("central.state is .poweredOff")
//          case .poweredOn:
//            print("central.state is .poweredOn")
//            centralManager.scanForPeripherals(withServices: nil,options: nil)
//        }
//    }
//
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
//                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
//        print(peripheral.name)
//        print(peripheral.identifier)
//        heartRatePeripheral = peripheral
//        heartRatePeripheral.delegate = self
//        centralManager.stopScan()
//        centralManager.connect(heartRatePeripheral, options: nil)
//    }
//
//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//      print("Connected!")
//      isMyPeripheralConected = true
//      heartRatePeripheral.discoverServices(nil)
//    }
//
//    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
//        print("DisConnected!")
//        isMyPeripheralConected = false
//        central.connect(peripheral, options: nil)
//    }
//
//
//
//}

extension HomeVC: BleProtocol{
    func didBleOff() {
        self.setupSystemInfo()
    }
    
    func didConnect(name: String) {
        print(name)
    }
    
    func didUpdateValue(){
        self.setupSystemInfo()
    }
}

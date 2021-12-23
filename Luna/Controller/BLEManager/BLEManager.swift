//
//  BLEManager.swift
//  Luna
//
//  Created by Admin on 01/07/21.
//

import Foundation
import CoreBluetooth
import UIKit

let batteryCharacteristicCBUUID = CBUUID(string: "378EC9D6-075C-4BF6-89DC-9F0D6EA3B5C4")
let ReservoirLevelCharacteristicCBUUID = CBUUID(string: "378ec9d6-075c-4bf6-89dc-0c6f73b4b761")
let statusCBUUID = CBUUID(string: "378ec9d6-075c-4bf6-89dc-a6d767548715")
let firmwareRevisionString = CBUUID(string: "2A26")
let writableCharacteristicCBUUID = CBUUID(string: "aa6b9004-9da2-4f80-9001-409abcc3dcef")
let dataInCBUUID = CBUUID(string: "aa9ec828-43ba-4281-a122-48932207c8f3")
let dataOutCBUUID = CBUUID(string: "aa9ec828-43ba-4281-a122-d17566d67c42")
let lunaCBUUID = CBUUID(string: "DE612C8C-46C0-46B6-B820-4C92A6E67D97")
let IOBout = CBUUID(string: "378ec9d6-075c-4bf6-89dc-0a8267f7b7b7")
let TDBD = CBUUID(string: "5927a433-a277-40b7-b2d4-e005330c5d99")
let iobInput = CBUUID(string: "5927a433-a277-40b7-b2d4-92ff77eada32")
//let WriteAcknowledgement = CBUUID(string: "5927a433-a277-40b7-b2d4-0242ac130003")
let WriteAcknowledgement = CBUUID(string: "5927A433-A277-40B7-B2D4-B6FF29B861A6")
let CGMWriteCharacteristicCBUUID = CBUUID(string: "5927a433-a277-40b7-b2d4-d1ce2ffefef9")
let collectionInsulinDoses = CBUUID(string: "ad4e6052-390a-4107-8e2d-11af2d258189")
//

@objc public protocol BleProtocol {
    @objc optional func didDiscover(name:String, rssi:NSNumber)
    @objc optional func didConnect(name:String)
    @objc optional func didDisconnect()
    @objc optional func didBleReady()
    @objc optional func didBleOff()
    @objc optional func didUpdateValue()
    @objc optional func didReadRSSI(rssi:NSNumber)
    @objc optional func log(message:String)
    @objc optional func didNotDiscoverPeripheral()
}

public class BleManager: NSObject{
    public static let sharedInstance = BleManager()
    
    public var delegate :BleProtocol?
    var centralManager :CBCentralManager!
    var peripheralManager :CBPeripheralManager!
    var myperipheral :CBPeripheral?
    var mychar :CBCharacteristic!
    var myservice :CBService?
    //    var peripherals :[peripheralWithRssi]!
    var cgmWriteCBCharacteristic : CBCharacteristic?
    var cgmDataInCharacteristic : CBCharacteristic?
    var rescanTimer :Timer?
    var batteryData: String = ""
    var reservoirLevelData: String = ""
    var systemStatusData : String = ""
    var iobData: Double = 0.0
    var insulinData : [ShareGlucoseData] = []
    var isKeepConnect = true
    var isConnect :Bool = false
    var isScanning :Bool = false
    var isMyPeripheralConected :Bool = false
    var isAdvertising :Bool = false
    var isUnpaired :Bool = false
    var statusTimer = Timer()
    
    private override init (){
        super.init ()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    private convenience init (delegate: BleProtocol){
        self.init ()
        self.delegate = delegate
    }
    
    public func myInit (){}
    
    public func beginScan(){
        if isScanning == false{
            isKeepConnect = true
//            self.centralManager.scanForPeripherals(withServices: [lunaCBUUID], options: nil)
            self.centralManager.scanForPeripherals(withServices: [], options: nil)
            self.rescanTimer =  Timer.scheduledTimer(timeInterval: 15,
                                                     target: self,
                                                     selector: #selector(scanningFinished),
                                                     userInfo: nil,
                                                     repeats: true)
        }
    }
    
    /**
     stop scan ble device
     */
    public func breakScan(){
        rescanTimer?.invalidate()
        rescanTimer = nil
        centralManager.stopScan()
        isScanning = false
    }
    
    public func disConnect (){
        isKeepConnect = false
        isUnpaired = true
        centralManager.cancelPeripheralConnection(myperipheral!)
    }
    
    
    public func writeValue(myCharacteristic: CBCharacteristic,value: String = "50") {
        if isMyPeripheralConected { //check if myPeripheral is connected to send data
            let dataToSend: Data = value.data(using: String.Encoding.utf8)!
            myperipheral?.writeValue(dataToSend as Data, for: myCharacteristic, type: CBCharacteristicWriteType.withResponse)    //Writing the data to the peripheral
        } else {
            print("Not connected")
        }
    }
    
    public func writeCGMTimeStampValue(value: String = "50") {
        if isMyPeripheralConected { //check if myPeripheral is connected to send data
            let dataToSend: Data = value.data(using: String.Encoding.utf8)!
            if let  cgmWriteCBCharacteristic = self.cgmWriteCBCharacteristic{
                myperipheral?.writeValue(dataToSend as Data, for: cgmWriteCBCharacteristic , type: CBCharacteristicWriteType.withResponse)
            }
        } else {
            print("Not connected")
        }
    }
    
    @objc func scanningFinished(){
        if let peripheral = myperipheral{
            if !isMyPeripheralConected && peripheral.state != .connected{
                if(centralManager != nil && centralManager.isScanning){
                    print("stopping scan")
                    self.breakScan()
                    rescanTimer?.invalidate()
                    rescanTimer = nil
                    self.delegate?.didNotDiscoverPeripheral?()
                }
                
            }
        }else{
            if !isMyPeripheralConected {
                if(centralManager != nil && centralManager.isScanning){
                    print("stopping scan")
                    self.breakScan()
                    rescanTimer?.invalidate()
                    rescanTimer = nil
                    self.delegate?.didNotDiscoverPeripheral?()
                }
            }
        }
        rescanTimer?.invalidate()
        rescanTimer = nil
    }
    
    func startStatusTimer(time: TimeInterval =  60 * 5) {
        statusTimer = Timer.scheduledTimer(timeInterval: time,
                                       target: self,
                                       selector: #selector(self.statusTimerDidEnd(_:)),
                                       userInfo: nil,
                                       repeats: false)
    }
    
    @objc func statusTimerDidEnd(_ timer:Timer) {
        if !isMyPeripheralConected {
            self.batteryData = ""
            self.reservoirLevelData = ""
            self.iobData = 0.0
            NotificationCenter.default.post(name: Notification.Name.BleDidUpdateValue, object: [:])
            self.delegate?.didDisconnect?()
        }
        DispatchQueue.main.async {
            if self.statusTimer.isValid {
                self.statusTimer.invalidate()
            }
        }
    }
    
    private func getRangeValue(bgData: [ShareGlucoseData],isShowPer: Bool = false)-> Double{
        if bgData.endIndex > 0 {
            let rangeArray = bgData.filter { (glucoseValue) -> Bool in
                return glucoseValue.sgv >= Int((UserDefaultsRepository.lowLine.value)) && glucoseValue.sgv <= Int((UserDefaultsRepository.highLine.value))
            }
            if isShowPer {
                let rangePercentValue = ((100 * (rangeArray.endIndex)) / (bgData.endIndex))
                return Double(rangePercentValue)
            } else {
                let rangePercentValue = (Double(rangeArray.endIndex) / Double(bgData.endIndex))
                return rangePercentValue
            }
        }
        return 0.0
    }
    
    private func getInsulinDosesValue(bgData: [ShareGlucoseData],isShowPer: Bool = false)-> Int{
        if bgData.endIndex > 0 {
            let rangeArray = bgData.filter { (glucoseValue) -> Bool in
                return glucoseValue.insulin == "0.5"
            }
            return (rangeArray.endIndex)
        }
        return 0
    }
    
    private func manageInsulinData(data: [[String]],bytes: Int){
        //
        let now = dateTimeUtils.getNowTimeIntervalUTC()
        if let fetchedData = UserDefaults.standard.data(forKey: ApiKey.dosingHistoryData) {
            let fetchedDosingData = try! JSONDecoder().decode([DosingHistory].self, from: fetchedData)
            if !fetchedDosingData.isEmpty{SystemInfoModel.shared.dosingData = fetchedDosingData}
        }
        data.forEach { (tupls) in
            let insulin =  ((tupls.first ?? "") == "BEGIN" ? "0.25" : ((tupls.first ?? "") == "END" ? "0.75" : "0.5"))
            let  dosing = DosingHistory(sessionStatus: tupls.first ?? "", sessionTime: Double(tupls.last ?? "") ?? 0.0, insulin: insulin, sessionExpired: false,sessionCreated: false)
            if !SystemInfoModel.shared.dosingData.contains(where: {$0.sessionTime == dosing.sessionTime}){
                if (SystemInfoModel.shared.dosingData.last?.sessionStatus) == dosing.sessionStatus && dosing.sessionStatus == "BEGIN" {
                    SystemInfoModel.shared.dosingData.removeLast()
                    SystemInfoModel.shared.dosingData.append(dosing)
                }else if (SystemInfoModel.shared.dosingData.last?.sessionStatus) == dosing.sessionStatus && dosing.sessionStatus == "END"{
                    SystemInfoModel.shared.dosingData.append(dosing)
                    SystemInfoModel.shared.dosingData.removeLast()
                }else{
                    if dosing.sessionTime > SystemInfoModel.shared.dosingData.last?.sessionTime ?? 0.0 {
                        SystemInfoModel.shared.dosingData.append(dosing)
                    }
                }
            }
        }
        //
        SystemInfoModel.shared.dosingData = SystemInfoModel.shared.dosingData.filter({ (now - $0.sessionTime <= 86400.0)})
        UserDefaultsRepository.sessionStartDate.value = 0.0
        UserDefaultsRepository.sessionEndDate.value  = 0.0
        //
        if let firstBeginSession = SystemInfoModel.shared.dosingData.firstIndex(where: { $0.sessionStatus == "BEGIN" && $0.sessionCreated == false
        }){
            UserDefaultsRepository.sessionStartDate.value = SystemInfoModel.shared.dosingData[firstBeginSession].sessionTime
            for firstEndSession in stride(from: firstBeginSession + 1, to: SystemInfoModel.shared.dosingData.count, by: 1){
                if SystemInfoModel.shared.dosingData[firstEndSession].sessionStatus == "END" && SystemInfoModel.shared.dosingData[firstEndSession].sessionCreated == false{
                    UserDefaultsRepository.sessionEndDate.value = SystemInfoModel.shared.dosingData[firstEndSession].sessionTime
                    break
                }
            }
        }
        if UserDefaultsRepository.sessionStartDate.value != 0.0 && UserDefaultsRepository.sessionEndDate.value != 0.0{
            let startSessionIndex = SystemInfoModel.shared.cgmData?.firstIndex(where: {$0.date == UserDefaultsRepository.sessionStartDate.value})
            let endSessionIndex = SystemInfoModel.shared.cgmData?.firstIndex(where: {$0.date == UserDefaultsRepository.sessionEndDate.value})
            if let startIndex = startSessionIndex,let endIndex = endSessionIndex{
                let myRange: ClosedRange = (startIndex)...(endIndex)
                //
                SystemInfoModel.shared.dosingData.forEach { (dosingHistory) in
                    if let indexx = SystemInfoModel.shared.cgmData?.firstIndex(where: { (bgData) -> Bool in
                        bgData.date == dosingHistory.sessionTime
                    }){
                        SystemInfoModel.shared.cgmData?[indexx].insulin = dosingHistory.insulin
                    }
                }
                //
                let rangeBgData = (SystemInfoModel.shared.cgmData?[myRange] ?? []).map { (bgData) -> ShareGlucoseData in
                    ShareGlucoseData(sgv: bgData.sgv, date: bgData.date, direction: bgData.direction ?? "", insulin: bgData.insulin ?? "")
                }
                let startSession = SystemInfoModel.shared.dosingData.firstIndex(where: {$0.sessionTime == UserDefaultsRepository.sessionStartDate.value})
                let endSession = SystemInfoModel.shared.dosingData.firstIndex(where: {$0.sessionTime == UserDefaultsRepository.sessionEndDate.value})
                if let startIndexx = startSession,let endIndexx = endSession{
                    SystemInfoModel.shared.dosingData[startIndexx].sessionCreated = true
                    SystemInfoModel.shared.dosingData[endIndexx].sessionCreated = true
                }
                let dosingData = try! JSONEncoder().encode(SystemInfoModel.shared.dosingData)
                UserDefaults.standard.set(dosingData, forKey: ApiKey.dosingHistoryData)
                //
                FirestoreController.addBatchData(sessionId: FirestoreController.getSessionId(), startDate: UserDefaultsRepository.sessionStartDate.value, endDate: UserDefaultsRepository.sessionEndDate.value, array: rangeBgData) { (sessionId) in
                    print("Add CGM Batch Data Commited successfully")
                    if UserDefaultsRepository.sessionStartDate.value != 0.0 && UserDefaultsRepository.sessionEndDate.value != 0.0 {
                        FirestoreController.simpleTransactionToAddCGMData(sessionId: sessionId,startDate:UserDefaultsRepository.sessionStartDate.value,range: self.getRangeValue(bgData: rangeBgData, isShowPer: true),endDate: UserDefaultsRepository.sessionEndDate.value,insulin: self.getInsulinDosesValue(bgData: rangeBgData))
                    }
                    UserDefaultsRepository.sessionStartDate.value = 0.0
                    UserDefaultsRepository.sessionEndDate.value = 0.0
                }
            }
        }
        //
        if SystemInfoModel.shared.dosingData.endIndex > 0 {
//            let dosingData = try! JSONEncoder().encode(SystemInfoModel.shared.dosingData)
//            UserDefaults.standard.set(dosingData, forKey: ApiKey.dosingHistoryData)
            SystemInfoModel.shared.dosingData.forEach { (dosingHistory) in
                if let indexx = SystemInfoModel.shared.cgmData?.firstIndex(where: { (bgData) -> Bool in
                    bgData.date == dosingHistory.sessionTime
                }){
                    SystemInfoModel.shared.cgmData?[indexx].insulin = dosingHistory.insulin
                }
            }
            let dosingData = try! JSONEncoder().encode(SystemInfoModel.shared.dosingData)
            UserDefaults.standard.set(dosingData, forKey: ApiKey.dosingHistoryData)
        }
        if let dataInCharacteristic = self.cgmDataInCharacteristic{
            if !data.isEmpty && bytes > 1{
                CommonFunctions.delay(delay: 2.5) {
                    self.writeValue(myCharacteristic: dataInCharacteristic,value: "#CLEAR_DOSE_DATA")
                }
            }
        }
        NotificationCenter.default.post(name: Notification.Name.BleDidUpdateValue, object: [:])
        print(SystemInfoModel.shared.dosingData)
    }
}
// MARK: - Extension For CBPeripheralDelegate
//===========================
extension BleManager: CBPeripheralDelegate {
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            print("Service discovery failed")
            //TODO: Disconnect?
            return
        }
        guard let services = peripheral.services else { return }
        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
        
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                           error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            if characteristic.properties.contains(.read) {
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
            if characteristic.properties.contains(.indicate){
                peripheral.setNotifyValue(true, for: characteristic)
            }
            if characteristic.properties.contains(.write) {
                switch characteristic.uuid {
                case dataInCBUUID:
                    self.cgmDataInCharacteristic = characteristic
                    peripheral.setNotifyValue(true, for: characteristic)
                case iobInput:
                    writeValue(myCharacteristic: characteristic,value:  "8")
                    peripheral.setNotifyValue(true, for: characteristic)
                case CBUUID(string: "5927a433-a277-40b7-b2d4-d1ce2ffefef9"):
                    self.cgmWriteCBCharacteristic = characteristic
                case dataOutCBUUID:
                    peripheral.setNotifyValue(true, for: characteristic)
                case batteryCharacteristicCBUUID:
                    peripheral.setNotifyValue(true, for: characteristic)
                case ReservoirLevelCharacteristicCBUUID:
                    peripheral.setNotifyValue(true, for: characteristic)
                case statusCBUUID:
                    peripheral.setNotifyValue(true, for: characteristic)
                case TDBD:
                    writeValue(myCharacteristic: characteristic,value:  "8")
                default:
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
        case batteryCharacteristicCBUUID:
            print("handled Characteristic Value for Battery Level: \(String(describing: characteristic.value))")
            let data = String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? ""
            self.batteryData = data
            NotificationCenter.default.post(name: Notification.Name.BatteryUpdateValue, object: nil)
        case ReservoirLevelCharacteristicCBUUID:
            print("handled Characteristic Value for Reservoir Level: \(String(describing: characteristic.value))")
            let data = String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? ""
            AppUserDefaults.save(value: data == "-1" ? "" : data, forKey: .reservoirLevel)
            self.reservoirLevelData = data
            NotificationCenter.default.post(name: Notification.Name.ReservoirUpdateValue, object: nil)
        case statusCBUUID:
            print("handled Characteristic Value for status : \(String(describing: characteristic.value))")
            let data = String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? ""
            self.systemStatusData = data
            NotificationCenter.default.post(name: Notification.Name.StatusUpdateValue, object: nil)
        case firmwareRevisionString:
            let data = String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? ""
            print("handled Characteristic Value for firmwareRevisionString:  \(data)")
        case writableCharacteristicCBUUID:
            let data = String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? ""
            print(data)
        case dataInCBUUID:
            print("handled Characteristic Value for dataInCBUUID: \(String(describing: characteristic.value))")
        case dataOutCBUUID:
            let data = String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? ""
            let dataArray = data.split{$0 == ";"}.map(String.init)
            let filterDataArray = dataArray.map { (stringValue) -> [String] in
                return stringValue.split{$0 == ":"}.map(String.init)
            }
            CommonFunctions.delay(delay: 2.5) {
                if !filterDataArray.isEmpty{
                    self.manageInsulinData(data: filterDataArray,bytes: characteristic.value?.count ?? 0)
                }
            }
            print("handled Characteristic Value for dataOutCBUUID: \(String(describing: data))")
        case CBUUID(string: "5927a433-a277-40b7-b2d4-5bf796c0053c"):
            print("handled Characteristic Value for: \(String(describing: characteristic.value))")
        case CBUUID(string: "5927a433-a277-40b7-b2d4-d1ce2ffefef9"):
            print("handled Characteristic Value for: \(String(describing: characteristic.value))")
        case IOBout:
            let data = String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? ""
            self.iobData = (Double(data) ?? 0.0).roundToDecimal(1)
            NotificationCenter.default.post(name: Notification.Name.ReservoirUpdateValue, object: nil)
            print("handled Characteristic Value for IOBout:  \(data)")
        case WriteAcknowledgement:
            let data = String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? ""
            print("handled Characteristic Value for WriteAcknowledgement:  \(data)")
            if let dataInCharacteristic = self.cgmDataInCharacteristic{
                writeValue(myCharacteristic: dataInCharacteristic,value: "#GET_DOSE_DATA")
            }
        case collectionInsulinDoses:
            let data = String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? ""
            print("handled Characteristic Value for collectionInsulinDoses:  \(data)")
        default:
            let data = String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? ""
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
            print(data)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if error == nil {
            print("Message sent=======>\(String(describing: characteristic.value))")
        }else{
            print("Message Not sent=======>\(String(describing: error))")
        }
    }
}



// MARK: - Extension For CBCentralManagerDelegate
//===========================
extension BleManager: CBCentralManagerDelegate {
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
            self.systemStatusData = ""
            NotificationCenter.default.post(name: Notification.Name.BLEOnOffState, object: nil)
        case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: [],options: nil)
            self.rescanTimer =  Timer.scheduledTimer(timeInterval: 15,
                                                     target: self,
                                                     selector: #selector(scanningFinished),
                                                     userInfo: nil,
                                                     repeats: true)
        @unknown default:
            print("unknown defaul")
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                               advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print(peripheral.name ?? "")
        print(peripheral.identifier)
        if peripheral.name == AppConstants.appName{
        myperipheral = peripheral
        myperipheral?.delegate = self
        centralManager.stopScan()
        centralManager.connect(myperipheral!, options: [CBConnectPeripheralOptionNotifyOnConnectionKey:true, CBConnectPeripheralOptionNotifyOnDisconnectionKey: true])
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        //MARK:- STATIC DATA USING
        isMyPeripheralConected = true
        myperipheral?.discoverServices(nil)
        CommonFunctions.showToastWithMessage("Bluetooth connected.")
        delegate?.didConnect?(name: "Bluetooth connected.")
    }
    
    public func centralManager (_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("DisConnected!")
        if !isUnpaired{
            systemStatusData = ""
            centralManager.connect(peripheral, options: nil)}
        else{
            systemStatusData = ""
            batteryData = ""
            reservoirLevelData = ""
            iobData = 0.0
        }
        isUnpaired = false
        isMyPeripheralConected = false
        NotificationCenter.default.post(name: Notification.Name.BLEDidDisConnectSuccessfully, object: nil)
        if !isUnpaired{
            DispatchQueue.main.async {
                if self.statusTimer.isValid {
                    self.statusTimer.invalidate()
                }
                self.startStatusTimer()
            }
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        guard error == nil else {
            print("didFailToConnect")
            return
        }
        isMyPeripheralConected = false
        delegate?.didDisconnect?()
        myperipheral?.delegate = nil
        myperipheral = nil
        systemStatusData = ""
        batteryData = ""
        reservoirLevelData = ""
    }
    
    public func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?){
           if(error != nil){
               print("advertising error: \(error!.localizedDescription)")
           }
           else{
               print("advertising started")
           }
       }
    
    public func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?){
            if(error != nil){
                print("error in addservice: \(error!.localizedDescription)")
            }
            else{
                peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey : [service.uuid]])
            }
        }
}


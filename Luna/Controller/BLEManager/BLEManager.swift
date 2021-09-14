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
let IOBout = CBUUID(string: "378EC9D6-075C-4BF6-89DC-0A8267F7B7B7")


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
    //    var peripheralManager :CBPeripheralManager!
    var myperipheral :CBPeripheral?
    var mychar :CBCharacteristic!
    var myservice :CBService?
    //    var peripherals :[peripheralWithRssi]!
    var rescanTimer :Timer?
    var rssiTimer :Timer?
    var batteryData: String = ""
    var reservoirLevelData: String = ""
    var systemStatusData : String = ""
    var insulinData : [InsulinDataModel] = []
    var isKeepConnect = true
    var isConnect :Bool = false
    var isScanning :Bool = false
    var isMyPeripheralConected :Bool = false
    var isAdvertising :Bool = false
    
    private override init (){
        super.init ()
        print ("shared instance")
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
            self.centralManager.scanForPeripherals(withServices: [lunaCBUUID], options: nil)
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
            print(characteristic)
            if characteristic.properties.contains(.read) {
                print("\(characteristic.uuid): properties contains .read")
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
                peripheral.setNotifyValue(true, for: characteristic)
            }
            if characteristic.properties.contains(.indicate){
                print("\(characteristic.uuid): properties contains .indicate")
                peripheral.setNotifyValue(true, for: characteristic)
            }
            if characteristic.properties.contains(.write) {
                print("\(characteristic.uuid): properties contains .write")
                switch characteristic.uuid {
                case dataInCBUUID:
                    writeValue(myCharacteristic: characteristic,value: "#GET_DOSE_DATA")
                //writeValue(myCharacteristic: characteristic,value:  "GET_ERROR_LOG")
                case CBUUID(string: "5927a433-a277-40b7-b2d4-5bf796c0053c"):
                    writeValue(myCharacteristic: characteristic,value:  "10:1621985510;")
                case CBUUID(string: "5927a433-a277-40b7-b2d4-d1ce2ffefef9"):
                    writeValue(myCharacteristic: characteristic,value:  "10:1621985510;")
                case dataOutCBUUID:
                    peripheral.setNotifyValue(true, for: characteristic)
                case batteryCharacteristicCBUUID:
                    writeValue(myCharacteristic: characteristic)
                case ReservoirLevelCharacteristicCBUUID:
                    writeValue(myCharacteristic: characteristic,value: "7")
                case statusCBUUID:
                    writeValue(myCharacteristic: characteristic,value: "0")
                default:
                    peripheral.setNotifyValue(true, for: characteristic)
                    print("Do Nothing")
                }
            }
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
        case batteryCharacteristicCBUUID:
            print(String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? "")
            let data = String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? ""
            self.batteryData = data
            let dic = ["batteryData": self.batteryData]
            NotificationCenter.default.post(name: Notification.Name.BleDidUpdateValue, object: dic)
        case ReservoirLevelCharacteristicCBUUID:
            print(String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? "")
            print("handled Characteristic Value for Reservoir Level: \(String(describing: characteristic.value))")
            let data = String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? ""
            self.reservoirLevelData = data
            let dic = ["reservoirLevelData": self.reservoirLevelData]
            NotificationCenter.default.post(name: Notification.Name.BleDidUpdateValue, object: dic)
        case statusCBUUID:
            print(String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? "")
            print("handled Characteristic Value for status : \(String(describing: characteristic.value))")
            let data = String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? ""
            self.systemStatusData = data
            let dic = ["systemStatusData": self.systemStatusData]
            NotificationCenter.default.post(name: Notification.Name.BleDidUpdateValue, object: dic)
        case firmwareRevisionString:
            let data = String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? ""
            print("handled Characteristic Value for firmwareRevisionString:  \(data)")
        case writableCharacteristicCBUUID:
            print(String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? "")
            let data = String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? ""
            print(data)
        case dataOutCBUUID:
            let data = String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? ""
            let dataArray = data.split{$0 == ";"}.map(String.init)
            let properDataArray = dataArray.map { (stringValue) -> [String] in
                return stringValue.split{$0 == ":"}.map(String.init)
            }
            self.insulinData = properDataArray.map({ (stringArray) -> InsulinDataModel in
                return InsulinDataModel(insulinData: stringArray.first!, date: Double(stringArray.last!) ?? 0.0)
            })
            for insulinModel in self.insulinData {
                FirestoreController.createInsulinDataNode(insulinUnit: insulinModel.insulinData ?? "", date: Double(insulinModel.date))
            }
            NotificationCenter.default.post(name: Notification.Name.BleDidUpdateValue, object: [:])
            print(self.insulinData)
            print("handled Characteristic Value for dataOutCBUUID: \(String(describing: characteristic.value))")
        case CBUUID(string: "5927a433-a277-40b7-b2d4-5bf796c0053c"):
            print("handled Characteristic Value for: \(String(describing: characteristic.value))")
        case CBUUID(string: "5927a433-a277-40b7-b2d4-d1ce2ffefef9"):
            print("handled Characteristic Value for: \(String(describing: characteristic.value))")
        case IOBout:
            let data = String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? ""
            print("handled Characteristic Value for IOBout:  \(data)")
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
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
            centralManager.scanForPeripherals(withServices: [lunaCBUUID],options: nil)
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
        myperipheral = peripheral
        myperipheral?.delegate = self
        centralManager.stopScan()
        centralManager.connect(myperipheral!, options: [CBConnectPeripheralOptionNotifyOnConnectionKey:true, CBConnectPeripheralOptionNotifyOnDisconnectionKey: true])
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        isMyPeripheralConected = true
        myperipheral?.discoverServices(nil)
        CommonFunctions.showToastWithMessage("Bluetooth connected.")
        delegate?.didConnect?(name: "Bluetooth connected.")
    }
    
    public func centralManager (_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("DisConnected!")
        isMyPeripheralConected = false
        myperipheral?.delegate = nil
        myperipheral = nil
        systemStatusData = ""
        NotificationCenter.default.post(name: Notification.Name.BLEDidDisConnectSuccessfully, object: nil)
        //        central.connect(peripheral, options: nil)
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
    }
}


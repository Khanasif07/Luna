//
//  BLEManager.swift
//  Luna
//
//  Created by Admin on 01/07/21.
//

import UIKit
import CoreBluetooth

let batteryCharacteristicCBUUID = CBUUID(string: "378EC9D6-075C-4BF6-89DC-9F0D6EA3B5C4")
let ReservoirLevelCharacteristicCBUUID = CBUUID(string: "378ec9d6-075c-4bf6-89dc-0c6f73b4b761")
let statusCBUUID = CBUUID(string: "378ec9d6-075c-4bf6-89dc-a6d767548715")

import Foundation
import CoreBluetooth

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
    
//    struct peripheralWithRssi {
//        var RSSI: NSNumber
//        var peripheral :CBPeripheral
//    }
    
    public var delegate :BleProtocol?
    
//    let DFUUID :CBUUID = CBUUID(string: "DADED7B6-BAA6-CBBB-D870-D46EB7963365")
//    public var serviceUuid = CBUUID(string: "b1905964-c600-45bb-b050-49b85d2770d0")
//    public var characteristicUuid = CBUUID(string: "6cb02c07-9d51-48a7-9552-d2f09bed6e33")
    
    var centralManager :CBCentralManager!
//    var peripheralManager :CBPeripheralManager!
    var myperipheral :CBPeripheral!
    var mychar :CBCharacteristic!
    var myservice :CBService?
//    var peripherals :[peripheralWithRssi]!
    var rescanTimer :Timer?
    var rssiTimer :Timer?
    var batteryData: String = ""
    var reservoirLevelData: String = ""
    var systemStatusData : String = ""
    var isKeepConnect = true
    var isConnect :Bool = false
    var isScanning :Bool = false
    var isMyPeripheralConected :Bool = false
    var isAdvertising :Bool = false
    
    private override init (){
        super.init ()
        print ("shared instance")
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
//        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
//        self.peripheralManager.delegate = self
//        peripherals = [peripheralWithRssi]()
    }
    
    private convenience init (delegate: BleProtocol){
        self.init ()
        self.delegate = delegate
    }
    
    public func myInit (){}
    
//    public func publishService (){
//        delegate?.log!(message: "in publishService")
//
//        let myService :CBMutableService = CBMutableService(type: serviceUuid, primary: true)
//
//        mychar = CBMutableCharacteristic(type: characteristicUuid, properties: CBCharacteristicProperties.read, value: nil, permissions: CBAttributePermissions.readable)
//
//        myService.characteristics = [mychar]
//
//        peripheralManager?.add(myService)
//
//        self.myservice = myService
//
//        delegate?.log!(message: "leaving publishService")
//    }
//
    public func beginScan(){
        if isScanning == false{
            isKeepConnect = true
            self.centralManager.scanForPeripherals(withServices: nil, options: nil)
            self.rescanTimer =  Timer.scheduledTimer(timeInterval: 30,
                target: self,
                selector: #selector(scanningFinished),
                userInfo: nil,
                repeats: true)
//            let uuid = [UUID(uuidString: "DADED7B6-BAA6-CBBB-D870-D46EB7963365")!]
//            DispatchQueue.main.async {
//                if let peripheral = self.centralManager.retrievePeripherals(withIdentifiers: uuid).first {
//                    CommonFunctions.delay(delay: 2.0) {
//                        self.myperipheral = peripheral // <-- super important
//                        self.centralManager.connect(peripheral, options: nil)
//                    }
//                }
//            }
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
    
    
    public func writeValue(myCharacteristic: CBCharacteristic,value: String = "85") {
        if isMyPeripheralConected { //check if myPeripheral is connected to send data
            let dataToSend: Data = value.data(using: String.Encoding.utf8)!
            print(dataToSend)
            myperipheral.writeValue(dataToSend as Data, for: myCharacteristic, type: CBCharacteristicWriteType.withResponse)    //Writing the data to the peripheral
        } else {
            print("Not connected")
        }
    }
    
    @objc func scanningFinished(){
        if let peripheral = myperipheral{
            if !isMyPeripheralConected && peripheral.state != .connected{
                if(centralManager != nil && centralManager.isScanning){
                    print("stopping scan")
                    centralManager.stopScan()
                }
                self.delegate?.didNotDiscoverPeripheral?()
            }
        }else{
            if !isMyPeripheralConected {
                if(centralManager != nil && centralManager.isScanning){
                    print("stopping scan")
                    centralManager.stopScan()
                }
                self.delegate?.didNotDiscoverPeripheral?()
            }
        }
        self.rescanTimer?.invalidate()
    }
    
//    public func stop(){
//        print("in stop")
//        if(peripheralManager != nil && peripheralManager.isAdvertising){
//            print("stoping advertising...")
//            peripheralManager.stopAdvertising()
//        }
//        if(centralManager != nil && centralManager.isScanning){
//            print("stopping scan")
//            centralManager.stopScan()
//        }
//    }
    
    /**
     rescan ble device every 2 seconds
     */
//    func updateScan (){
//        if let p = getMaxPeripheral(){
//            myperipheral = p
//            connect(peripheral: myperipheral!)
//        } else{
//            print ("rescan")
//            self.centralManager.scanForPeripherals(withServices: [DFUUID], options: nil)
//            self.centralManager.scanForPeripherals(withServices: nil, options: nil)
//        }
//    }
    
    /**
     return the max rssi peripheral tin peripherals
     
     - returns: peripheral with best rssi or nil
     */
//    func getMaxPeripheral () -> CBPeripheral?{
//        if self.peripherals.count == 0{
//            return nil
//        }
//
//        var max :NSNumber = self.peripherals[0].RSSI
//        var maxPeripheral :CBPeripheral = self.peripherals[0].peripheral
//
//        for p in self.peripherals{
//            if p.RSSI.intValue > max.intValue{
//                max = p.RSSI
//                maxPeripheral = p.peripheral
//            }
//        }
//        return maxPeripheral
//    }
    
    /**
     connect a peripheral
     
     - parameter peripheral: that rssi is best
     */
//    func connect (peripheral:CBPeripheral){
//        myperipheral = peripheral
//        centralManager.stopScan()
//        isScanning = false
//        self.rescanTimer?.invalidate()
//        self.rescanTimer = nil
//        centralManager.connect(peripheral, options: nil)
//    }
    
    /**
     send one byte to connected peripheral
     
     - parameter value: one byte data will send
     */
//    public func sendByte (value :UInt8) {
//        var myvalue = value
//        let data = NSData(bytes: &myvalue, length: 1)
//        myperipheral?.writeValue(data as Data, for: mychar!, type: CBCharacteristicWriteType.withoutResponse)
//    }
    
    /**
     send String to connected peripheral
     
     - parameter value: -> a string will send
     */
//    public func sendString (value :String){
//        if value.lengthOfBytes(using: String.Encoding.ascii) == 0 {
//            return
//        }
//        let data = value.data(using: String.Encoding.ascii, allowLossyConversion: true)
//        print ("data: \(String(describing: data))")
//        myperipheral?.writeValue(data!, for: mychar!, type: CBCharacteristicWriteType.withoutResponse)
//    }
//
//    @objc public func centralManagerDidUpdateState(_ central: CBCentralManager){
//        if centralManager.state == .poweredOn {
//            print("ble opened")
//            centralManager.scanForPeripherals(withServices: nil,options: nil)
//
////            delegate?.log(message: "ble poweredon")
//        } else {
//            print("ble open error")
////            delegate?.log(message: "ble power error")
//        }
//    }
//
//    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber){
//        //println ("didDiscoverPeripheral ")
//        print ("name=\(String(describing: peripheral.name))  RSSI=\(Int32(RSSI.intValue))")
//
////        if peripheral.name == "car_007"
////        {
////            connect(peripheral: peripheral)
////        }
////
////        if RSSI.intValue > -50 && RSSI.intValue < -10
////        {
////            appendPeripheral(peripheral: peripheral, RSSI: RSSI)
////        }
//        print(peripheral.name)
//        print(peripheral.identifier)
//        myperipheral = peripheral
//        myperipheral.delegate = self
//        centralManager.stopScan()
//        centralManager.connect(peripheral, options: nil)
//        delegate?.didDiscover?(name: peripheral.name!, rssi: RSSI)
//    }
    
    /**
     append new find peripheral to peripherals and update rssi
     
     - parameter peripheral:
     - parameter RSSI:
//     */
//    func appendPeripheral (peripheral :CBPeripheral, RSSI :NSNumber){
//        //for var p=1; p < self.peripherals.count; p++
//        for p in 1...(self.peripherals.count-1){
//            if self.peripherals[p].peripheral == peripheral {
//                self.peripherals[p].RSSI = RSSI
//                return
//            }
//        }
//        self.peripherals.append(peripheralWithRssi(RSSI: RSSI, peripheral: peripheral))
//    }
    
//    public func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?){
////        delegate?.log!(message: "in did add service")
//        if(error != nil){
////            delegate?.log!(message: "error in add service")
//            print("error in addservice: \(error!.localizedDescription)")
//        }
//        else{
//            peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey : [service.uuid]])
//        }
//    }
//
//    public func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?){
////        delegate?.log!(message: "in did start adv.")
//        if(error != nil){
////            delegate?.log!(message: "advertising error")
//            print("advertising error: \(error!.localizedDescription)")
//        }
//        else{
////            delegate?.log!(message: "advertising started")
//            print("advertising started")
//        }
//    }
    
//    public func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral){
//        print("didConnectPeripheral ")
//        myperipheral = peripheral
//        myperipheral.discoverServices(nil)
//        peripheral.readRSSI()
//        rescanTimer?.invalidate()
//        rescanTimer = nil
//        delegate?.didConnect?(name: peripheral.name!)
//    }
//
//    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?){
//        print("didDisconnectPeripheral ")
//        isConnect = false
//        rssiTimer?.invalidate()
//        rssiTimer = nil
//        rescanTimer?.invalidate()
//        if isKeepConnect == true{
//            centralManager.connect(myperipheral!, options: nil)
//        }
//        delegate?.didDisconnect?()
//    }
//
//    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?){
//        print("didDiscoverServices ")
//        guard let services = peripheral.services else { return }
//        for service in services {
//            print(service)
//            peripheral.discoverCharacteristics(nil, for: service)
//        }
//    }
//
//    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?){
//        print("didDiscoverCharacteristicsForService ")
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
        //        let char = (service.characteristics![0]) //as! CBCharacteristic)
        //        if char.uuid.uuidString == "DFB1"{
        //            //println ("get DFB1")
        //            mychar = char
        //            myperipheral?.setNotifyValue(true, for: mychar!)
        //            isConnect = true
        //            rssiTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: Selector(("updateRSSI")), userInfo: nil, repeats: true)
        //            delegate?.didBleReady?()
        //        }
    }
    
    /**
     read rssi every seconds
     */
//    func updateRSSI (){
//        myperipheral?.readRSSI()
//    }
    
//    public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?){
//        //println ("didUpdateNotificationStateForCharacteristic ")
//    }
//
//    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?){
//        print ("didUpdateValueForCharacteristic")
//        let str = NSString(data: characteristic.value!, encoding: String.Encoding.ascii.rawValue)
//
//        //var str = NSString(data: characteristic.value(), encoding: NSASCIIStringEncoding)
//
//        if str != nil{
//            print ("read:(\(str!.length)) \(str!)")
//        }
//    }
//
//    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?){
//        //println ("didWriteValueForCharacteristic ")
//    }
//
//    public func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?){
//        //      println ("didReadRSSI ")
//        delegate?.didReadRSSI?(rssi: RSSI)
//    }
//
//    public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager){
//
//    }
//}

// MARK: - Extension For CBPeripheralDelegate
//===========================
extension BleManager: CBPeripheralDelegate {
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
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
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print(characteristic.uuid)
        switch characteristic.uuid {
        case batteryCharacteristicCBUUID:
            if batteryData.isEmpty {
            writeValue(myCharacteristic: characteristic)
            }
            print(String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? "")
            let data = String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? ""
            self.batteryData = data
//            self.batteryImgView.image = DeviceStatus.getBatteryImage(value:data).1
//            self.batteryStatusLbl.text = DeviceStatus.getBatteryImage(value:data).0
//            self.batteryTitleLbl.text = DeviceStatus.Battery.titleString
            print("handled Characteristic Value for Battery: \(String(describing: characteristic.value))")
        case ReservoirLevelCharacteristicCBUUID:
            if reservoirLevelData.isEmpty {
            writeValue(myCharacteristic: characteristic,value: "3")
            }
            print(String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? "")
            print("handled Characteristic Value for Reservoir Level: \(String(describing: characteristic.value))")
            let data = String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? ""
            self.reservoirLevelData = data
//            self.reservoirImgView.image = DeviceStatus.getReservoirImage(value:data).1
//            self.reservoirStatusLbl.text = DeviceStatus.getReservoirImage(value:data).0
//            self.reservoirTitleLbl.text = DeviceStatus.ReservoirLevel.titleString
        case statusCBUUID:
            if systemStatusData.isEmpty{
            writeValue(myCharacteristic: characteristic,value: "0")
            }
            print(String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? "")
            print("handled Characteristic Value for status : \(String(describing: characteristic.value))")
            let data = String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? ""
            self.systemStatusData = data
//            self.systemImgView.image = DeviceStatus.getSystemImage(value:data).1
//            self.systemStatusLbl.text = DeviceStatus.getSystemImage(value:data).0
//            self.systemTitleLbl.text = DeviceStatus.System.titleString
        default:
            print("Unhandled Characteristic UUID: \(characteristic.value)")
        }
        self.delegate?.didUpdateValue?()
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
            self.delegate?.didBleOff?()
          case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: nil,options: nil)
            self.rescanTimer =  Timer.scheduledTimer(timeInterval: 30,
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
        print(peripheral.name)
        print(peripheral.identifier)
        myperipheral = peripheral
        myperipheral.delegate = self
        centralManager.stopScan()
        centralManager.connect(myperipheral, options: nil)
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        isMyPeripheralConected = true
        myperipheral.discoverServices(nil)
        CommonFunctions.showToastWithMessage("Bluetooth connected.")
        delegate?.didConnect?(name: "Bluetooth connected.")
    }

    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("DisConnected!")
        isMyPeripheralConected = false
        central.connect(peripheral, options: nil)
    }



}

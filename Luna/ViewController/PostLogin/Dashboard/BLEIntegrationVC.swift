//
//  BLEIntegrationVC.swift
//  Luna
//
//  Created by Admin on 17/06/21.
//

import UIKit
import CoreBluetooth
import FirebaseAuth
import Firebase
import ExternalAccessory

class BLEIntegrationVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var bodySensorLocationLabel: UILabel!
    
    // MARK: - Variables
    //==========================
    var centralManager: CBCentralManager!
    var heartRatePeripheral: CBPeripheral!
    var isMyPeripheralConected = false
    //    let manager = BleManager.sharedInstance
    
    
    
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func disconnectBLETapped(_ sender: Any) {
        DispatchQueue.main.async {
            CommonFunctions.delay(delay: 2.0) {
                self.centralManager.cancelPeripheralConnection(self.heartRatePeripheral)
            }
        }
    }
    
    @IBAction func connectBLETapped(_ sender: Any) {
        let uuid = [UUID(uuidString: "DADED7B6-BAA6-CBBB-D870-D46EB7963365")!]
        DispatchQueue.main.async {
            if let peripheral = self.centralManager.retrievePeripherals(withIdentifiers: uuid).first {
                CommonFunctions.delay(delay: 2.0) {
                    self.heartRatePeripheral = peripheral // <-- super important
                    self.centralManager.connect(peripheral, options: nil)
                }
            }
        }
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
    }
    
}

// MARK: - Extension For Functions
//===========================
extension BLEIntegrationVC : BleProtocol{
    
    private func initialSetup() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
        //        self.manager.delegate = self
        //        DispatchQueue.main.asyncAfter(wallDeadline: .now()+2) {
        //            self.manager.beginScan()
        //        }
    }
    
    func didDiscover(name: String, rssi: NSNumber) {
        print(name)
    }
    
    func didConnect(name: String) {
        print(name)
    }
    
    func writeValue(myCharacteristic: CBCharacteristic,value: String = "85") {
        if isMyPeripheralConected { //check if myPeripheral is connected to send data
            let dataToSend: Data = value.data(using: String.Encoding.utf8)!
            print(dataToSend)
            heartRatePeripheral.writeValue(dataToSend as Data, for: myCharacteristic, type: CBCharacteristicWriteType.withResponse)    //Writing the data to the peripheral
        } else {
            print("Not connected")
        }
    }
}

// MARK: - Extension For CBCentralManagerDelegate
//===========================
extension BLEIntegrationVC: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
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
        case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: nil,options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print(peripheral.name)
        print(peripheral.identifier)
        heartRatePeripheral = peripheral
        heartRatePeripheral.delegate = self
        centralManager.stopScan()
        centralManager.connect(heartRatePeripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        isMyPeripheralConected = true
        heartRatePeripheral.discoverServices(nil)
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("DisConnected!")
        isMyPeripheralConected = false
        central.connect(peripheral, options: nil)
    }
    
    
    
}

// MARK: - Extension For CBPeripheralDelegate
//===========================
extension BLEIntegrationVC: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
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
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print(characteristic.uuid)
        switch characteristic.uuid {
        case batteryCharacteristicCBUUID:
            print("handled Characteristic Value for Battery: \(String(describing: characteristic.value))")
            //            writeValue(myCharacteristic: characteristic)
            print(String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? "")
        case ReservoirLevelCharacteristicCBUUID:
            //            writeValue(myCharacteristic: characteristic,value: "100")
            print(String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? "")
            print("handled Characteristic Value for Reservoir Level: \(String(describing: characteristic.value))")
        case statusCBUUID:
            //            writeValue(myCharacteristic: characteristic,value: "0")
            print(String(bytes: characteristic.value!, encoding: String.Encoding.utf8) ?? "")
            print("handled Characteristic Value for status : \(String(describing: characteristic.value))")
        default:
            print("Unhandled Characteristic UUID: \(characteristic.value)")
        }
    }
    
    private func bodyLocation(from characteristic: CBCharacteristic) -> String {
        guard let characteristicData = characteristic.value,
              let byte = characteristicData.first else { return "Error" }
        
        switch byte {
        case 0: return "Other"
        case 1: return "Chest"
        case 2: return "Wrist"
        case 3: return "Finger"
        case 4: return "Hand"
        case 5: return "Ear Lobe"
        case 6: return "Foot"
        default:
            return "Reserved for future use"
        }
    }
    
    private func heartRate(from characteristic: CBCharacteristic) -> Int {
        guard let characteristicData = characteristic.value else { return -1 }
        let byteArray = [UInt8](characteristicData)
        
        // See: https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.characteristic.heart_rate_measurement.xml
        // The heart rate mesurement is in the 2nd, or in the 2nd and 3rd bytes, i.e. one one or in two bytes
        // The first byte of the first bit specifies the length of the heart rate data, 0 == 1 byte, 1 == 2 bytes
        let firstBitValue = byteArray[0] & 0x01
        if firstBitValue == 0 {
            // Heart Rate Value Format is in the 2nd byte
            return Int(byteArray[1])
        } else {
            // Heart Rate Value Format is in the 2nd and 3rd bytes
            //          return (Int(byteArray[1]) << 8) + Int(byteArray[2])
            return  Int(byteArray[0]) +  (Int(byteArray[1]))
        }
    }
}


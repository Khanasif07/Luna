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

//let heartRateServiceCBUUID = CBUUID(string: "0x180D")
//let heartRateMeasurementCharacteristicCBUUID = CBUUID(string: "2A37")
//let bodySensorLocationCharacteristicCBUUID = CBUUID(string: "2A38")
class BLEIntegrationVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var bodySensorLocationLabel: UILabel!
    
    // MARK: - Variables
    //===========================
    var database: Database!
    var centralManager: CBCentralManager!
    var heartRatePeripheral: CBPeripheral!


    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func disconnectBLETapped(_ sender: Any) {
        centralManager.cancelPeripheralConnection(heartRatePeripheral)
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
//        FirestoreController.logOut { (successMsg) in
//            print(successMsg)
//            AppUserDefaults.removeAllValues()
//            AppRouter.goToSignUpVC()
//        }
    }
    
}

// MARK: - Extension For Functions
//===========================
extension BLEIntegrationVC {
    
    private func initialSetup() {
//        database = Database.database()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func onHeartRateReceived(_ heartRate: Int) {
        heartRateLabel.text = String(heartRate)
        print("BPM: \(heartRate)")
    }
    
    private func performCleanUp() {
//        let userId = AppUserDefaults.value(forKey: .userId).stringValue
//        database.collection(ApiKey.users)
//            .document(userId).updateData([ApiKey.deviceToken : ""]) { (error) in
//                if let err = error {
//                    print(err.localizedDescription)
//                } else {
//                    AppUserDefaults.removeAllValues()
//                    AppUserDefaults.save(value: DeviceDetail.deviceToken, forKey: .fcmToken)
//                    UserModel.main = UserModel()
//                    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
//                }
//            }
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
      print(peripheral)
        print(peripheral.name)
        print(peripheral.identifier)
        heartRatePeripheral = peripheral
        heartRatePeripheral.delegate = self
        centralManager.stopScan()
        centralManager.connect(heartRatePeripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
      print("Connected!")
      heartRatePeripheral.discoverServices(nil)
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
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
        case bodySensorLocationCharacteristicCBUUID:
            let bodySensorLocation = bodyLocation(from: characteristic)
            bodySensorLocationLabel.text = bodySensorLocation
        case heartRateMeasurementCharacteristicCBUUID:
            let bpm = heartRate(from: characteristic)
            onHeartRateReceived(bpm)
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
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
          return (Int(byteArray[1]) << 8) + Int(byteArray[2])
        }
      }
}


//
//  NotificationExtension.swift
//  Luna
//
//  Created by Admin on 03/06/21.
//

import Foundation
import Foundation

extension Notification.Name {
    static let NotConnectedToInternet = Notification.Name("NotConnectedToInternet")
    static let lunaPairedSuccessfully = Notification.Name("lunaPairedSuccessfully")
    static let insulinConnectedSuccessfully = Notification.Name("insulinConnectedSuccessfully")
    static let cgmConnectedSuccessfully = Notification.Name("cgmConnectedSuccessfully")
    static let cgmRemovedSuccessfully = Notification.Name("cgmRemovedSuccessfully")
    static let BleDidUpdateValue = Notification.Name("BleDidUpdateValue")
    static let XAxisLabelsDuplicateValue = Notification.Name("XAxisLabelsDuplicateValue")
    static let BatteryUpdateValue = Notification.Name("BatteryUpdateValue")
    static let ReservoirUpdateValue = Notification.Name("ReservoirUpdateValue")
    static let StatusUpdateValue = Notification.Name("StatusUpdateValue")
    static let BLEOnOffState = Notification.Name("BLEOnOffState")
    static let BLEDidConnectSuccessfully = Notification.Name("BLEDidConnectSuccessfully")
    static let BLEDidDisConnectSuccessfully = Notification.Name("BLEDidDisConnectSuccessfully")
    
}


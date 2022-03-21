//
//  NotificationExtension.swift
//  Luna
//
//  Created by Admin on 03/06/21.
//

import Foundation
import Foundation

extension Notification.Name {
    static let notConnectedToInternet = Notification.Name("NotConnectedToInternet")
    static let lunaPairedSuccessfully = Notification.Name("lunaPairedSuccessfully")
    static let insulinConnectedSuccessfully = Notification.Name("insulinConnectedSuccessfully")
    static let cgmConnectedSuccessfully = Notification.Name("cgmConnectedSuccessfully")
    static let cgmSimData = Notification.Name("cgmSimData")
    static let cgmRemovedSuccessfully = Notification.Name("cgmRemovedSuccessfully")
    static let bleDidUpdateValue = Notification.Name("bleDidUpdateValue")
    static let applicationIsTerminated = Notification.Name("applicationIsTerminated")
    static let receivedPushNotification = Notification.Name("receivedPushNotification")
    static let batteryUpdateValue = Notification.Name("batteryUpdateValue")
    static let reservoirUpdateValue = Notification.Name("reservoirUpdateValue")
    static let statusUpdateValue = Notification.Name("statusUpdateValue")
    static let bLEOnOffState = Notification.Name("bLEOnOffState")
    static let bLEDidConnectSuccessfully = Notification.Name("bLEDidConnectSuccessfully")
    static let bLEDidDisConnectSuccessfully = Notification.Name("bLEDidDisConnectSuccessfully")
    
}


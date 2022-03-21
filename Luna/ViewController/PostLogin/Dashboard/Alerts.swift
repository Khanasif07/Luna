//
//  Alerts.swift
//  Luna
//
//  Created by Admin on 17/03/22.
//

import Foundation
import UIKit

extension BottomSheetVC {
    
    @objc func batteryUpdateValue(notification : NSNotification){
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
            if ((BleManager.sharedInstance.systemStatusData.contains("3") || BleManager.sharedInstance.systemStatusData.contains("5")) && Int(BleManager.sharedInstance.batteryData) ?? 0 <= 75 && (Int(BleManager.sharedInstance.batteryData) ?? 0) % 5 == 0 && SystemInfoModel.shared.dosingData.last?.sessionStatus != ApiKey.endCaps) {
                var bodyText  = "Your Luna device is only "
                bodyText += BleManager.sharedInstance.batteryData
                bodyText += "% charged and may not last the entire session."
                self.persistentNotification(body: bodyText)
                return
            }
            
            if ((BleManager.sharedInstance.systemStatusData.contains("F7") || BleManager.sharedInstance.systemStatusData.contains("F8")) && Int(BleManager.sharedInstance.batteryData) ?? 0 <= 75 && (Int(BleManager.sharedInstance.batteryData) ?? 0) % 5 == 0 && SystemInfoModel.shared.dosingData.last?.sessionStatus != ApiKey.endCaps) {
                var bodyText  = "Your Luna device is only "
                bodyText += BleManager.sharedInstance.batteryData
                bodyText += "% charged and may not last the entire session."
                self.persistentNotification(body: bodyText)
                return
            }
            
            if BleManager.sharedInstance.systemStatusData.contains("0") || BleManager.sharedInstance.systemStatusData.contains("1"){
                let bodyText  = "Your Luna device neeeds to be charged and is not being charged."
                self.persistentNotification(body: bodyText)
                return
            }
        }
    }
    
    @objc func reservoirUpdateValue(notification : NSNotification){
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
            if BleManager.sharedInstance.reservoirLevelData == "-1" && BleManager.sharedInstance.iobData > 0.0{
                var bodyText  = "Your session has been completed and you have "
                bodyText += "\(BleManager.sharedInstance.iobData)"
                bodyText += " units of active Insulin On Board. Make sure to consider this before making any diabetes related decisions for the next 6 hours."
                self.persistentNotification(body: bodyText)
                return
            }
            
            if BleManager.sharedInstance.systemStatusData.contains("F6") || BleManager.sharedInstance.systemStatusData.contains("F5"){
                self.persistentNotification(body: "Luna is not receiving CGM data. Check to see if your CGM is working and paired with Luna properly.")
                return
            }
            
            if BleManager.sharedInstance.systemStatusData.contains("FB"){
                self.persistentNotification(body: "Luna has detected that there is no insulin in the Reservoir. Please discard this Reservoir and place the Luna Controller back on the Charger for 60 seconds to reset the device.")
                return
            }
            
            if BleManager.sharedInstance.systemStatusData.contains("F3") && SystemInfoModel.shared.dosingData.last?.sessionStatus == ApiKey.beginCaps {
                self.persistentNotification(body: "Luna has detected an occlusion in the system. Please discard this reservoir and place the Luna Controller back on the Charger for 60 seconds to reset the device.")
                return
            }
            
            if (BleManager.sharedInstance.systemStatusData.contains("FA") || (BleManager.sharedInstance.systemStatusData.contains("F1") && BleManager.sharedInstance.systemStatusData.contains("F2") && BleManager.sharedInstance.systemStatusData.contains("F4") && BleManager.sharedInstance.systemStatusData.contains("F9"))) && SystemInfoModel.shared.dosingData.last?.sessionStatus != ApiKey.endCaps{
                self.persistentNotification(body: "Luna has detected a failure in the system. Please check the dashboard on the App for more information. If the problem can’t be resolved, discard this Reservoir and place the Luna Controller back on the Charger for 60 seconds to reset the device.")
                return
            }
        }
    }
    
    @objc func statusUpdateValue(notification : NSNotification){
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
            if BleManager.sharedInstance.systemStatusData.contains("F6") || BleManager.sharedInstance.systemStatusData.contains("F5"){
                self.persistentNotification(body: "Luna is not receiving CGM data. Check to see if your CGM is working and paired with Luna properly.")
                return
            }
            
            if BleManager.sharedInstance.systemStatusData.contains("F3") && SystemInfoModel.shared.dosingData.last?.sessionStatus == ApiKey.beginCaps {
                self.persistentNotification(body: "Luna has detected an occlusion in the system. Please discard this reservoir and place the Luna Controller back on the Charger for 60 seconds to reset the device.")
                return
            }
            
            if (BleManager.sharedInstance.systemStatusData.contains("FA") || (BleManager.sharedInstance.systemStatusData.contains("F1") && BleManager.sharedInstance.systemStatusData.contains("F2") && BleManager.sharedInstance.systemStatusData.contains("F4") && BleManager.sharedInstance.systemStatusData.contains("F9"))) && SystemInfoModel.shared.dosingData.last?.sessionStatus == ApiKey.beginCaps{
                self.persistentNotification(body: "Luna has detected a failure in the system. Please check the dashboard on the App for more information. If the problem can’t be resolved, discard this Reservoir and place the Luna Controller back on the Charger for 60 seconds to reset the device.")
                return
            }
        }
    }
    
    @objc func applicationIsTerminated(){
        self.persistentNotification(body: "Tap to open app. Luna will not function until the app is open. In the future, keep app running in the background, don't swipe it closed. ",title: "App is closed.")
    }
    
    @objc func receivedPushNotification(notification : NSNotification){
        if let dict = notification.object as? NSDictionary {
            self.persistentNotification(body: dict["body"] as? String ?? "" ,title: dict["title"] as? String ?? "")
        }
    }
    
    @objc func bLEOnOffStateChanged(){
        let bodyText  = "Turn on Bluetooth to receive alerts, alarms, or sensor glucose readings."
        self.persistentNotification(body: bodyText,title: "Bluetooth Off Alert")
    }
}

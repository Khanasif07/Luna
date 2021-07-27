//
//  AppEnums.swift
//  Luna
//
//  Created by Admin on 03/06/21.
//
import UIKit
import Foundation

enum DeviceStatus {
    case Battery
    case ReservoirLevel
    case System
    
    var titleString: String? {
        switch self {
        case .Battery: return "Battery"
        case .ReservoirLevel: return "Reservoir"
        case .System: return "System"
        }
    }
    
    var logoImg: UIImage? {
        switch self {
        case .Battery: return #imageLiteral(resourceName: "battery14")
        case .ReservoirLevel: return #imageLiteral(resourceName: "battery14")
        case .System: return #imageLiteral(resourceName: "battery14")
        }
    }
    
    static func getBatteryImage(value: String)-> (String,UIImage?){
        let intValue = Int(value) ?? 0
        switch intValue {
        case 0...20:
            return ("Low",#imageLiteral(resourceName: "batteryEmpty"))
        case 20...40:
            return ("Low",#imageLiteral(resourceName: "battery14"))
        case 40...60:
            return ("",#imageLiteral(resourceName: "batteryHalf"))
        case 60...80:
            return ("",#imageLiteral(resourceName: "battery34"))
        default:
            return ("",#imageLiteral(resourceName: "batteryFull"))
        }
      
    }
    
   static func getReservoirImage(value: String)-> (String,UIImage?){
        let intValue = Int(value)
        switch intValue {
        case 0:
            return ("Fill",#imageLiteral(resourceName: "reservoir0Bars"))
        case 1:
            return ("Low",#imageLiteral(resourceName: "reservoir1Bar"))
        case 2:
            return ("Low",#imageLiteral(resourceName: "reservoir2Bars"))
        case 3:
            return ("Low",#imageLiteral(resourceName: "reservoir3Bars"))
        case 4:
            return ("",#imageLiteral(resourceName: "reservoir4Bars"))
        case 5:
            return ("",#imageLiteral(resourceName: "reservoir5Bars"))
        case 6:
            return ("",#imageLiteral(resourceName: "reservoir6Bars"))
        case 7:
            return ("",#imageLiteral(resourceName: "reservoir7Bars"))
        case 8:
            return ("",#imageLiteral(resourceName: "reservoir8Bars"))
        case 9:
            return ("",#imageLiteral(resourceName: "reservoir9Bars"))
        case 10:
            return ("",#imageLiteral(resourceName: "reservoir10Bars"))
        default:
            return ("",#imageLiteral(resourceName: "reservoir10Bars"))
        }
      
    }
    
   static func getSystemImage(value: String)-> (String,UIImage?){
        let intValue = Int(value)
        switch intValue {
        case 0:
            return ("Automating",#imageLiteral(resourceName: "automating"))
        case 1:
            return ("Stopped",#imageLiteral(resourceName: "stopped"))
        case 2:
            return ("Error",#imageLiteral(resourceName: "error"))
        case 3:
            return ("Ready",#imageLiteral(resourceName: "ready"))
        case 4:
            return ("Not Ready",#imageLiteral(resourceName: "notReady"))
        case 5:
            return ("No Signal",#imageLiteral(resourceName: "noSignal"))
        default:
            return ("No Signal",#imageLiteral(resourceName: "noSignal"))
        }
      
    }
    
    
}

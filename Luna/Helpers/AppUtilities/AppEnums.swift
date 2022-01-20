//
//  AppEnums.swift
//  Luna
//
//  Created by Admin on 03/06/21.
//
import UIKit
import Foundation

//MARK:- DeviceStatus  Enum
enum DeviceStatus {
    case Battery
    case ReservoirLevel
    case System
    
    var titleString: String? {
        switch self {
        case .Battery: return LocalizedString.battery.localized
        case .ReservoirLevel: return LocalizedString.reservoir.localized
        case .System: return LocalizedString.system.localized
        }
    }
    
    var logoImg: UIImage? {
        switch self {
        case .Battery: return #imageLiteral(resourceName: "batteryEmpty")
        case .ReservoirLevel: return #imageLiteral(resourceName: "reservoir0Bars")
        case .System: return #imageLiteral(resourceName: "noSignal")
        }
    }
    
    static func getBatteryImage(batteryInfo: String)-> (String,UIImage?){
        let intValue = Int(batteryInfo) ?? -1
        switch intValue {
        case 0...20:
            return ("Low",#imageLiteral(resourceName: "batteryEmpty"))
        case 20...40:
            return ("Low",#imageLiteral(resourceName: "battery14"))
        case 40...60:
            return ("Medium",#imageLiteral(resourceName: "batteryHalf"))
        case 60...80:
            return ("Medium",#imageLiteral(resourceName: "battery34"))
        case 80...100:
            return ("Full",#imageLiteral(resourceName: "batteryFull"))
        default:
            return ("",#imageLiteral(resourceName: "batteryEmpty"))
        }
      
    }
    
   static func getReservoirImage(reservoirInfo: String)-> (String,UIImage?,UIColor){
        let intValue = Int(reservoirInfo) ?? -2
        switch intValue {
        case -1:
            return ("Fill",#imageLiteral(resourceName: "reservoir0Bars"),#colorLiteral(red: 0.9450980392, green: 0.2705882353, blue: 0.2392156863, alpha: 1))
        case 0:
            return ("Fill",#imageLiteral(resourceName: "reservoir0Bars"),#colorLiteral(red: 0.9450980392, green: 0.2705882353, blue: 0.2392156863, alpha: 1))
        case 1:
            return ("Fill",#imageLiteral(resourceName: "reservoir0Bars"),#colorLiteral(red: 0.9607843137, green: 0.5450980392, blue: 0.262745098, alpha: 1))
        case 2:
            return ("Low",#imageLiteral(resourceName: "reservoir1Bar"),#colorLiteral(red: 0.9607843137, green: 0.5450980392, blue: 0.262745098, alpha: 1))
        case 4:
            return ("Low",#imageLiteral(resourceName: "reservoir1Bar"),#colorLiteral(red: 0.9607843137, green: 0.5450980392, blue: 0.262745098, alpha: 1))
        case 6:
            return ("Medium",#imageLiteral(resourceName: "reservoir4Bars"),#colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1))
        case 8:
            return ("Medium",#imageLiteral(resourceName: "reservoir5Bars"),#colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1))
        case 10:
            return ("Medium",#imageLiteral(resourceName: "reservoir6Bars"),#colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1))
        case 12:
            return ("Medium",#imageLiteral(resourceName: "reservoir6Bars"),#colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1))
        case 14:
            return ("Medium",#imageLiteral(resourceName: "reservoir6Bars"),#colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1))
        case 16:
            return ("Medium",#imageLiteral(resourceName: "reservoir7Bars"),#colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1))
        case 18:
            return ("Full",#imageLiteral(resourceName: "reservoir8Bars"),#colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1))
        case 20:
            return ("Full",#imageLiteral(resourceName: "reservoir9Bars"),#colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1))
        case 22:
            return ("Full",#imageLiteral(resourceName: "reservoir10Bars"),#colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1))
        default:
            return ("",#imageLiteral(resourceName: "reservoir0Bars"),#colorLiteral(red: 0.9450980392, green: 0.2705882353, blue: 0.2392156863, alpha: 1))
        }
    }
    
    static func getSystemImage(systemInfo: String)-> (String,UIImage?,UIColor){
        let intValue = Int(systemInfo)
        switch intValue {
        case 0:
            return ("",#imageLiteral(resourceName: "automating"),#colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1))
        case 1:
            return ("Stopped",#imageLiteral(resourceName: "stopped"),#colorLiteral(red: 0.9450980392, green: 0.2705882353, blue: 0.2392156863, alpha: 1))
        case 2:
            return ("Error",#imageLiteral(resourceName: "error"),#colorLiteral(red: 0.9450980392, green: 0.2705882353, blue: 0.2392156863, alpha: 1))
        case 3:
            return ("Ready",#imageLiteral(resourceName: "ready"),#colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1))
        case 4:
            return ("Not Ready",#imageLiteral(resourceName: "notReady"),#colorLiteral(red: 0.9607843137, green: 0.5450980392, blue: 0.262745098, alpha: 1))
        case 5:
            return ("No Signal",#imageLiteral(resourceName: "noSignal"),#colorLiteral(red: 0.9607843137, green: 0.5450980392, blue: 0.262745098, alpha: 1))
        default:
            return ("No Signal",#imageLiteral(resourceName: "noSignal"),#colorLiteral(red: 0.9607843137, green: 0.5450980392, blue: 0.262745098, alpha: 1))
        }
    }
}

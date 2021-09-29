//
//  SystemInfoModel.swift
//  Luna
//
//  Created by Admin on 22/07/21.
//
import SwiftyJSON
import Foundation

struct SystemInfoModel{
    
    static var shared = SystemInfoModel()
    
    var longInsulinImage : UIImage = #imageLiteral(resourceName: "toujeoMax")
    var longInsulinType : String
    var longInsulinSubType : String
    var previousCgmReadingTime : String = "0"
    var insulinUnit : Int
    var cgmType : String
    var cgmUnit: Int
    var isFromSetting: Bool = false
    var cgmData : [ShareGlucoseData]?
    var insulinData : [InsulinDataModel]?
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json : JSON = JSON()){
        self.longInsulinImage = #imageLiteral(resourceName: "toujeo")
        self.longInsulinType = json[ApiKey._id].stringValue
        self.longInsulinSubType = json[ApiKey.longInsulinSubType].stringValue
        self.insulinUnit = json[ApiKey.insulinUnit].intValue
        self.cgmType = json[ApiKey.cgmType].stringValue
        self.cgmUnit = json[ApiKey.cgmUnit].intValue
        self.previousCgmReadingTime = json[ApiKey.previousCgmReadingTime].stringValue
    }
    
}

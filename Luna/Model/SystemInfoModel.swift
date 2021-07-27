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
    
    var longInsulinType : String
    var longInsulinSubType : String
    var insulinUnit : Int
    var cgmType : String
    var cgmUnit: Int
    var isFromSetting: Bool = false
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json : JSON = JSON()){
        self.longInsulinType = json[ApiKey._id].stringValue
        self.longInsulinSubType = json[ApiKey.longInsulinSubType].stringValue
        self.insulinUnit = json[ApiKey.insulinUnit].intValue
        self.cgmType = json[ApiKey.cgmType].stringValue
        self.cgmUnit = json[ApiKey.cgmUnit].intValue
    }
    
}

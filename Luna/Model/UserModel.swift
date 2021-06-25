//
//  UserModel.swift
//  Luna
//
//  Created by Admin on 25/06/21.
//

import Foundation
import SwiftyJSON

struct UserModel{
    
    static var main = UserModel(AppUserDefaults.value(forKey: .fullUserProfile)) {
        didSet {
            main.saveToUserDefaults()
        }
    }
    
    var id : String
    var accessToken : String
    var createdAt : String
    var email : String
    var diabetesType: String
    var emailVerified : Bool
    var image : String
    var firstName : String
    var dob : String
    var lastName : String
    var password : String
    var canChangePassword : Bool
    var status : String
    var userType : String
    
    init() {
        self.init(JSON([:]))
    }
    
    init(_ json : JSON = JSON()){
        self.id = json[ApiKey._id].stringValue
        self.accessToken = json[ApiKey.authToken].stringValue
        self.createdAt = json[ApiKey.createdAt].stringValue
        self.email = json[ApiKey.email].stringValue
        self.emailVerified = json[ApiKey.emailVerified].boolValue
        self.image = json[ApiKey.image].stringValue
        self.firstName = json[ApiKey.firstName].stringValue
        self.password = json[ApiKey.password].stringValue
        self.status = json[ApiKey.status].stringValue
        self.userType = json[ApiKey.currentRole].stringValue
        self.canChangePassword = json[ApiKey.canChangePassword].boolValue
        self.dob = json[ApiKey.dob].stringValue
        self.lastName = json[ApiKey.lastName].stringValue
        self.diabetesType = json[ApiKey.diabetesType].stringValue
    }
    
     func fetchUserModel(dict: JSONDictionary) -> UserModel {
        var model = UserModel()
        model.id = dict[ApiKey._id] as? String ?? ""
        model.accessToken = dict[ApiKey.authToken] as? String ?? ""
        model.createdAt = dict[ApiKey.createdAt] as? String ?? ""
        model.email = dict[ApiKey.email] as? String ?? ""
        model.emailVerified = dict[ApiKey.emailVerified] as? Bool ?? false
        model.image = dict[ApiKey.image] as? String ?? ""
        model.password = dict[ApiKey.password] as? String ?? ""
        model.userType = dict[ApiKey.currentRole] as? String ?? ""
        model.canChangePassword = dict[ApiKey.canChangePassword] as? Bool ?? false
        model.dob =  dict[ApiKey.dob] as? String ?? ""
        model.diabetesType = dict[ApiKey.diabetesType] as? String ?? ""
        return model
    }
    
    func saveToUserDefaults() {
        let dict: JSONDictionary = [
            ApiKey._id : id,
            ApiKey.dob: dob,
            ApiKey.firstName : firstName,
            ApiKey.lastName: lastName,
            ApiKey.authToken: accessToken,
            ApiKey.createdAt : createdAt,
            ApiKey.email : email,
            ApiKey.emailVerified : emailVerified,
            ApiKey.image : image,
            ApiKey.password : password,
            ApiKey.status : status,
            ApiKey.userType : userType,
            ApiKey.canChangePassword : canChangePassword,
            ApiKey.diabetesType: diabetesType
        ]
        AppUserDefaults.save(value: dict, forKey: .fullUserProfile)
    }
}

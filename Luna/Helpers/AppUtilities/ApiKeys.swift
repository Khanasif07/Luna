//
//  ApiKeys.swift
//  Luna
//
//  Created by Admin on 03/06/21.
//

import Foundation

//MARK:- Api Keys
//=======================
enum ApiKey {
    
    static var status: String { return "status" }
    static var statusCode: String { return "statusCode" }
    static var code: String { return "CODE" }
    static var result: String { return "result" }
    static var message: String { return "message" }
    static var contactUs : String { return "contactUs" }
    static var Authorization: String { return "Authorization" }
    static var authorization: String { return "authorization" }
    static var contentType: String { return "Content-Type" }
    static var data: String { return "data" }
    static var accessToken: String { return "access_token"}
    static var userType : String { return "userType"}
    static var userRole : String { return "userRole"}
    static var userId : String { return "userId"}
    static var block : String { return "block"}
    static var price : String { return "price"}
    static var messageDuration : String { return "messageDuration"}
    static var lastUpdatedCGMDate: String { return "lastUpdatedCGMDate"}
    
    static var name : String {return "name"}
    static var users : String {return "users"}
    static var userSystemInfo : String {return "userSystemInfo"}
    static var sessionData : String {return "sessionData"}
    static var sessionId : String {return "sessionId"}
    static var sessionHistoryData : String {return "sessionHistoryData"}
    static var dosingHistoryData : String {return "dosingHistoryData"}
    static var sessionHistory : String {return "sessionHistory"}
    static var firstName : String {return "firstName"}
    static var isBiometricOn : String {return "isBiometricOn"}
    static var isAlertsOn : String {return "isAlertsOn"}
    static var deviceId : String { return "deviceId"}
    static var isProfileStepCompleted : String {return "isProfileStepCompleted"}
    static var isSystemSetupCompleted  : String {return "isSystemSetupCompleted"}
    static var lastName : String {return "lastName"}
    static var diabetesType : String {return "diabetesType"}
    static var googleIdToken : String {return "googleIdToken"}
    static var googleAccessToken : String {return "googleAccessToken"}
    static var appleIdToken : String {return "appleIdToken"}
    static var currrentNonce : String {return "currrentNonce"}
    static var isChangePassword : String {return "isChangePassword"}
    
    static var shareUserName : String {return "shareUserName"}
    static var sharePassword : String {return "sharePassword"}
    
    
    static var userName : String {return "userName"}
    static var userImage : String {return "userImage"}
    static var nickName : String {return "nick_name"}
    static var email : String {return "email"}
    static var password : String {return "password"}
    static var countryCode : String {return "countryCode"}
    static var phoneNo : String {return "phoneNo"}
    static var image : String {return "image"}
    static var confirmPasssword : String { return "confirmPasssword"}
    
    static var _id : String {return "_id"}
    static var id : String {return "id"}
    static var otp : String {return "otp"}
    static var platform : String {return "platform"}
    static var device : String {return "device"}
    static var token : String {return "token"}
    static var resetToken : String {return "resetToken"}
    
    static var authToken : String {return "authToken"}
    static var createdAt : String {return "createdAt"}
    static var emailVerified : String {return "emailVerified"}
    static var isDelete : String {return "isDelete"}
    static var language : String {return "language"}
    static var otpExpiry : String {return "otpExpiry"}
    static var phoneVerified : String {return "phoneVerified"}
    static var isGarrage : String {return "isGarrage"}
    static var updatedAt : String {return "updatedAt"}
    
    static var next : String {return "next"}
    static var page : String {return "page"}
    static var limit : String {return "limit"}
    static var description : String {return "description"}
    static var subCategory : String {return "subCategory"}
    static var category : String {return "category"}
    static var onlyMyExpertise :  String {return "onlyMyExpertise"}
    
    static var search : String {return "search"}
    static var dob : String {return "dob"}
    static var oldPassword : String { return "oldPassword" }
    static var newPassword : String { return "newPassword" }

    static var startdate : String { return "startDate" }
    static var endDate : String { return "endDate" }
    static var startDate : String { return "startDate" }
    static var amount: String { return "amount" }
    static var totalAmount: String { return "totalAmount" }
    static var garageRequestId: String { return "garageRequestId" }
    
    static var maxDistance: String { return "maxDistance" }
    static var bidSort: String { return "bidSort" }
    static var minDistance: String { return "minDistance" }
    static var beginCaps: String { return "BEGIN" }
    static var endCaps: String { return "END" }
    static var notifications: String { return "notifications" }
    static var notificationsData: String { return "notificationsData" }

    
    //     MARK: Firestore Keys
    //     ====================
    static var uid : String {return "uid"}
    static var messages: String { return "messages" }
    static var messageType : String {return "messageType"}
    static var messageId : String {return "messageId"}
    static var messageStatus : String {return "messageStatus"}
    static var chat: String { return "chat" }
    static var lastMessage : String {return "lastMessage"}
    static var roomInfo : String {return "roomInfo"}
    static var inbox : String {return "inbox"}
    static var senderId : String {return "senderId"}
    static var receiverId : String {return "receiverId"}
    static var oobCode : String { return "oobCode"}
    static var link : String { return "link"}
    static var firebaseOpenAppScheme : String { return "FirebaseOpenAppScheme"}
    static var firebaseOpenAppURLPrefix : String { return "FirebaseOpenAppURLPrefix"}
    static var firebaseOpenAppQueryItemEmail : String { return "FirebaseOpenAppQueryItemEmail"}
    static var deviceToken : String {return "deviceToken"}
    static var onlineStatus : String {return "onlineStatus"}
    static var messageText : String {return "messageText"}
    static var timeStamp : String {return "timeStamp"}
    static var messageTime : String {return "messageTime"}
    static var unreadMessages : String {return "unreadMessages"}
    static var unreadCount : String {return "unreadCount"}
    static var blocked : String {return "blocked"}
    static var basic : String { return "Basic"}
   
    static var deviceType : String {return "deviceType"}
    static var deviceDetails: String { return "device_details" }
    static var video : String { return "video" }
    static var text : String { return "text" }
    

    
    
    static var longInsulinType  : String {return "longInsulinType" }
    static var longInsulinSubType  : String {return "longInsulinSubType" }
    static var insulinUnit  : String {return "insulinUnit" }
    static var insulin  : String {return "insulin" }
    static var range  : String {return "range" }
    static var cgmType  : String {return "cgmType" }
    static var cgmData  : String {return "cgmData" }
    static var insulinData  : String {return "insulinData" }
    static var insulinDataCaps  : String {return "InsulinData" }
    static var cgmUnit  : String {return "cgmUnit" }
    static var previousCgmReadingTime : String { return "previousCgmReadingTime"}
    static var sgv  : String {return "sgv" }
    static var direction  : String {return "direction" }
    static var date  : String {return "date" }
    static var notificationId: String { return "notificationId"}
    static var title: String { return "title"}
}
//MARK:- Api Code
//=======================
enum ApiCode {
    
    static var success: Int { return 200 } // Success
    static var switchProfileInComplete: Int { return 400 }
    static var unauthorizedRequest: Int { return 206 } // Unauthorized request
    static var headerMissing: Int { return 207 } // Header is missing
    static var requiredParametersMissing: Int { return 418 } // Required Parameter Missing or Invalid
    static var tokenExpired: Int { return 401 } // email not Verified in socialLogin case
    static var logoutSuccess: Int { return 403 } //(Block user)
    static var sessionExpired : Int { return 440 }
    static var emailNotVerify: Int {return 402}
    static var invalidSession: Int {return 498} //(Delete user/ Invalid session)
    
    
    static var notGarageReg: Int {return 600} // not register
    static var pendingGarageReg: Int {return 601}//pending Garage Registration
    static var acceptedGarageReg: Int {return 604} //accepted Garage Registration
    static var rejectedGarageReg: Int {return 605} //rejected Garage Registration
    static var garageBlocked: Int {return 602}// garage blocked by admin
    static var userBlocked: Int {return 603}//user profile blocked by admin
    
    
    static var phoneNumberUpdated: Int {return 250} // only phone number on edit profile (user)
    static var emailUpdated: Int {return 251} // email  updated
    static var phoneEmailUpdated: Int {return 252} // phone and email update
}

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
    
    static var name : String {return "name"}
    static var users : String {return "users"}
    static var userSystemInfo : String {return "userSystemInfo"}
    static var firstName : String {return "firstName"}
    static var isBiometricOn : String {return "isBiometricOn"}
    static var isProfileStepCompleted : String {return "isProfileStepCompleted"}
    static var isSystemSetupCompleted  : String {return "isSystemSetupCompleted"}
    static var lastName : String {return "lastName"}
    static var diabetesType : String {return "diabetesType"}
    static var googleIdToken : String {return "googleIdToken"}
    static var googleAccessToken : String {return "googleAccessToken"}
    static var appleIdToken : String {return "appleIdToken"}
    static var currrentNonce : String {return "currrentNonce"}
    static var isChangePassword : String {return "isChangePassword"}
    
    
    
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
    static var isTeacher : String {return "isTeacher"}
    static var isStudent : String {return "isStudent"}
    static var dob : String {return "dob"}
    static var education : String {return "education"}
    static var bio : String {return "bio"}
    static var role : String {return "role"}
    static var totalExperience : String {return "totalExperience"}
    static var categoryId : String {return "categoryId"}
    static var parentId : String {return "parentId"}
    static var years : String {return "years"}
    static var expertise : String {return "expertise"}
    static var socialType : String {return "socialType"}
    static var socialId : String {return "socialId"}
    static var title : String { return "title"}
    static var subCategoryId : String { return "subCategoryId"}
    static var level : String { return "level"}
    static var url : String { return "url"}
    static var mediaType : String { return "mediaType"}
    static var duration : String { return "duration"}
    static var previewUrl : String { return "previewUrl"}
    static var previewDuration : String { return "previewDuration"}
    static var thumbnail : String { return "thumbnail"}
    static var creditId : String { return "creditId"}
    static var oneDayAcessCredits : String { return "oneDayAcessCredits"}
    static var weeklyAcessCredits : String { return "weeklyAcessCredits"}
    static var biweeklyAcessCredits : String { return "biweeklyAcessCredits"}
    static var monthlyAcessCredits : String { return "monthlyAcessCredits"}
    static var currentRole : String { return "currentRole" }
    static var oldPassword : String { return "oldPassword" }
    static var newPassword : String { return "newPassword" }
    static var sweatLevel: String{ return "sweatLevel"}
    static var playlistId: String{ return "playlistId"}
    static var videoId: String{ return "videoId"}
    static var type: String{ return "type"}
    static var teacherProfile: String { return "teacherProfile"}
    static var studentProfile: String { return "studentProfile"}
    static var videoHostingCreditId: String { return "videoHostingCreditId"}
    static var credits: String{ return "credits"}
    static var previewType: String{ return "previewType"}
    static var isLogin: String{ return "isLogin"}
    static var minvideoCount: String{ return "minvideoCount"}
    static var emailVerifyToken: String { return "emailVerifyToken" }
    static var canChangePassword: String { return "canChangePassword" }
    static var commission: String { return "commission" }
    static var logoUrl: String { return "logoUrl" }
    static var accepted : String { return "accepted" }
    static var isAlreadyRated: String { return " isAlreadyRated "}
    static var isvideoPurchased: String { return " isvideoPurchased"}
    static var videosPurchased: String { return "videosPurchased"}
    static var creditPoints: String { return "creditPoints"}
    static var interests: String { return "interests"}
    static var reportedCount: String { return "reportedCount"}
    static var videosOnPlatform: String { return "videosOnPlatform"}
    static var reviewCount: String { return "reviewCount"}
    static var rating: String { return "rating"}
    static var ratingId: String { return "ratingId"}
    static var categoryID: String { return "categoryId"}
    static var review: String { return "review"}
    static var length: String{ return "length"}
    static var notificationId: String{ return "notificationId"}
    static var membershipCredits: String{ return "membershipCredits"}
    static var isSubscribed: String{ return "isSubscribed"}
    static var phoneNoAdded: String { return "phoneNoAdded" }
    
    static var logo: String { return "logo" }
    static var latitude: String { return "latitude" }
    static var longitude: String { return "longitude" }
    static var address: String { return "address" }
    static var images: String { return "images" }
    static var commercialRegister: String { return "commercialRegister" }
    static var vatCertificate: String { return "vatCertificate" }
    static var municipalityLicense: String { return "municipalityLicense" }
    static var ownerId: String { return "ownerId" }
    static var bank: String { return "bank" }
    static var accountNumber: String { return "accountNumber" }
    
    static var width: String { return "width" }
    static var profile: String { return "profile" }
    static var rimSize: String { return "rimSize" }
    static var quantity: String { return "quantity"}
    static var countries: String { return "countries" }
    static var tyreBrands: String { return "tyreBrands" }
    static var country: String { return "country" }
    
    static var maxInstallationPrice: String { return "maxInstallationPrice" }
    static var minInstallationPrice: String { return "minInstallationPrice" }
    static var services: String { return "services" }
    static var serviceId: String { return "serviceId" }
    static var brands: String { return "brands" }
    static var district : String { return "district" }
    static var garageProfile : String { return "garageProfile" }
    static var garageName : String { return "garageName" }
    static var garageAddress : String { return "garageAddress" }
    static var isgarageProfileComplete : String { return "isgarageProfileComplete" }
    static var garageModel : String { return "garageModel" }
    static var serviceName : String { return "serviceName" }
    
    static var year : String { return "year" }
    static var modelName : String { return "modelName" }
    static var makeId: String { return "makeId" }
    static var model : String { return "model" }
    static var make: String { return "make" }
    static var makeUser: String {return "makeUser" }
    static var countryId: String { return "countryId" }
    static var countryName: String { return "countryName" }
    static var iconImage: String { return "iconImage" }
    static var brandName: String { return "brandName" }
    static var brandId: String { return "brandId" }
    static var reason: String { return "reason" }
    static var time: String { return "time" }
    static var requestId : String { return "requestId" }
    static var bidData : String { return "bidData" }
    static var bidId : String { return "bidId" }
    static var requestType : String { return "requestType" }
    static var startdate : String { return "startDate" }
    static var endDate : String { return "endDate" }
    static var amount: String { return "amount" }
    static var totalAmount: String { return "totalAmount" }
    static var garageRequestId: String { return "garageRequestId" }
    
    static var maxDistance: String { return "maxDistance" }
    static var bidSort: String { return "bidSort" }
    static var minDistance: String { return "minDistance" }

    
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
    
    
    //MARK:-RoomInfo
    //===============
    static var roomId : String {return "roomId"}
    static var roomImage : String {return "roomImage"}
    static var roomName  : String {return "roomName"}
    static var userInfo  :  String {return "userInfo"}
    static var userDetails : String {return "userDetails" }
    static var addedTime  : String {return "addedTime"}
    static var deleteTime : String {return "deleteTime"}
    static var leaveTime   : String {return "leaveTime"}
    static var typingStatus : String {return "typingStatus"}
    static var roomType : String {return "roomType"}
    static var mediaUrl : String {return "mediaUrl"}
    static var batchCount : String {return "batchCount"}
    static var chatType : String {return "chatType"}
    static var single : String {return "single"}
    static var singleCaps : String {return "Single"}
    static var group : String {return "group"}
    static var admin : String {return "admin"}
    static var groupName : String {return "groupName"}
    static var groupImage : String {return "groupImage"}
    
    static var deviceId    : String {return "deviceId"}
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
    

    static var newRequests: String {return "newRequests"}
    static var acceptedRequets: String {return "acceptedRequets"}
    
    static var phoneChanged: String {return "phoneChanged"}
    static var emailChanged: String {return "emailChanged"}
    static var garageId: String {return "garageId"}
    static var garageUserId: String {return "garageUserId"}
    static var bidRequestId: String {return "bidRequestId"}
    static var acceptedProposalId: String {return "acceptedProposalId"}
    static var serviceStatus: String {return "serviceStatus"}
    
    static var revenue: String { return "revenue" }
    static var reviewId: String {return "reviewId"}
    static var reportedTime: String {return "reportedTime"}
    static var reportReason: String {return "reportReason"}
    static var isacceptedProposalEdited: String {return "isacceptedProposalEdited"}

    static var ratingCount: String {return "ratingCount"}
    static var averageRating: String {return "averageRating"}
    static var ongoingServices: String {return "ongoingServices"}
    static var servicesCompletedToday: String {return "servicesCompletedToday"}
    static var notificationType : String {return "notificationType"}
    static var gcm_notification_type : String {return "gcm.notification.type"}
    static var gcm_notification_requestId : String {return "gcm.notification.requestId"}
    static var gcm_notification_senderId : String {return "gcm.notification.senderId"}
    static var gcm_notification_bidRequestId : String {return "gcm.notification.bidRequestId"}
    static var gcm_notification_userRole : String {return "gcm.notification.userRole"}
    static var gcm_notification_userImage : String {return "gcm.notification.userImage" }
    
    static var longInsulinType  : String {return "longInsulinType" }
    static var longInsulinSubType  : String {return "longInsulinSubType" }
    static var insulinUnit  : String {return "insulinUnit" }
    static var cgmType  : String {return "cgmType" }
    static var cgmData  : String {return "cgmData" }
    static var insulinData  : String {return "insulinData" }
    static var cgmUnit  : String {return "cgmUnit" }
    static var sgv  : String {return "sgv" }
    static var direction  : String {return "direction" }
    static var date  : String {return "date" }
    
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

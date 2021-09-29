//
//  FirestoreController.swift
//  Luna
//
//  Created by Admin on 03/06/21.
//

import UIKit
import Firebase
import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftyJSON

typealias JSONDictionary = [String : Any]
typealias JSONDictionaryArray = [JSONDictionary]
typealias HTTPHeaders = [String:String]
typealias SuccessResponse = (_ json : JSON) -> ()
typealias SuccessResponseWithStatus = (_ json : JSON,_ statusCode:Int,_ message:String) -> ()
typealias FailureResponse = (Error) -> (Void)
typealias ResponseMessage = (_ message : String) -> ()
typealias LogoutSuccess = (_ message: String) -> ()

class FirestoreController:NSObject{
    
    static let currentUser = Auth.auth().currentUser
    static let db = Firestore.firestore()
    static let batch = db.batch()
    static var ownUnreadCount = 0
    static var otherUnreadCount = 0
    
    //MARK:- Login
    //============
    static func login(userId: String,
                      withEmail:String,
                      with password:String,
                      success: @escaping () -> Void,
                      failure: @escaping (_ message: String, _ code: Int) -> Void) {
        var emailId  = withEmail
        if emailId.isEmpty{
            emailId = "\(userId)" + "@luna.com"
        }
        Auth.auth().signIn(withEmail: emailId, password: password) { (result, error) in
            if let err = error {
                failure(err.localizedDescription, (err as NSError).code)
            } else {
                let uid = Auth.auth().currentUser?.uid ?? ""
                if Auth.auth().currentUser?.isEmailVerified ?? false {
                    AppUserDefaults.save(value: uid, forKey: .uid)
                    UserModel.main.id = uid
                }
                UserModel.main.email = withEmail
                UserModel.main.password = password
                UserModel.main.isChangePassword = true
                AppUserDefaults.save(value: withEmail, forKey: .defaultEmail)
                AppUserDefaults.save(value: password, forKey: .defaultPassword)
                if !uid.isEmpty {
                    db.collection(ApiKey.users).document(uid).updateData([ApiKey.email: emailId,ApiKey.password: password, ApiKey.deviceToken: AppUserDefaults.value(forKey: .fcmToken).stringValue,
                                                                          ApiKey.deviceType: "iOS",
                                                                          ApiKey.userId: uid])
                    success()
                } else {
                    failure("documentFetchingError", 110)
                }
            }
        }
    }
    
    //MARK:- Get info
    //=======================
    static func getFirebaseUserData(success: @escaping () -> Void,
                                    failure:  @escaping FailureResponse){
        if !(Auth.auth().currentUser?.uid ?? "").isEmpty {
            db.collection(ApiKey.users)
                .document(Auth.auth().currentUser?.uid ?? "").getDocument { (snapshot, error) in
                    if let error = error {
                        failure(error)
                    } else{
                        print("============================")
                        guard let data = snapshot?.data() else { return }
                        var user = UserModel()
                        user.isBiometricOn = data[ApiKey.isBiometricOn] as? Bool ?? false
                        user.id = data[ApiKey.userId] as? String ?? ""
                        user.firstName = data[ApiKey.firstName] as? String ?? ""
                        user.lastName = data[ApiKey.lastName] as? String ?? ""
                        user.dob = data[ApiKey.dob] as? String ?? ""
                        user.email = data[ApiKey.email] as? String ?? ""
                        user.password = data[ApiKey.password] as? String ?? ""
                        user.diabetesType = data[ApiKey.diabetesType] as? String ?? ""
                        user.isProfileStepCompleted = data[ApiKey.isProfileStepCompleted] as? Bool ?? false
                        user.isSystemSetupCompleted = data[ApiKey.isSystemSetupCompleted] as? Bool ?? false
                        user.isChangePassword = data[ApiKey.isChangePassword] as? Bool ?? false
                        user.deviceId = data[ApiKey.deviceId] as? String ?? ""
                        UserModel.main = user
                        //MARK:- Important
                        UserDefaultsRepository.shareUserName.value = data[ApiKey.shareUserName] as? String ?? ""
                        UserDefaultsRepository.sharePassword.value = data[ApiKey.sharePassword] as? String ?? ""
                        AppUserDefaults.save(value: user.isProfileStepCompleted, forKey: .isProfileStepCompleted)
                        AppUserDefaults.save(value: true, forKey: .isBiometricCompleted)
                        AppUserDefaults.save(value: user.deviceId, forKey: .deviceId)
                        AppUserDefaults.save(value: user.isBiometricOn, forKey: .isBiometricSelected)
                        AppUserDefaults.save(value: user.isSystemSetupCompleted, forKey: .isSystemSetupCompleted)
                        success()
                    }
                }
        }
    }
    
    //MARK:- GetUserSystemInfoData
    //=======================
    static func getUserSystemInfoData(success: @escaping () -> Void,
                                      failure:  @escaping FailureResponse){
        if !(Auth.auth().currentUser?.uid ?? "").isEmpty {
            db.collection(ApiKey.userSystemInfo)
                .document(Auth.auth().currentUser?.uid ?? "").getDocument { (snapshot, error) in
                    if let error = error {
                        failure(error)
                    } else{
                        print("============================")
                        guard let data = snapshot?.data() else { return }
                        SystemInfoModel.shared.longInsulinType = data[ApiKey.longInsulinType] as? String ?? ""
                        SystemInfoModel.shared.longInsulinSubType = data[ApiKey.longInsulinSubType] as? String ?? ""
                        SystemInfoModel.shared.insulinUnit = data[ApiKey.insulinUnit] as? Int ?? -1
                        SystemInfoModel.shared.cgmUnit = data[ApiKey.cgmUnit] as? Int ?? -1
//                        SystemInfoModel.shared.cgmType = data[ApiKey.cgmType] as? String ?? ""
                        success()
                    }
                }
        }
    }
    
    
    //MARK:- Get info
    //=======================
    static func checkUserExistInDatabase(success: @escaping () -> Void,
                                         failure:  @escaping () -> Void){
        db.collection(ApiKey.users).document(Auth.auth().currentUser?.uid ?? "").getDocument { (snapshot, error ) in
            if  (snapshot?.exists)! {
                success()
            } else {
                failure()
            }
        }
    }
    
    //MARK:- Check CGM  info Exist or Not
    //=======================
    static func checkCGMDataExistInDatabase(success: @escaping () -> Void,
                                            failure:  @escaping () -> Void){
        db.collection(ApiKey.userSystemInfo).document(Auth.auth().currentUser?.uid ?? "").collection(ApiKey.cgmData).getDocuments { (snapshot, error ) in
            guard let dicts = snapshot?.documents else { return }
            if  !(dicts.isEmpty) {
                success()
            } else {
                failure()
            }
        }
    }
    
    //MARK:- Get CGM Data info
    //=======================
    static func getFirebaseCGMData(success: @escaping (_ cgmModelArray: [ShareGlucoseData]) -> Void,
                                   failure:  @escaping FailureResponse){
        if !(Auth.auth().currentUser?.uid ?? "").isEmpty {
            db.collection(ApiKey.sessionData)
                .document(Auth.auth().currentUser?.uid ?? "").collection(ApiKey.sessionHistory).limit(to: 288).getDocuments { (snapshot, error) in
                    if let error = error {
                        failure(error)
                    } else{
                        print("============================")
                        var cgmModelArray = [ShareGlucoseData]()
                        guard let dicts = snapshot?.documents else { return }
                        dicts.forEach { (queryDocumentSnapshot) in
                            let cgmModel = ShareGlucoseData(queryDocumentSnapshot.data())
                            cgmModelArray.append(cgmModel)
                        }
                        success(cgmModelArray)
                    }
                }
        }
    }
    
    //MARK:- Get Insulin Data info
    //=======================
    static func getFirebaseInsulinData(success: @escaping (_ cgmModelArray: [InsulinDataModel]) -> Void,
                                       failure:  @escaping FailureResponse){
        if !(Auth.auth().currentUser?.uid ?? "").isEmpty {
            db.collection(ApiKey.userSystemInfo)
                .document(Auth.auth().currentUser?.uid ?? "").collection(ApiKey.insulinData).getDocuments { (snapshot, error) in
                    if let error = error {
                        failure(error)
                    } else{
                        print("============================")
                        var insulinModelArray = [InsulinDataModel]()
                        guard let dicts = snapshot?.documents else { return }
                        dicts.forEach { (queryDocumentSnapshot) in
                            let cgmModel = InsulinDataModel(queryDocumentSnapshot.data())
                            insulinModelArray.append(cgmModel)
                        }
                        success(insulinModelArray)
                    }
                }
        }
    }
    
    //MARK:- Get info
    //=======================
    static func checkUserExistInSystemDatabase(success: @escaping () -> Void,
                                               failure:  @escaping () -> Void){
        db.collection(ApiKey.userSystemInfo).document(Auth.auth().currentUser?.uid ?? "").getDocument { (snapshot, error ) in
            if  (snapshot?.exists)! {
                print("User Document exist")
                success()
            } else {
                failure()
                print("User Document does not exist")
            }
        }
    }
    
    //MARK:- logoutUser
    //=======================
    static func logOut(completion:@escaping(_ errorOccured: Bool) -> Void)  {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
        } catch _ as NSError {
            completion(true)
        }
        completion(false)
    }
    
    static func performCleanUp(for_logout: Bool = true) {
        let isTermsAndConditionSelected  = AppUserDefaults.value(forKey: .isTermsAndConditionSelected).boolValue
        let isBiometricEnable = AppUserDefaults.value(forKey: .isBiometricSelected).boolValue
        let isBiometricCompleted = AppUserDefaults.value(forKey: .isBiometricCompleted).boolValue
        AppUserDefaults.removeAllValues()
        UserModel.main = UserModel()
        if for_logout {
            AppUserDefaults.save(value: isTermsAndConditionSelected, forKey: .isTermsAndConditionSelected)
            AppUserDefaults.save(value: isBiometricEnable, forKey: .isBiometricSelected)
            AppUserDefaults.save(value: isBiometricCompleted, forKey: .isBiometricCompleted)
        }
        UserDefaultsRepository.shareUserName.value = ""
        UserDefaultsRepository.sharePassword.value = ""
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        DispatchQueue.main.async {
            AppRouter.goToSignUpVC()
        }
        if  for_logout {
            FirestoreController.logOut { (isLogout) in
                if !isLogout {
                    DispatchQueue.main.async {
                        AppRouter.goToLoginVC()
                    }
                }
            }
        }
    }
    
    //MARK:- IsEMailVerified
    //=======================
    static func IsEmailVerified(completion:@escaping(_ success: Bool) -> Void)  {
        let isEmailVerification  = Auth.auth().currentUser?.isEmailVerified ??  false
        completion(isEmailVerification)
    }
    
    
    //MARK:- CREATE ROOM NODE
    //=======================
    static func createRoomNode(roomId: String,
                               roomImage: String,
                               roomName: String,
                               roomType: String,
                               userInfo: [String:Any],
                               userTypingStatus: [String:Any]) {
        db.collection(ApiKey.roomInfo).document(roomId).setData([ApiKey.roomId : roomId,
                                                                 ApiKey.roomImage:roomImage,
                                                                 ApiKey.roomName:roomName,
                                                                 ApiKey.roomType:roomType,
                                                                 ApiKey.userInfo:userInfo,
                                                                 ApiKey.typingStatus:userTypingStatus])
    }
    
    //MARK:- CREATE USER NODE
    //=======================
    static func createUserNode(userId: String,
                               email: String,
                               password: String,
                               name: String,
                               imageURL: String,
                               dob: String,
                               diabetesType: String,
                               isProfileStepCompleted: Bool,
                               isSystemSetupCompleted: Bool,
                               isChangePassword:Bool,
                               isBiometricOn:  Bool,
                               deviceId: String,
                               shareUserName:String,
                               sharePassword:String,
                               completion: @escaping () -> Void,
                               failure: @escaping FailureResponse) {
        var emailId  = email
        if emailId.isEmpty{
            emailId = "\(userId)" + "@luna.com"
        }
        Auth.auth().createUser(withEmail: emailId, password: password) { (result, error) in
            if let err = error {
                AppUserDefaults.save(value: false, forKey: .isSignupCompleted)
                failure(err)
            } else {
                let uid = Auth.auth().currentUser?.uid ?? ""
                if Auth.auth().currentUser?.isEmailVerified ?? false{
                    AppUserDefaults.save(value: uid, forKey: .uid)
                    UserModel.main.id = uid
                }
                AppUserDefaults.save(value: true, forKey: .isSignupCompleted)
                AppUserDefaults.save(value: email, forKey: .defaultEmail)
                AppUserDefaults.save(value: password, forKey: .defaultPassword)
                db.collection(ApiKey.users).document(uid).setData([ApiKey.deviceType:"iOS",
                                                                   ApiKey.email: email,
                                                                   ApiKey.deviceToken:AppUserDefaults.value(forKey: .fcmToken).stringValue,
                                                                   ApiKey.password:password,
                                                                   ApiKey.isProfileStepCompleted: false,
                                                                   ApiKey.isSystemSetupCompleted: false,
                                                                   ApiKey.userId: uid,ApiKey.isChangePassword: true,ApiKey.deviceId:deviceId,
                                                                   ApiKey.isBiometricOn: AppUserDefaults.value(forKey: .isBiometricSelected).boolValue,ApiKey.shareUserName:shareUserName,ApiKey.sharePassword:sharePassword]){ err in
                    if let err = err {
                        print("Error writing document: \(err)")
                        CommonFunctions.showToastWithMessage(err.localizedDescription)
                    } else {
                        print("Document successfully written!")
                    }
                }
                completion()
            }
        }
    }
    
    //MARK:- FORGET PASSWORD USER
    //=======================
    static func forgetPassword(email: String,
                               completion: @escaping () -> Void,
                               failure: @escaping FailureResponse) {
        var emailId  = email
        if emailId.isEmpty{
            emailId = "" + "@luna.com"
        }
        Auth.auth().sendPasswordReset(withEmail: emailId) { (error) in
            if error == nil {
                completion()
            }else{
                if let error = error {
                    failure(error)
                }
            }
        }
    }
    
    //MARK:- SEND VERIFICATION MAIL
    //=======================
    static func sendEmailVerification( completion:  @escaping FailureResponse){
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            if let err = error {
                completion(err)
            }
        })
    }
    
    //MARK:- setFirebaseData
    //=======================
    static func setFirebaseData(userId: String,
                                email: String,
                                password: String,
                                firstName: String,
                                lastName: String,
                                dob: String,
                                diabetesType: String,
                                isProfileStepCompleted: Bool,
                                isSystemSetupCompleted: Bool,
                                isChangePassword:Bool,
                                isBiometricOn:  Bool,
                                completion: @escaping () -> Void,
                                failure: @escaping FailureResponse){
        AppUserDefaults.save(value: userId, forKey: .uid)
        AppUserDefaults.save(value: email, forKey: .defaultEmail)
        AppUserDefaults.save(value: password, forKey: .defaultPassword)
        db.collection(ApiKey.users).document(userId).setData([ApiKey.deviceType:"iOS",
                                                              ApiKey.email: email,
                                                              ApiKey.deviceToken:AppUserDefaults.value(forKey: .fcmToken).stringValue,
                                                              ApiKey.firstName:firstName,
                                                              ApiKey.lastName: lastName,
                                                              ApiKey.isSystemSetupCompleted:isSystemSetupCompleted,
                                                              ApiKey.isProfileStepCompleted:isProfileStepCompleted,
                                                              ApiKey.userId: userId,
                                                              ApiKey.dob: dob,ApiKey.isChangePassword: isChangePassword,ApiKey.isBiometricOn: isBiometricOn]){ err in
            if let err = err {
                failure(err)
                print("Error writing document: \(err)")
            } else {
                completion()
                print("Document successfully written!")
            }
        }
    }
    
    //MARK:- Update user data
    //=======================
    static func updateUserNode(email: String,
                               password: String,
                               firstName: String,
                               lastName: String,
                               dob: String,
                               diabetesType: String,
                               isProfileStepCompleted: Bool,
                               isSystemSetupCompleted: Bool,
                               isBiometricOn: Bool,
                               completion: @escaping () -> Void,
                               failure: @escaping FailureResponse) {
        let uid = AppUserDefaults.value(forKey: .uid).stringValue
        db.collection(ApiKey.users).document(uid).updateData([ApiKey.deviceType:"iOS",
                                                              ApiKey.email: email,
                                                              ApiKey.deviceToken:AppUserDefaults.value(forKey: .fcmToken).stringValue,
                                                              ApiKey.firstName:firstName,
                                                              ApiKey.lastName: lastName,
                                                              ApiKey.diabetesType: diabetesType,
                                                              ApiKey.isSystemSetupCompleted:isSystemSetupCompleted,
                                                              ApiKey.isProfileStepCompleted:isProfileStepCompleted,
                                                              ApiKey.isBiometricOn: isBiometricOn,
                                                              ApiKey.dob: dob])
        { (error) in
            if let err = error {
                failure(err)
            } else {
                completion()
            }
        }
    }
    
    //MARK:- Update user Biometric status
    //================================
    static func updateUserBiometricStatus(isBiometricOn: Bool, completion: @escaping () -> Void,
                                          failure: @escaping FailureResponse,failures: @escaping () -> Void) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        guard !uid.isEmpty else {
            failures()
            return
        }
        db.collection(ApiKey.users).document(uid).updateData([ApiKey.isBiometricOn:isBiometricOn]){
            (error) in
            if let err = error {
                failure(err)
            } else {
                completion()
            }
        }
    }
    
    //MARK:- Update user Signin status
    //================================
    static func updateDeviceID(deviceId: String) {
        print(deviceId)
        let uid = Auth.auth().currentUser?.uid ?? ""
        guard !uid.isEmpty else {
            return
        }
        db.collection(ApiKey.users).document(uid).updateData([ApiKey.deviceId:deviceId])
    }
    
    //MARK:- Update Dexcom creds
    //================================
    static func updateDexcomCreds(shareUserName: String,sharePassword:String) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        guard !uid.isEmpty else {
            return
        }
        db.collection(ApiKey.users).document(uid).updateData([ApiKey.shareUserName:shareUserName,ApiKey.sharePassword:sharePassword])
    }
    
    //MARK:- Update user System Setup Status
    //================================
    static func updateUserSystemSetupStatus(isSystemSetupCompleted: Bool, completion: @escaping () -> Void,
                                            failure: @escaping FailureResponse) {
        let uid = AppUserDefaults.value(forKey: .uid).stringValue
        guard !uid.isEmpty else { return }
        db.collection(ApiKey.users).document(uid).updateData([ApiKey.isSystemSetupCompleted:isSystemSetupCompleted]){ (error) in
            if let err = error {
                failure(err)
            } else {
                completion()
            }
        }
    }
    
    //MARK:- Add  Listener System Setup Status
    //================================
    static func addDeviceIdListener(_ completion: @escaping (String) -> Void,
                                    failure: @escaping FailureResponse){
        let uid = Auth.auth().currentUser?.uid ?? ""
        guard !uid.isEmpty else { return }
        db.collection(ApiKey.users).document(uid)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    completion("")
                    return
                }
                completion(data[ApiKey.deviceId] as? String ?? "")
                print("Current data: \(data)")
            }
    }
    
    
    //MARK:- setSystemInfoData
    //=======================
    static func setSystemInfoData(userId: String,
                                  longInsulinType: String,
                                  longInsulinSubType: String,
                                  insulinUnit: Int,
                                  cgmType: String,
                                  cgmUnit: Int,
                                  completion: @escaping () -> Void,
                                  failure: @escaping FailureResponse){
        db.collection(ApiKey.userSystemInfo).document(userId).setData([
                                                                        ApiKey.longInsulinType: longInsulinType,
                                                                        ApiKey.longInsulinSubType:longInsulinSubType,
                                                                        ApiKey.insulinUnit:insulinUnit,
                                                                        ApiKey.cgmType: cgmType,
                                                                        ApiKey.cgmUnit:cgmUnit]){ err in
            if let err = err {
                failure(err)
                print("Error writing document: \(err)")
            } else {
                completion()
                print("Document successfully written!")
            }
        }
    }
    
    //MARK:- updateSystemInfoData
    //=======================
    static func updateSystemInfoData(userId: String,
                                     longInsulinType: String,
                                     longInsulinSubType: String,
                                     insulinUnit: Int,
                                     cgmType: String,
                                     cgmUnit: Int,
                                     completion: @escaping () -> Void,
                                     failure: @escaping FailureResponse){
        db.collection(ApiKey.userSystemInfo).document(userId).updateData([
                                                                            ApiKey.longInsulinType: longInsulinType,
                                                                            ApiKey.longInsulinSubType:longInsulinSubType,
                                                                            ApiKey.insulinUnit:insulinUnit,
                                                                            ApiKey.cgmType: cgmType,
                                                                            ApiKey.cgmUnit:cgmUnit]){ err in
            if let err = err {
                failure(err)
                print("Error writing document: \(err)")
            } else {
                completion()
                print("Document successfully written!")
            }
        }
    }
    
    //MARK:- Update user online status
    //================================
    static func updateDeviceToken() {
        let uid = AppUserDefaults.value(forKey: .uid).stringValue
        guard !uid.isEmpty else { return }
        db.collection(ApiKey.users).document(uid).updateData([ApiKey.deviceToken: ""])
    }
    
    //MARK:-Fetching Listing
    //======================
    static func fetchingUserNode(listing: [String], dict: [String:Any], tableView: UITableView) {
        db.collection(ApiKey.users).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if document.data()["userId"] as? String != AppUserDefaults.value(forKey: .uid).stringValue {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
                tableView.reloadData()
            }
        }
    }
    
    //MARK:- CREATE LAST MESSAGE NODE
    //===============================
    static func createLastMessageNode(roomId:String,messageText:String,messageTime:FieldValue,messageId:String,messageType:String,messageStatus:Int,senderId:String,receiverId:String,mediaUrl:String,blocked: Bool, thumbNailURL: String,messageDuration: Int,price: Double, amIBlocked : Bool) {
        
        db.collection(ApiKey.lastMessage)
            .document(roomId)
            .collection(ApiKey.chat)
            .document(ApiKey.message)
            .setData([ApiKey.messageText:messageText,
                      ApiKey.messageId:messageId,
                      ApiKey.messageTime:FieldValue.serverTimestamp(),
                      ApiKey.messageStatus:messageStatus,
                      ApiKey.messageType:messageType,
                      ApiKey.senderId:senderId,
                      ApiKey.receiverId:receiverId,
                      ApiKey.roomId:roomId,
                      ApiKey.mediaUrl : mediaUrl,
                      ApiKey.blocked :blocked,
                      ApiKey.price: price,
                      ApiKey.messageDuration : messageDuration])
        
        if !amIBlocked {
            db.collection(ApiKey.lastMessage)
                .document(roomId)
                .collection(ApiKey.chat)
                .document(receiverId).delete()
        }
    }
    
    //MARK:- CREATE LAST MESSAGE NODE AFTER DELETE MESSAGE
    //===============================
    static func createLastMessageNodeAfterDeleteMessage(roomId:String,messageText:String,messageTime:Timestamp,messageId:String,messageType:String,messageStatus:Int,senderId:String,receiverId:String,mediaUrl:String,blocked: Bool, thumbNailURL: String,messageDuration: Int,price: Double, amIBlocked : Bool) {
        
        db.collection(ApiKey.lastMessage)
            .document(roomId)
            .collection(ApiKey.chat)
            .document(ApiKey.message)
            .setData([ApiKey.messageText:messageText,
                      ApiKey.messageId:messageId,
                      ApiKey.messageTime: messageTime,
                      ApiKey.messageStatus:messageStatus,
                      ApiKey.messageType:messageType,
                      ApiKey.senderId:senderId,
                      ApiKey.receiverId:receiverId,
                      ApiKey.roomId:roomId,
                      ApiKey.mediaUrl : mediaUrl,
                      ApiKey.blocked :blocked,
                      ApiKey.price: price,
                      ApiKey.messageDuration : messageDuration])
        
    }
    
    //MARK:- CREATE LAST MESSAGE OF BLOCKED USER
    //==========================================
    static func createLastMessageOfBlockedUser(roomId: String, senderId: String, messageModel: [String:Any]) {
        db.collection(ApiKey.lastMessage)
            .document(roomId)
            .collection(ApiKey.chat)
            .document(senderId).setData(messageModel)
    }
    
    //MARK:- CREATE TOTAL MESSAGE COUNT
    //=================================
    static func getTotalMessagesCount(senderId: String) {
        db.collection(ApiKey.batchCount).document(senderId).addSnapshotListener { (documentSnapshot, error) in
            if  let error = error {
                print(error.localizedDescription)
            }else{
                guard let documents = documentSnapshot?.data() else {return}
                for totalUnreadMessages in documents{
                    FirestoreController.otherUnreadCount = totalUnreadMessages.value as? Int ?? 0
                }
            }
        }
    }
    
    //MARK:- CREATE TOTAL MESSAGE NODE
    //================================
    static func createTotalMessageNode(receiverId: String) {
        db.collection(ApiKey.batchCount)
            .document(receiverId)
            .setData([ApiKey.unreadCount: FirestoreController.otherUnreadCount + 1])
    }
    
    //MARK:-GetUnreadMessages
    //=======================
    static func getUnreadMessageCount(receiverId: String, senderId: String) {
        db.collection(ApiKey.inbox)
            .document(senderId)
            .collection(ApiKey.chat)
            .document(receiverId)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else { print("Error fetching document: \(error!)")
                    return }
                guard let data = document.data() else { return }
                FirestoreController.otherUnreadCount =   data[ApiKey.unreadCount] as? Int ?? 0
            }
    }
    
    static func updateUnreadMessages(senderId: String, receiverId: String, unread: Int) {
        db.collection(ApiKey.inbox)
            .document(receiverId)
            .collection(ApiKey.chat)
            .document(senderId)
            .updateData([ApiKey.unreadCount : unread + 1])
        
        db.collection(ApiKey.batchCount).document(receiverId).getDocument { (document, error) in
            if let doc = document {
                if doc.exists {
                    guard let count = doc.data()?[ApiKey.unreadCount] as? Int else { return }
                    db.collection(ApiKey.batchCount).document(receiverId).setData([ApiKey.unreadCount : count + 1])
                } else {
                    db.collection(ApiKey.batchCount).document(receiverId).setData([ApiKey.unreadCount: 1])
                }
            }
        }
    }
    
    static func updateUnreadMessagesAfterDeleteMessage(senderId: String, receiverId: String, unread: Int) {
        db.collection(ApiKey.inbox)
            .document(receiverId)
            .collection(ApiKey.chat)
            .document(senderId)
            .updateData([ApiKey.unreadCount : unread - 1])
        
        db.collection(ApiKey.batchCount).document(receiverId).getDocument { (document, error) in
            if let doc = document {
                if doc.exists {
                    guard let count = doc.data()?[ApiKey.unreadCount] as? Int else { return }
                    db.collection(ApiKey.batchCount).document(receiverId).setData([ApiKey.unreadCount : count - 1])
                } else {
                    db.collection(ApiKey.batchCount).document(receiverId).setData([ApiKey.unreadCount: 0])
                }
            }
        }
    }
    
    static func uploadMedia(croppedImage: UIImage, progressEsc: @escaping (Progress)->(),completion: @escaping (_ url: String?) -> Void) {
        let storageRef = Storage.storage().reference().child("images/\(croppedImage).png")
        let image =  self.resizeImage(image: croppedImage, newWidth: 200.0)
        if let uploadData = image.pngData(){
            let uploadTask = storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {
                    storageRef.downloadURL { (url, error) in
                        completion(url?.absoluteString)
                    }
                }
            }
            
            _ = uploadTask.observe(.progress, handler: { snapshot in
                if let progressSnap = snapshot.progress {
                    progressEsc(progressSnap)
                }
            })
            
            _ = uploadTask.observe(.success, handler: { snapshot in
                if snapshot.status == .success {
                    uploadTask.removeAllObservers()
                    completion(nil)
                }
            })
            
        }
    }
    
    static func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? UIImage()
    }
    
    static func uploadVideo(_ path: URL,
                            progressEsc: @escaping (Progress)->(),
                            completionEsc: @escaping ()->(),
                            errorEsc: @escaping (Error)->(),
                            completion: @escaping (_ url: String?) -> Void) {
        
        let localFile: URL = path
        let videoName = getName()
        let storageRef = Storage.storage().reference().child("videos/\(videoName).png")
        let metadata = StorageMetadata()
        metadata.contentType = "video"
        
        let uploadTask = storageRef.putFile(from: localFile, metadata: metadata) { metadata, error in
            if error != nil {
                errorEsc(error!)
            } else {
                storageRef.downloadURL { (url, error) in
                    completion(url?.absoluteString)
                    
                }
            }
        }
        
        _ = uploadTask.observe(.progress, handler: { snapshot in
            if let progressSnap = snapshot.progress {
                progressEsc(progressSnap)
            }
        })
        
        _ = uploadTask.observe(.success, handler: { snapshot in
            if snapshot.status == .success {
                uploadTask.removeAllObservers()
                completionEsc()
            }
        })
    }
    
    static func getName() -> String {
        let dateFormatter = DateFormatter()
        let dateFormat = "yyyyMMddHHmmss"
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.string(from: Date())
        let name = date.appending(".mp4")
        return name
    }
    
    //MARK:-CreateBlockNode
    static func createBlockNode(senderId:String,receiverId:String,success:@escaping()->()){
        db.collection(ApiKey.block).document(senderId).setData([receiverId :FieldValue.serverTimestamp()])
        success()
        
        
    }
    //MARK:-CheckIsBlock
    static func checkIsBlock(receiverId:String,_ completion :  @escaping(Bool)->()){
        db.collection(ApiKey.block).document(receiverId).getDocument { (documentSnapshot, error) in
            if  error != nil{
                
            }else{
                documentSnapshot?.data()?.forEach({ (blocedUser,blockedTime) in
                    if blocedUser == AppUserDefaults.value(forKey: .uid).stringValue{
                        completion(true)
                    }
                })
            }
        }
        
    }
    
    static func isReceiverBlocked(senderId:String,receiverId:String,_ completion :  @escaping(Bool)->()){
        db.collection(ApiKey.block).document(senderId).getDocument { (documentSnapshot, error) in
            if  error != nil{
                print(error?.localizedDescription ?? "Some error")
            } else{
                documentSnapshot?.data()?.forEach({ (userId,blockedTime) in
                    if userId == receiverId{
                        completion(true)
                    }
                })
            }
        }
    }
    
    //MARK:-UpdateLastMessagePath
    //===========================
    static func updateLastMessagePathInInbox(senderId:String,receiverId:String,roomId:String,success: @escaping ()-> ()){
        
        db.collection(ApiKey.inbox)
            .document(receiverId)
            .collection(ApiKey.chat)
            .document(senderId)
            .setData([ApiKey.roomId:roomId,
                      ApiKey.roomInfo: db.collection(ApiKey.roomInfo).document(roomId),
                      ApiKey.timeStamp: FieldValue.serverTimestamp(),
                      ApiKey.lastMessage: db.collection(ApiKey.lastMessage).document(roomId).collection(ApiKey.chat).document(senderId),
                      ApiKey.userDetails: db.collection(ApiKey.users).document(senderId)])
            { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Success")
                }
            }
    }
    
    //MARK:-CreateMessageNode
    //=======================
    static func createMessageNode(roomId:String,messageText:String,messageTime:FieldValue,messageId:String,messageType:String,messageStatus:Int,senderId:String,receiverId:String,mediaUrl:String,blocked: Bool, thumbNailURL: String,messageDuration: Int,price: Double){
        
        db.collection(ApiKey.messages).document(roomId).collection(ApiKey.chat).document(messageId).setData([ApiKey.messageText:messageText,
                                                                                                             ApiKey.messageId:messageId,
                                                                                                             ApiKey.messageTime:FieldValue.serverTimestamp(),
                                                                                                             ApiKey.messageStatus:messageStatus,
                                                                                                             ApiKey.messageType:messageType,
                                                                                                             ApiKey.senderId:senderId,
                                                                                                             ApiKey.receiverId:receiverId,
                                                                                                             ApiKey.roomId:roomId,
                                                                                                             ApiKey.mediaUrl : mediaUrl,
                                                                                                             ApiKey.blocked :blocked,
                                                                                                             ApiKey.price: price,
                                                                                                             ApiKey.messageDuration: messageDuration])
        /// States of the messages
        /// 0 - pending, 1 - sent, 2 - delivered, 3 - read
        
    }
    
    //MARK:-CreateCGMDataNode
    //=======================
    static func createCGMDataNode(direction: String,sgv: Int,date: TimeInterval){
        let userId = Auth.auth().currentUser?.uid ?? ""
        db.collection(ApiKey.userSystemInfo).document(userId).collection(ApiKey.cgmData).document(String(date)).setData([ApiKey.sgv: sgv,ApiKey.direction: direction,ApiKey.date: date])
        
    }
    
    static func createInsulinDataNode(insulinUnit: String,date: TimeInterval){
        let userId = Auth.auth().currentUser?.uid ?? ""
        db.collection(ApiKey.userSystemInfo).document(userId).collection(ApiKey.insulinData).document(String(date)).setData([ApiKey.insulinUnit: insulinUnit,ApiKey.date: date])
    }
    
    
    static func delete(batchSize: Int = 288,success: @escaping ()-> ()) {
        let userId = Auth.auth().currentUser?.uid ?? ""
        // Limit query to avoid out-of-memory errors on large collections.
        // When deleting a collection guaranteed to fit in memory, batching can be avoided entirely.
        db.collection(ApiKey.userSystemInfo).document(userId).collection(ApiKey.cgmData).limit(to: batchSize).getDocuments { (docset, error) in
            // An error occurred.
            let docset = docset
            
            //            let batch = collection.firestore.batch()
            let batch = db.batch()
            docset?.documents.forEach { batch.deleteDocument($0.reference) }
            
            batch.commit {_ in
                success()
                //                self.delete(batchSize: batchSize)
            }
        }
    }
    
    static func addBatchData(array:[ShareGlucoseData],success: @escaping ()-> ()) {
        let userId = Auth.auth().currentUser?.uid ?? ""
        let batch = db.batch()
        array.forEach { (doc) in
            let docRef = db.collection(ApiKey.sessionData).document(userId).collection(ApiKey.sessionHistory).document(String(doc.date))
            batch.setData([ApiKey.sgv: doc.sgv,ApiKey.direction: doc.direction ?? "",ApiKey.date: doc.date], forDocument: docRef)
        }
        batch.commit { (err) in
            if let err = err{
                print("Error occured \(err)")
            } else {
            print("Commited successfully")
            }
        }
    }
    
    static func showAlert( title : String = "", msg : String,_ completion : (()->())? = nil) {
        let alertViewController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title:"ok", style: UIAlertAction.Style.default) { (action : UIAlertAction) -> Void in
            alertViewController.dismiss(animated: true, completion: nil)
            completion?()
        }
        alertViewController.addAction(okAction)
        AppDelegate.shared.window?.rootViewController?.present(alertViewController, animated: true, completion: nil)
    }
    
   static func updateBadge(val: Int) {
        DispatchQueue.main.async {
        if UserDefaultsRepository.appBadge.value {
            let latestBG = String(val)
            UIApplication.shared.applicationIconBadgeNumber = Int(bgUnits.removePeriodForBadge(bgUnits.toDisplayUnits(latestBG))) ?? val
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        }
    }
}


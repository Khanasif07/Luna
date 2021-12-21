//
//  Extension+LoginViewController.swift
//  Luna
//
//  Created by Admin on 27/09/21.
//
import UIKit
import GoogleSignIn
import CoreBluetooth
import CryptoKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import FirebaseCore
import LocalAuthentication
import AuthenticationServices
import SwiftKeychainWrapper
// MARK: - Extension For ASAuthorizationControllerDelegate
//====================================
extension LoginViewController: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding{
    public func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    public func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            // Save authorised user ID for future reference
            // Retrieve the secure nonce generated during Apple sign in
            guard let nonce = self.currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            // Retrieve Apple identity token
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Failed to fetch identity token")
                return
            }
            
            // Convert Apple identity token to string
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Failed to decode identity token")
                return
            }
            // Initialize a Firebase credential using secure nonce and Apple identity token
            let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                              idToken: idTokenString,
                                                              rawNonce: nonce)
            KeychainWrapper.standard.set(idTokenString, forKey: ApiKey.appleIdToken)
            KeychainWrapper.standard.set(nonce, forKey: ApiKey.currrentNonce)
            // Sign in with Firebase
            CommonFunctions.showActivityLoader()
            Auth.auth().signIn(with: firebaseCredential) { (authResult, error) in
                
                if let error = error {
                    CommonFunctions.hideActivityLoader()
                    AppUserDefaults.removeValue(forKey: .uid)
                    CommonFunctions.showToastWithMessage(error.localizedDescription)
                    return
                }
                if let currentUser = Auth.auth().currentUser {
                    AppUserDefaults.save(value: currentUser.uid, forKey: .uid)
                    AppUserDefaults.save(value: currentUser.email ?? "", forKey: .defaultEmail)
                    UserModel.main.id = currentUser.uid
                    UserModel.main.email = currentUser.email ?? ""
                    UserModel.main.isChangePassword = false
                    FirestoreController.checkUserExistInDatabase {
                        FirestoreController.getFirebaseUserData {
                            CommonFunctions.hideActivityLoader()
                            DispatchQueue.main.async {
                                if UserModel.main.isSystemSetupCompleted {
                                    //MARK:- USED TO UPDATE USER SIGNIN STATUS
                                    if let uuid = UIDevice.current.identifierForVendor?.uuidString {
                                        FirestoreController.updateDeviceID(deviceId: uuid)
                                    }
                                    AppRouter.gotoHomeVC()
                                    return
                                }else if UserModel.main.isProfileStepCompleted  {
                                    AppRouter.gotoSystemSetupVC()
                                    return
                                }else {
                                    self.goToProfileSetupVC()
                                    return
                                }
                            }
                        } failure: { (error) -> (Void) in
                            CommonFunctions.hideActivityLoader()
                            CommonFunctions.showToastWithMessage(error.localizedDescription)
                        }
                    } failure: { () -> (Void) in
                        FirestoreController.setFirebaseData(userId: currentUser.uid, email: currentUser.email ?? "", password: "", firstName: currentUser.displayName ?? "", lastName: "", dob: "", diabetesType: "", isProfileStepCompleted: false, isSystemSetupCompleted: false, isChangePassword: false, isBiometricOn: true, isAlertsOn: true) {
                            CommonFunctions.hideActivityLoader()
                            DispatchQueue.main.async {
                                if UserModel.main.isSystemSetupCompleted {
                                    //MARK:- USED TO UPDATE USER SIGNIN STATUS
                                    FirestoreController.updateDeviceID(deviceId: AppUserDefaults.value(forKey: .deviceId).stringValue)
                                    AppRouter.gotoHomeVC()
                                    return
                                }else if UserModel.main.isProfileStepCompleted  {
                                    AppRouter.gotoSystemSetupVC()
                                    return
                                }else {
                                    self.goToProfileSetupVC()
                                    return
                                }
                            }
                        } failure: { (error) -> (Void) in
                            CommonFunctions.hideActivityLoader()
                            AppUserDefaults.removeValue(forKey: .uid)
                            CommonFunctions.showToastWithMessage(error.localizedDescription)
                        }
                    }
                }
                CommonFunctions.hideActivityLoader()
            }
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
    
    
}

// MARK: - GIDSignInDelegate
//===========================
extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            return
        }
        CommonFunctions.showActivityLoader()
        print("User Email: \(user.profile.email ?? "No EMail")")
        print("User Name: \(user.profile.name ?? "No Name")")
        print("User FaMILYNAME: \(user.profile.familyName ?? "No Name")")
        print("User USERID: \(user.userID ?? "No Name")")
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        KeychainWrapper.standard.set(authentication.idToken, forKey: ApiKey.googleIdToken)
        KeychainWrapper.standard.set(authentication.accessToken, forKey: ApiKey.googleAccessToken)
        // Authenticate with Firebase using the credential object
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                CommonFunctions.hideActivityLoader()
                AppUserDefaults.removeValue(forKey: .uid)
                CommonFunctions.showToastWithMessage(error.localizedDescription)
                return
            }
            if let currentUser = Auth.auth().currentUser {
                AppUserDefaults.save(value: currentUser.uid, forKey: .uid)
                AppUserDefaults.save(value: currentUser.email ?? "", forKey: .defaultEmail)
                UserModel.main.id = currentUser.uid
                UserModel.main.email = currentUser.email ?? ""
                UserModel.main.isChangePassword = false
                FirestoreController.checkUserExistInDatabase {
                    FirestoreController.getFirebaseUserData {
                        CommonFunctions.hideActivityLoader()
                        DispatchQueue.main.async {
                            if UserModel.main.isSystemSetupCompleted {
                                //MARK:- USED TO UPDATE USER SIGNIN STATUS
                                if let uuid = UIDevice.current.identifierForVendor?.uuidString {
                                    FirestoreController.updateDeviceID(deviceId: uuid)
                                }
                                AppRouter.gotoHomeVC()
                                return
                            }else if UserModel.main.isProfileStepCompleted  {
                                AppRouter.gotoSystemSetupVC()
                                return
                            }else {
                                self.goToProfileSetupVC()
                                return
                            }
                        }
                    } failure: { (error) -> (Void) in
                        CommonFunctions.hideActivityLoader()
                        CommonFunctions.showToastWithMessage(error.localizedDescription)
                    }
                } failure: { () -> (Void) in
                    FirestoreController.setFirebaseData(userId: currentUser.uid, email: currentUser.email ?? "", password: "", firstName: user.profile.name, lastName: "", dob: "", diabetesType: "", isProfileStepCompleted: false, isSystemSetupCompleted: false, isChangePassword: false, isBiometricOn: true, isAlertsOn: true) {
                        CommonFunctions.hideActivityLoader()
                        DispatchQueue.main.async {
                            if UserModel.main.isSystemSetupCompleted {
                                //MARK:- USED TO UPDATE USER SIGNIN STATUS
                                if let uuid = UIDevice.current.identifierForVendor?.uuidString {
                                    FirestoreController.updateDeviceID(deviceId: uuid)
                                }
                                AppRouter.gotoHomeVC()
                                return
                            }else if UserModel.main.isProfileStepCompleted  {
                                AppRouter.gotoSystemSetupVC()
                                return
                            }else {
                                self.goToProfileSetupVC()
                                return
                            }
                        }
                    } failure: { (error) -> (Void) in
                        CommonFunctions.hideActivityLoader()
                        AppUserDefaults.removeValue(forKey: .uid)
                        CommonFunctions.showToastWithMessage(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        print("User has disconnected")
    }
    
    func signIn(_ signIn: GIDSignIn!,
        presentViewController viewController: UIViewController!) {
      self.present(viewController, animated: true, completion: nil)
    }
    
    func signIn(_ signIn: GIDSignIn!,
        dismissViewController viewController: UIViewController!) {
      self.dismiss(animated: true, completion: nil)
    }
    
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        // myActivityIndicator.stopAnimating()
    }

}

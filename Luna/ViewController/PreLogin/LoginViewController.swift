//
//  LoginViewController.swift
//  Luna
//
//  Created by Admin on 15/06/21.
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

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var loginTableView: UITableView!
    
    
    // MARK: - Variables
    //===========================
    var emailTxt: String = ""
    var passTxt : String =  ""
    var currentNonce : String?
    private let biometricIDAuth = BiometricIDAuth()
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            // Fallback on earlier versions
            return .lightContent
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loginTableView.reloadData()
    }
    
    // MARK: - IBActions
    //===========================
    
    
}

// MARK: - Extension For Functions
//===========================
extension LoginViewController {
    
    private func initialSetup() {
        self.tableViewSetUp()
        if  AppUserDefaults.value(forKey: .isBiometricCompleted).boolValue {
            if  AppUserDefaults.value(forKey: .isBiometricSelected).boolValue{
                self.bioMetricSignin()
            }else {
                print("Do Not show biometric popup")
            }
        }else {
            guard let email = KeychainWrapper.standard.string(forKey: ApiKey.email), let password = KeychainWrapper.standard.string(forKey: ApiKey.password) else {
                return
            }
            if !email.isEmpty && !password.isEmpty{
                self.bioMetricSignin()
            }
        }
    }
    
    public func tableViewSetUp(){
        self.loginTableView.delegate = self
        self.loginTableView.dataSource = self
        self.loginTableView.tableHeaderView = headerView
        self.loginTableView.tableHeaderView?.height = 200.0
        self.loginTableView.registerCell(with: LoginSocialTableCell.self)
        self.loginTableView.registerCell(with: SignUpTopTableCell.self)
    }
    
    private func signUpBtnStatus()-> Bool{
        return !self.emailTxt.isEmpty && !self.passTxt.isEmpty
    }
    
    func reloadUser(_ callback: ((Error?) -> ())? = nil){
        Auth.auth().currentUser?.reload(completion: { (error) in
            callback?(error)
        })
    }
    
    private func googleSetUp(){
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    func goToSignUpVC() {
        let signupVC = SignupViewController.instantiate(fromAppStoryboard: .PreLogin)
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
    private func goToForgotPassVC(){
        let forgotPassVC  = ForgotPasswordVC.instantiate(fromAppStoryboard: .PreLogin)
        self.navigationController?.pushViewController(forgotPassVC, animated: true)
    }
    
    func goToProfileSetupVC(){
       let bleVC = ProfileSetupVC.instantiate(fromAppStoryboard: .PreLogin)
       self.navigationController?.pushViewController(bleVC, animated: true)
   }
    
    private func gotoEmailVerificationPopUpVC(){
        let scene =  PassResetPopUpVC.instantiate(fromAppStoryboard: .PreLogin)
        scene.emailVerificationSuccess = { [weak self] in
            guard let selff = self else { return }
            print(selff)
        }
        scene.popupType = .emailVerification
        scene.titleDesc = "Email Verification"
        scene.subTitleDesc = "Please check your email - A verification link has been sent to your registered email account."
        self.present(scene, animated: true, completion: nil)
    }
    
    private func getActionCodes()->ActionCodeSettings{
        let actionCodeSettings =  ActionCodeSettings.init()
        actionCodeSettings.handleCodeInApp = true
        var components = URLComponents()
        let queryItemEmailName = InfoPlistParser.getStringValue(forKey: "FirebaseOpenAppQueryItemEmail")
        let querySchemeName = InfoPlistParser.getStringValue(forKey: "FirebaseOpenAppScheme")
        let queryUrlPrefixName = InfoPlistParser.getStringValue(forKey: "FirebaseOpenAppURLPrefix")
        components.scheme = querySchemeName
        components.host = queryUrlPrefixName
        let emailUrlQueryItem = URLQueryItem(name: queryItemEmailName, value: self.emailTxt)
        components.queryItems = [emailUrlQueryItem]
        guard let linkUrl = components.url else { return  ActionCodeSettings.init() }
        print("link parameter is \(linkUrl)")
        actionCodeSettings.url = linkUrl
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        return actionCodeSettings
    }
    
    private func bioMetricSignin() {
        var error: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            biometricIDAuth.canEvaluate { (canEvaluate, _, canEvaluateError) in
                guard canEvaluate else {
                    CommonFunctions.showToastWithMessage("Face ID/Touch ID may not be available or configured")
                    return
                }
                biometricIDAuth.evaluate { [weak self] (success, error) in
                    guard let `self` = self else { return }
                    DispatchQueue.main.async {
                    if success{
                        guard let email = KeychainWrapper.standard.string(forKey: ApiKey.email), let password = KeychainWrapper.standard.string(forKey: ApiKey.password) else {
                            return
                        }
                        if !email.isEmpty && !password.isEmpty{
                            self.emailTxt = email
                            self.passTxt = password
                            self.loginTableView.reloadData()
                        }
                    } else {
                        if (error! as NSError).code != -2 {
                            CommonFunctions.showToastWithMessage("Invalid biometric input")
                        }
                    }
                  }
                }
            }
        }else {
            guard let error = error else { return }
            showAlert(title: LocalizedString.biometricAuthNotAvailable.localized, msg: error.localizedDescription)
        }
    }
}

// MARK: - Extension For TableView
//===========================

extension LoginViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueCell(with: SignUpTopTableCell.self, indexPath: indexPath)
            cell.emailIdTxtField.text = emailTxt
            cell.passTxtField.text = passTxt
            cell.titleLbl.text = LocalizedString.login.localized
            cell.subTitleLbl.text = LocalizedString.please_login_to_get_good_sleep.localized
            cell.signUpBtn.setTitle(LocalizedString.login.localized, for: .normal)
            cell.signUpBtn.isEnabled = signUpBtnStatus()
            cell.forgotPassBtn.isHidden = false
            [cell.emailIdTxtField,cell.passTxtField].forEach({$0?.delegate = self})
            cell.signUpBtnTapped = { [weak self]  (sender) in
                guard let `self` = self else { return }
                if !self.isEmailValid(string: self.emailTxt).0{
                    cell.emailIdTxtField.setError(self.isEmailValid(string: self.emailTxt).1)
                    CommonFunctions.delay(delay: 1.0) {
                        cell.emailIdTxtField.setError("",show: false)
                    }
                    return
                }
                CommonFunctions.showActivityLoader()
                if let currentUser = Auth.auth().currentUser {
                    self.reloadUser { (reloadMsg) in
                        if  (currentUser.isEmailVerified) {
                            FirestoreController.login(userId: currentUser.uid, withEmail: self.emailTxt, with: self.passTxt, success: {
                                CommonFunctions.hideActivityLoader()
                                self.goToProfileSetupVC()
                                //                        FirestoreController.setFirebaseData(userId: "", email: self.emailTxt, password: self.passTxt, name:"", imageURL: "", phoneNo: "", countryCode: "", status: "", completion: {
                                //                            CommonFunctions.hideActivityLoader()
                                //                            self.goToBLEVC()
                                //                        }) { (error) -> (Void) in
                                //                            AppUserDefaults.removeValue(forKey: .accesstoken)
                                //                            CommonFunctions.hideActivityLoader()
                                //                            CommonFunctions.showToastWithMessage(error.localizedDescription)
                                //                        }
                            }) { (message, code) in
                                CommonFunctions.hideActivityLoader()
                                CommonFunctions.showToastWithMessage(message)
                            }
                        } else {
                            CommonFunctions.hideActivityLoader()
                            Auth.auth().currentUser?.sendEmailVerification(with: self.getActionCodes(), completion: { (err) in
                                if let err = err {
                                    print(err.localizedDescription)
                                    CommonFunctions.showToastWithMessage(err.localizedDescription)
                                    return
                                }
                                DispatchQueue.main.async {
                                    self.gotoEmailVerificationPopUpVC()
                                }
                            })
                        }
                    }
                } else {
                    FirestoreController.login(userId: "", withEmail: self.emailTxt, with: self.passTxt, success: {
                        CommonFunctions.hideActivityLoader()
                        if Auth.auth().currentUser?.isEmailVerified ?? false {
                                self.goToProfileSetupVC()
                        } else {
                            CommonFunctions.hideActivityLoader()
                            Auth.auth().currentUser?.sendEmailVerification(with: self.getActionCodes(), completion: { (err) in
                                if let err = err {
                                    print(err.localizedDescription)
                                    CommonFunctions.showToastWithMessage(err.localizedDescription)
                                    return
                                }
                                DispatchQueue.main.async {
                                    self.gotoEmailVerificationPopUpVC()
                                }
                            })
                        }
                       
                        //                        FirestoreController.setFirebaseData(userId: "", email: self.emailTxt, password: self.passTxt, name:"", imageURL: "", phoneNo: "", countryCode: "", status: "", completion: {
                        //                            CommonFunctions.hideActivityLoader()
                        //                            self.goToBLEVC()
                        //                        }) { (error) -> (Void) in
                        //                            AppUserDefaults.removeValue(forKey: .accesstoken)
                        //                            CommonFunctions.hideActivityLoader()
                        //                            CommonFunctions.showToastWithMessage(error.localizedDescription)
                        //                        }
                    }) { (message, code) in
                        CommonFunctions.hideActivityLoader()
                        CommonFunctions.showToastWithMessage(message)
                    }
                }
            }
            cell.forgotPassBtnTapped = { [weak self]  (sender) in
                guard let `self` = self else { return }
                self.goToForgotPassVC()
            }
            return cell
        default:
            let cell = tableView.dequeueCell(with: LoginSocialTableCell.self, indexPath: indexPath)
            cell.signupLoginDescText = LocalizedString.dont_have_an_account.localized
            cell.signupLoginText = LocalizedString.signup.localized
            cell.setUpAttributedString()
            cell.googleBtnTapped = {[weak self] in
                guard let self = `self` else { return }
                self.googleSetUp()
            }
            cell.appleBtnTapped = { [weak self] in
                guard let self = `self` else { return }
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = [.fullName, .email]
                
                // Generate nonce for validation after authentication successful
                self.currentNonce = self.randomNonceString()
                // Set the SHA256 hashed nonce to ASAuthorizationAppleIDRequest
                request.nonce = self.sha256(self.currentNonce!)
                
                // Present Apple authorization form
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = self
                authorizationController.presentationContextProvider = self
                authorizationController.performRequests()
            }
            cell.loginBtnTapped = { [weak self] in
                guard let self = `self` else { return }
                self.goToSignUpVC()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}



// MARK: - Extension For TextField Delegate
//====================================
extension LoginViewController : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let cell = loginTableView.cell(forItem: textField) as? SignUpTopTableCell
        switch textField {
        case cell?.emailIdTxtField:
            cell?.emailIdTxtField.setBorder(width: 1.0, color: AppColors.appGreenColor)
        case cell?.passTxtField:
            cell?.passTxtField.setBorder(width: 1.0, color: AppColors.appGreenColor)
        default:
            cell?.signUpBtn.isEnabled = signUpBtnStatus()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let txt = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        let cell = loginTableView.cell(forItem: textField) as? SignUpTopTableCell
        switch textField {
        case cell?.emailIdTxtField:
            self.emailTxt = txt
            cell?.signUpBtn.isEnabled = signUpBtnStatus()
            cell?.emailIdTxtField.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
        case cell?.passTxtField:
            self.passTxt = txt
            cell?.signUpBtn.isEnabled = signUpBtnStatus()
            cell?.passTxtField.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
        default:
            cell?.signUpBtn.isEnabled = signUpBtnStatus()
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cell = loginTableView.cell(forItem: textField) as? SignUpTopTableCell
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        switch textField {
        case cell?.emailIdTxtField:
            return (string.checkIfValidCharaters(.email) || string.isEmpty) && newString.length <= 50
        case cell?.passTxtField:
            return (string.checkIfValidCharaters(.password) || string.isEmpty) && newString.length <= 25
        default:
            return false
        }
    }
}


// MARK: - Extension For ASAuthorizationControllerDelegate
//====================================
extension LoginViewController: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding{
    private func randomNonceString(length: Int = 32) -> String {
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
    
    private func sha256(_ input: String) -> String {
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
            
            // Sign in with Firebase
            CommonFunctions.showActivityLoader()
            Auth.auth().signIn(with: firebaseCredential) { (authResult, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                    CommonFunctions.hideActivityLoader()
                    CommonFunctions.showToastWithMessage(error.localizedDescription)
                    return
                }
                CommonFunctions.hideActivityLoader()
                if let currentUser = Auth.auth().currentUser {
                    AppUserDefaults.save(value: currentUser.uid, forKey: .uid)
                    AppUserDefaults.save(value: currentUser.uid, forKey: .accesstoken)
                    AppUserDefaults.save(value: currentUser.email ?? "", forKey: .defaultEmail)
                    UserModel.main.id = currentUser.uid
                    UserModel.main.accessToken = currentUser.uid
                    UserModel.main.email = currentUser.email ?? ""
                    UserModel.main.canChangePassword = false
                }
                DispatchQueue.main.async {
                    self.goToProfileSetupVC()
                }
                // Mak a request to set user's display name on Firebase
//                let changeRequest = authResult?.user.createProfileChangeRequest()
//                changeRequest?.displayName = appleIDCredential.fullName?.givenName
//                changeRequest?.commitChanges(completion: { (error) in
//
//                    if let error = error {
//                        print(error.localizedDescription)
//                    } else {
//                        print("Updated display name: \(Auth.auth().currentUser!.email!)")
//                    }
//                })
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
        // Authenticate with Firebase using the credential object
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                CommonFunctions.hideActivityLoader()
                CommonFunctions.showToastWithMessage(error.localizedDescription)
                print("Error occurs when authenticate with Firebase: \(error.localizedDescription)")
            }
            CommonFunctions.hideActivityLoader()
            if let currentUser = Auth.auth().currentUser {
                AppUserDefaults.save(value: currentUser.uid, forKey: .uid)
                AppUserDefaults.save(value: currentUser.uid, forKey: .accesstoken)
                AppUserDefaults.save(value: currentUser.email ?? "", forKey: .defaultEmail)
                UserModel.main.id = currentUser.uid
                UserModel.main.accessToken = currentUser.uid
            }
            UserModel.main.email = "\(user.profile.email ?? "")"
            UserModel.main.canChangePassword = false
            DispatchQueue.main.async {
                self.self.goToProfileSetupVC()
            }
            print("post notification after user successfully sign in")
//            FirestoreController.setFirebaseData(userId: user.userID, email: user.profile.email, password: "", name: user.profile.name, imageURL: "", phoneNo: "", countryCode: "", status: "", completion: {
//                print("Success")
//            }) { (error) -> (Void) in
//                AppUserDefaults.removeValue(forKey: .accesstoken)
//                print(error.localizedDescription)
//            }
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

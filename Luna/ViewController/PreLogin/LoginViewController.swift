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
    var isComeFromMail: Bool = false
    private let biometricIDAuth = BiometricIDAuth()
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            if userInterfaceStyle == .dark{
                return .darkContent
            }else{
                return .darkContent
            }
        } else {
            return .lightContent
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        self.tabBarController?.tabBar.isHidden = true
        if isComeFromMail{
            self.showBiometricAuthentication()
            self.isComeFromMail = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - IBActions
    //===========================
}

// MARK: - Extension For Functions
//===========================
extension LoginViewController {
    
    private func initialSetup() {
        if #available(iOS 13.0, *) {
        overrideUserInterfaceStyle = .light
        }
        self.tableViewSetUp()
        self.showBiometricAuthentication()
    }
    
    private func showBiometricAuthentication(){
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
    
    
    private func goToSignUpVC() {
        let signupVC = SignupViewController.instantiate(fromAppStoryboard: .PreLogin)
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
    private func goToForgotPassVC(){
        let forgotPassVC  = ForgotPasswordVC.instantiate(fromAppStoryboard: .PreLogin)
        self.navigationController?.pushViewController(forgotPassVC, animated: true)
    }
    
    private func goToProfileSetupVC(){
       let bleVC = ProfileSetupVC.instantiate(fromAppStoryboard: .PreLogin)
       self.navigationController?.pushViewController(bleVC, animated: false)
   }
    
    private func gotoEmailVerificationPopUpVC(){
        let scene =  PassResetPopUpVC.instantiate(fromAppStoryboard: .PreLogin)
        scene.emailVerificationSuccess = { [weak self] in
            guard let selff = self else { return }
            let cell = selff.loginTableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? SignUpTopTableCell
            cell?.emailIdTxtField.text = ""
            cell?.passTxtField.text = ""
            selff.passTxt = ""
            selff.emailTxt = ""
            cell?.signUpBtn.isEnabled = selff.signUpBtnStatus()
            selff.loginTableView.reloadData()
        }
        scene.popupType = .emailVerification
        scene.titleDesc = LocalizedString.email_Verification.localized
        scene.subTitleDesc = LocalizedString.please_check_your_email_sent.localized
        self.present(scene, animated: true, completion: nil)
    }
    
    private func getActionCodes()->ActionCodeSettings{
        let actionCodeSettings =  ActionCodeSettings.init()
        actionCodeSettings.handleCodeInApp = true
        var components = URLComponents()
        let queryItemEmailName = InfoPlistParser.getStringValue(forKey: ApiKey.firebaseOpenAppQueryItemEmail)
        let querySchemeName = InfoPlistParser.getStringValue(forKey: ApiKey.firebaseOpenAppScheme)
        let queryUrlPrefixName = InfoPlistParser.getStringValue(forKey: ApiKey.firebaseOpenAppURLPrefix)
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
                    CommonFunctions.showToastWithMessage(LocalizedString.faceID_Touch_ID_may_not_be_available_or_configured.localized)
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
            cell.titleLbl.text = LocalizedString.lOGIN_TO_LUNA.localized
            cell.subTitleLbl.text = ""
            cell.signUpBtn.setTitle(LocalizedString.login.localized, for: .normal)
            cell.signUpBtn.isEnabled = signUpBtnStatus()
            cell.forgotPassBtn.isHidden = false
            [cell.emailIdTxtField,cell.passTxtField].forEach({$0?.delegate = self})
            cell.signUpBtnTapped = { [weak self]  (sender) in
                guard let `self` = self else { return }
                if !self.isEmailValid(string: self.emailTxt).0{
                    cell.emailIdTxtField.setError(self.isEmailValid(string: self.emailTxt).1)
                    return
                }
                CommonFunctions.showActivityLoader()
                if let currentUser = Auth.auth().currentUser {
                    self.reloadUser { (reloadMsg) in
                        if  (currentUser.isEmailVerified) {
                            FirestoreController.login(userId: currentUser.uid, withEmail: self.emailTxt, with: self.passTxt, success: {
                                FirestoreController.getFirebaseUserData {
                                    CommonFunctions.hideActivityLoader()
                                    DispatchQueue.main.async {
                                        if UserModel.main.isSystemSetupCompleted {
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
                            }) { (message, code) in
                                CommonFunctions.hideActivityLoader()
                                CommonFunctions.showToastWithMessage(message)
                            }
                        } else {
                            CommonFunctions.hideActivityLoader()
                            Auth.auth().currentUser?.sendEmailVerification(with: self.getActionCodes(), completion: { (err) in
                                if let err = err {
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
                        if Auth.auth().currentUser?.isEmailVerified ?? false {
                            FirestoreController.getFirebaseUserData {
                                CommonFunctions.hideActivityLoader()
                                DispatchQueue.main.async {
                                    if UserModel.main.isSystemSetupCompleted {
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
                        } else {
                            CommonFunctions.hideActivityLoader()
                            Auth.auth().currentUser?.sendEmailVerification(with: self.getActionCodes(), completion: { (err) in
                                if let err = err {
                                    CommonFunctions.showToastWithMessage(err.localizedDescription)
                                    return
                                }
                                DispatchQueue.main.async {
                                    self.passTxt = ""
                                    self.loginTableView.reloadData()
                                    self.gotoEmailVerificationPopUpVC()
                                }
                            })
                        }
                    }) { (message, code) in
                        CommonFunctions.hideActivityLoader()
                        CommonFunctions.showToastWithMessage(message)
                    }
                }
            }
            cell.forgotPassBtnTapped = { [weak self]  (sender) in
                guard let `self` = self else { return }
                self.emailTxt = ""
                self.passTxt = ""
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
                self.pop()
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
            if !self.isEmailValid(string: self.emailTxt).0{
                cell?.emailIdTxtField.setError(self.isEmailValid(string: self.emailTxt).1)
            }else{
                cell?.emailIdTxtField.setError("",show: false)
            }
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
                        FirestoreController.setFirebaseData(userId: currentUser.uid, email: currentUser.email ?? "", password: "", firstName: currentUser.displayName ?? "", lastName: "", dob: "", diabetesType: "", isProfileStepCompleted: false, isSystemSetupCompleted: false, isChangePassword: false, isBiometricOn: true) {
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
                    FirestoreController.setFirebaseData(userId: currentUser.uid, email: currentUser.email ?? "", password: "", firstName: user.profile.name, lastName: "", dob: "", diabetesType: "", isProfileStepCompleted: false, isSystemSetupCompleted: false, isChangePassword: false, isBiometricOn: true) {
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

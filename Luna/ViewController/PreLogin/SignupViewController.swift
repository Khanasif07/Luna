//
//  SignupViewController.swift
//  Luna
//
//  Created by Admin on 15/06/21.
//

import UIKit
import GoogleSignIn
import CryptoKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import FirebaseCore
import LocalAuthentication
import AuthenticationServices
import SwiftKeychainWrapper
import HealthKit

class SignupViewController: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var signupTableView: UITableView!
    
    
    // MARK: - Variables
    //===========================
    var emailTxt = ""
    var passTxt = ""
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
            if userInterfaceStyle == .dark{
                return .darkContent
            }else{
                return .darkContent
            }
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
    
    // MARK: - IBActions
    //===========================
    
    
}

// MARK: - Extension For Functions
//===========================
extension SignupViewController {
    
    private func initialSetup() {
        if #available(iOS 13.0, *) {
        overrideUserInterfaceStyle = .light
        }
        self.tableViewSetUp()
        HealthKitManager.sharedInstance.authorizeHealthKit { (isEnable, error) in
            if let error = error{
                print(error.localizedDescription)
            }else {
                print(isEnable)
                print(HKHealthStore.isHealthDataAvailable())
            }
        }
    }
    
    private func googleSetUp(){
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().signIn()
    }
    
    public func tableViewSetUp(){
        self.signupTableView.delegate = self
        self.signupTableView.dataSource = self
        self.signupTableView.tableHeaderView = headerView
        self.signupTableView.tableHeaderView?.height = 200.0
        self.signupTableView.registerCell(with: LoginSocialTableCell.self)
        self.signupTableView.registerCell(with: SignUpTopTableCell.self)
    }
    
    private func signUpBtnStatus()-> Bool{
        return !self.emailTxt.isEmpty && !self.passTxt.isEmpty
    }
    
    func reloadUser(_ callback: ((Error?) -> ())? = nil){
        Auth.auth().currentUser?.reload(completion: { (error) in
            callback?(error)
        })
    }
    
    private func gotoLoginVC(){
        let loginVC = LoginViewController.instantiate(fromAppStoryboard: .PreLogin)
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func goToProfileSetupVC(){
       let bleVC = ProfileSetupVC.instantiate(fromAppStoryboard: .PreLogin)
       self.navigationController?.pushViewController(bleVC, animated: true)
   }
    
    func goToBLEVC(){
       let bleVC = BLEIntegrationVC.instantiate(fromAppStoryboard: .PostLogin)
       self.navigationController?.pushViewController(bleVC, animated: true)
   }
    
    private func gotoEmailVerificationPopUpVC(){
        let scene =  PassResetPopUpVC.instantiate(fromAppStoryboard: .PreLogin)
        scene.emailVerificationSuccess = { [weak self] in
            guard let selff = self else { return }
            let cell = selff.signupTableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? SignUpTopTableCell
            cell?.emailIdTxtField.text = ""
            cell?.passTxtField.text = ""
            selff.passTxt = ""
            selff.emailTxt = ""
            cell?.signUpBtn.isEnabled = selff.signUpBtnStatus()
            selff.signupTableView.reloadData()
            selff.gotoLoginVC()
        }
        scene.popupType = .emailVerification
        scene.titleDesc = LocalizedString.email_verification.localized
        scene.subTitleDesc = LocalizedString.please_check_your_emai_A_verification_link_has_been_sent_to_your_registered_email_account.localized
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
        components.path = "/open"
        let emailUrlQueryItem = URLQueryItem(name: queryItemEmailName, value: self.emailTxt)
        components.queryItems = [emailUrlQueryItem]
        guard let linkUrl = components.url else { return  ActionCodeSettings.init() }
        print("link parameter is \(linkUrl)")
        actionCodeSettings.url = linkUrl
        actionCodeSettings.dynamicLinkDomain = "lunadiabetes.page.link"
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        return actionCodeSettings
    }
    
    private func showAlertForBiometric(){
        var bioMetricReason = ""
        var biometric = ""
        if hasTopNotch {
            bioMetricReason = LocalizedString.allowFaceId.localized
            biometric =  LocalizedString.faceID.localized
        } else {
            bioMetricReason = LocalizedString.allowTouchId.localized
            biometric =  LocalizedString.touchID.localized
        }
        self.showAlertWithAction(title: bioMetricReason, msg: "Use \(biometric) to sign into Luna without entering your password.", cancelTitle: "Don’t Allow", actionTitle: "Allow") {
            let email = AppUserDefaults.value(forKey: .defaultEmail).stringValue
            let password = AppUserDefaults.value(forKey: .defaultPassword).stringValue
            KeychainWrapper.standard.set(email, forKey: ApiKey.email)
            KeychainWrapper.standard.set(password, forKey: ApiKey.password)
            AppUserDefaults.save(value: true, forKey: .isBiometricSelected)
            AppUserDefaults.save(value: true, forKey: .isBiometricCompleted)
            self.sendEmailVerificationLink()
        } cancelcompletion: {
            KeychainWrapper.standard.removeObject(forKey: ApiKey.password)
            KeychainWrapper.standard.removeObject(forKey: ApiKey.email)
            AppUserDefaults.save(value: false, forKey: .isBiometricSelected)
            AppUserDefaults.save(value: true, forKey: .isBiometricCompleted)
            self.sendEmailVerificationLink()
        }
    }
    
    private func sendEmailVerificationLink(){
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

// MARK: - Extension For TableView
//===========================

extension SignupViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueCell(with: SignUpTopTableCell.self, indexPath: indexPath)
            cell.titleLbl.text = LocalizedString.signup.localized
            cell.subTitleLbl.text = LocalizedString.please_create_account_to_get_good_sleep.localized
            cell.signUpBtn.setTitle(LocalizedString.signup.localized, for: .normal)
            cell.forgotPassBtn.isHidden = true
            [cell.emailIdTxtField,cell.passTxtField].forEach({$0?.delegate = self})
            cell.signUpBtnTapped = { [weak self]  (sender) in
                guard let `self` = self else { return }
                if !self.isEmailValid(string: self.emailTxt).0{
                    cell.emailIdTxtField.setError(self.isEmailValid(string: self.emailTxt).1)
                    return
                }
                if !self.isPassValid(string: self.passTxt).0{
                    cell.passTxtField.setError(self.isPassValid(string: self.passTxt).1)
                    return
                }
                CommonFunctions.showActivityLoader()
                FirestoreController.createUserNode(userId: "", email: self.emailTxt, password: self.passTxt, name: "", imageURL: "", dob: "", diabetesType: "", isProfileStepCompleted: false, isChangePassword: true, isBiometricOn: AppUserDefaults.value(forKey: .isBiometricSelected).boolValue, completion: {
                        CommonFunctions.hideActivityLoader()
                    if Auth.auth().currentUser?.isEmailVerified ?? false{
                            self.goToProfileSetupVC()
                        }else{
                            self.showAlertForBiometric()
                        }
                    }) { (error) -> (Void)  in
                        CommonFunctions.hideActivityLoader()
                        CommonFunctions.showToastWithMessage(error.localizedDescription)
                    }
            }
            return cell
        default:
            let cell = tableView.dequeueCell(with: LoginSocialTableCell.self, indexPath: indexPath)
            cell.signupLoginDescText = LocalizedString.alreadyHaveAnAccount.localized
            cell.signupLoginText = LocalizedString.login.localized
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
//                self.pop()
                self.gotoLoginVC()
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
extension SignupViewController : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let cell = signupTableView.cell(forItem: textField) as? SignUpTopTableCell
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
        let cell = signupTableView.cell(forItem: textField) as? SignUpTopTableCell
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
            if !self.isPassValid(string: self.passTxt).0{
                cell?.passTxtField.setError(self.isPassValid(string: self.passTxt).1)
            }else{
                cell?.passTxtField.setError("",show: false)
            }
        default:
            cell?.signUpBtn.isEnabled = signUpBtnStatus()
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cell = signupTableView.cell(forItem: textField) as? SignUpTopTableCell
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
extension SignupViewController: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding{
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
                                if UserModel.main.isProfileStepCompleted {
                                    AppRouter.gotoHomeVC()
                                }else {
                                    self.goToProfileSetupVC()
                                }
                            }
                        } failure: { (error) -> (Void) in
                            CommonFunctions.hideActivityLoader()
                            CommonFunctions.showToastWithMessage(error.localizedDescription)
                        }
                    } failure: { () -> (Void) in
                        FirestoreController.setFirebaseData(userId: currentUser.uid, email: currentUser.email ?? "", password: "", firstName: currentUser.displayName ?? "", lastName: "", dob: "", diabetesType: "", isProfileStepCompleted: false, isChangePassword: false, isBiometricOn: true) {
                            CommonFunctions.hideActivityLoader()
                            DispatchQueue.main.async {
                                if UserModel.main.isProfileStepCompleted {
                                    AppRouter.gotoHomeVC()
                                }else {
                                    self.goToProfileSetupVC()
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
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
    
    
}

// MARK: - GIDSignInDelegate
//===========================
extension SignupViewController: GIDSignInDelegate {
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
                                if UserModel.main.isProfileStepCompleted {
                                    AppRouter.gotoHomeVC()
                                }else {
                                    self.goToProfileSetupVC()
                                }
                        }
                    } failure: { (error) -> (Void) in
                        CommonFunctions.hideActivityLoader()
                        CommonFunctions.showToastWithMessage(error.localizedDescription)
                    }
                } failure: { () -> (Void) in
                    FirestoreController.setFirebaseData(userId: currentUser.uid, email: currentUser.email ?? "", password: "", firstName: user.profile.name, lastName: "", dob: "", diabetesType: "", isProfileStepCompleted: false, isChangePassword: false, isBiometricOn: true) {
                        CommonFunctions.hideActivityLoader()
                        DispatchQueue.main.async {
                            if UserModel.main.isProfileStepCompleted {
                                AppRouter.gotoHomeVC()
                            }else {
                                self.goToProfileSetupVC()
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

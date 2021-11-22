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
    
    
    public func goToSignUpVC() {
        let signupVC = SignupViewController.instantiate(fromAppStoryboard: .PreLogin)
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
    public func goToForgotPassVC(){
        let forgotPassVC  = ForgotPasswordVC.instantiate(fromAppStoryboard: .PreLogin)
        self.navigationController?.pushViewController(forgotPassVC, animated: true)
    }
    
    public func goToProfileSetupVC(){
       let bleVC = ProfileSetupVC.instantiate(fromAppStoryboard: .PreLogin)
       self.navigationController?.pushViewController(bleVC, animated: false)
   }
    
    private func gotoEmailVerificationPopUpVC(){
        let scene =  PassResetPopUpVC.instantiate(fromAppStoryboard: .PreLogin)
        scene.emailVerificationSuccess = { [weak self] in
            guard let self = self else { return }
            let cell = self.loginTableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? SignUpTopTableCell
            cell?.emailIdTxtField.text = ""
            cell?.passTxtField.text = ""
            self.passTxt = ""
            self.emailTxt = ""
            cell?.signUpBtn.isEnabled = self.signUpBtnStatus()
            self.loginTableView.reloadData()
        }
        scene.popupType = .emailVerification
        scene.titleDesc = LocalizedString.email_Verification.localized
        scene.subTitleDesc = LocalizedString.please_check_your_email_sent.localized
        self.present(scene, animated: true, completion: nil)
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
            cell.configureCellSignInScreen(emailTxt:emailTxt,passTxt:passTxt)
            cell.signUpBtn.isEnabled = signUpBtnStatus()
            [cell.emailIdTxtField,cell.passTxtField].forEach({$0?.delegate = self})
            //MARK: - Login Button Action
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
                            FirestoreController.sendEmailVerificationLink(emailTxt: self.emailTxt) {
                                DispatchQueue.main.async {
                                    self.gotoEmailVerificationPopUpVC()
                                }
                            } failure: { (errs) -> (Void) in
                                CommonFunctions.showToastWithMessage(errs.localizedDescription)
                            }
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
                            FirestoreController.sendEmailVerificationLink(emailTxt: self.emailTxt) {
                                DispatchQueue.main.async {
                                    self.passTxt = ""
                                    self.loginTableView.reloadData()
                                    self.gotoEmailVerificationPopUpVC()
                                }
                            } failure: { (errs) -> (Void) in
                                CommonFunctions.showToastWithMessage(errs.localizedDescription)
                            }
                        }
                    }) { (message, code) in
                        CommonFunctions.hideActivityLoader()
                        CommonFunctions.showToastWithMessage(message)
                    }
                }
            }
            //MARK: - Forgot Button Action
            cell.forgotPassBtnTapped = { [weak self]  (sender) in
                guard let `self` = self else { return }
                self.emailTxt = ""
                self.passTxt = ""
                self.goToForgotPassVC()
            }
            return cell
        default:
            let cell = tableView.dequeueCell(with: LoginSocialTableCell.self, indexPath: indexPath)
            cell.configureCellSigninScreen()
            //MARK: - Google Button Action
            cell.googleBtnTapped = {[weak self] in
                guard let self = `self` else { return }
                self.googleSetUp()
            }
            //MARK: - Apple Button Action
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
            //MARK: - Login Button Action
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
        let cell = loginTableView.cell(forItem: textField) as? SignUpTopTableCell
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        switch textField {
        case cell?.emailIdTxtField:
            return (string.checkIfValidCharaters(.email) || string.isEmpty) && newString.length <= 50
        case cell?.passTxtField:
            return (string.checkIfValidCharaters(.email) || string.isEmpty)
        default:
            return false
        }
    }
}

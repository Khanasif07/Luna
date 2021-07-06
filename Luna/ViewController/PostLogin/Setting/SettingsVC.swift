//
//  SettingsVC.swift
//  Luna
//
//  Created by Admin on 22/06/21.
//


import UIKit
import SwiftKeychainWrapper
import FirebaseAuth
import FirebaseDatabase
import Firebase

class SettingsVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var settingTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    public let db = Firestore.firestore()
    var sections: [(UIImage,String)] = [(#imageLiteral(resourceName: "profile"),"Profile"),(#imageLiteral(resourceName: "changePassword"),"Change Password"),(#imageLiteral(resourceName: "faceId"),"Face ID"),(#imageLiteral(resourceName: "appleHealth"),"Apple Health"),(#imageLiteral(resourceName: "system"),"System"),(#imageLiteral(resourceName: "about"),"About"),(#imageLiteral(resourceName: "deleteAccount"),"Delete Account"),(#imageLiteral(resourceName: "logout"),"Logout")]
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backView.round()
    }
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.pop()
    }
    
}

// MARK: - Extension For Functions
//===========================
extension SettingsVC {
    
    private func initialSetup() {
        if #available(iOS 13.0, *) {
        overrideUserInterfaceStyle = .light
        }
        self.setUpdata()
        self.tableViewSetup()
        self.getLoginType()
    }
    
    private func tableViewSetup(){
        self.settingTableView.delegate = self
        self.settingTableView.dataSource = self
        self.settingTableView.registerCell(with: SettingTableCell.self)
    }
    
    private func setUpdata(){
        if !UserModel.main.isChangePassword {
            self.sections = [(#imageLiteral(resourceName: "profile"),"Profile"),(#imageLiteral(resourceName: "faceId"),"Face ID"),(#imageLiteral(resourceName: "appleHealth"),"Apple Health"),(#imageLiteral(resourceName: "system"),"System"),(#imageLiteral(resourceName: "about"),"About"),(#imageLiteral(resourceName: "deleteAccount"),"Delete Account"),(#imageLiteral(resourceName: "logout"),"Logout")]
            
        }
    }
    
    private func performCleanUp(for_logout: Bool = true) {
        //        let userId = AppUserDefaults.value(forKey: .uid).stringValue
        //        db.collection(ApiKey.users)
        //            .document(userId).updateData([ApiKey.deviceToken : ""]) { (error) in
        //                if let err = error {
        //                    print(err.localizedDescription)
        //                    CommonFunctions.showToastWithMessage(err.localizedDescription)
        //                } else {
        let isTermsAndConditionSelected  = AppUserDefaults.value(forKey: .isTermsAndConditionSelected).boolValue
        AppUserDefaults.removeAllValues()
        UserModel.main = UserModel()
        if for_logout {
            AppUserDefaults.save(value: isTermsAndConditionSelected, forKey: .isTermsAndConditionSelected)
        }
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        DispatchQueue.main.async {
            AppRouter.goToSignUpVC()
        }
    }
    
    private func removeKeychain(){
        KeychainWrapper.standard.removeObject(forKey: ApiKey.password)
        KeychainWrapper.standard.removeObject(forKey: ApiKey.email)
        KeychainWrapper.standard.removeObject(forKey: ApiKey.googleIdToken)
        KeychainWrapper.standard.removeObject(forKey: ApiKey.googleAccessToken)
        KeychainWrapper.standard.removeObject(forKey: ApiKey.appleIdToken)
        KeychainWrapper.standard.removeObject(forKey: ApiKey.currrentNonce)
    }
    
    private func getLoginType(){
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "google.com":
                    loginType = .google
                    return
                case "apple.com":
                    loginType = .apple
                    return
                case "password":
                    loginType = .email_password
                    return
                default:
                    print("provider is \(userInfo.providerID)")
                }
            }
        }
    }
}

// MARK: - Extension For TableView
//===========================
extension SettingsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: SettingTableCell.self)
        cell.titleLbl.text = sections[indexPath.row].1
        cell.logoImgView.image = sections[indexPath.row].0
        switch sections[indexPath.row].1 {
        case "Face ID":
            cell.switchView.isUserInteractionEnabled = true
            cell.nextBtn.isHidden = true
            cell.switchView.isHidden = false
            cell.switchView.isOn = AppUserDefaults.value(forKey: .isBiometricSelected).boolValue
        case "Apple Health":
            cell.switchView.isUserInteractionEnabled = false
            cell.nextBtn.isHidden = true
            cell.switchView.isHidden = false
            cell.switchView.isOn = false
        default:
            cell.nextBtn.isHidden = false
            cell.switchView.isHidden = true
        }
        cell.switchTapped = { [weak self] sender in
            guard let self = self else { return }
            if self.sections[indexPath.row].1 ==  "Face ID" {
                let isOn = AppUserDefaults.value(forKey: .isBiometricSelected).boolValue
                self.db.collection(ApiKey.users).document(UserModel.main.id).updateData([ApiKey.isBiometricOn: !isOn])
                AppUserDefaults.save(value: !isOn, forKey: .isBiometricSelected)
                self.settingTableView.reloadData()
            }
            if self.sections[indexPath.row].1 ==  "Apple Health" {
                CommonFunctions.showToastWithMessage("Under Development")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.row].1 {
        case "Profile":
            let vc = ProfileVC.instantiate(fromAppStoryboard: .PostLogin)
            self.navigationController?.pushViewController(vc, animated: true)
        case "Change Password":
            let vc = ChangePasswordVC.instantiate(fromAppStoryboard: .PostLogin)
            self.navigationController?.pushViewController(vc, animated: true)
        case "System":
            let vc = SystemSetupVC.instantiate(fromAppStoryboard: .PostLogin)
            self.navigationController?.pushViewController(vc, animated: true)
        case "Delete Account":
            showAlertWithAction(title: "Delete Account", msg: "Are you sure want to delete account?", cancelTitle: "No", actionTitle: "Yes") {
                CommonFunctions.showActivityLoader()
                switch loginType{
                case .apple:
                    guard let idTokenString = KeychainWrapper.standard.string(forKey: ApiKey.appleIdToken), let nonce = KeychainWrapper.standard.string(forKey: ApiKey.currrentNonce) else {
                        CommonFunctions.hideActivityLoader()
                        return
                    }
                    let appleCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                                      idToken: idTokenString,
                                                                      rawNonce: nonce)
                    Auth.auth().currentUser?.reauthenticate(with: appleCredential, completion: { (result, error) in
                        if let error = error {
                            CommonFunctions.hideActivityLoader()
                            CommonFunctions.showToastWithMessage(error.localizedDescription)
                        }
                        else {
                            Auth.auth().currentUser?.delete { error in
                                if let error = error {
                                    CommonFunctions.hideActivityLoader()
                                    CommonFunctions.showToastWithMessage(error.localizedDescription)
                                } else {
                                    CommonFunctions.hideActivityLoader()
                                    self.removeKeychain()
                                    self.performCleanUp(for_logout: false)
                                }
                            }
                        }
                    })
                case .google:
                    guard let idTokenString = KeychainWrapper.standard.string(forKey: ApiKey.googleIdToken), let accessToken = KeychainWrapper.standard.string(forKey: ApiKey.googleAccessToken) else {
                        CommonFunctions.hideActivityLoader()
                        return
                    }
                    let googleCredential = GoogleAuthProvider.credential(withIDToken: idTokenString,
                                                                   accessToken: accessToken)
                    Auth.auth().currentUser?.reauthenticate(with: googleCredential, completion: { (result, error) in
                        if let error = error {
                            CommonFunctions.hideActivityLoader()
                            CommonFunctions.showToastWithMessage(error.localizedDescription)
                        }
                        else {
                            Auth.auth().currentUser?.delete { error in
                                if let error = error {
                                    CommonFunctions.hideActivityLoader()
                                    CommonFunctions.showToastWithMessage(error.localizedDescription)
                                } else {
                                    CommonFunctions.hideActivityLoader()
                                    self.removeKeychain()
                                    self.performCleanUp(for_logout: false)
                                    DispatchQueue.main.async {
                                        AppRouter.goToSignUpVC()
                                    }
                                }
                            }
                        }
                    })
                case .email_password:
                    let email = AppUserDefaults.value(forKey: .defaultEmail).stringValue
                    let password = AppUserDefaults.value(forKey: .defaultPassword).stringValue
                    let credential = EmailAuthProvider.credential(withEmail: email, password: password)
                    Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
                        if let error = error {
                            CommonFunctions.hideActivityLoader()
                            CommonFunctions.showToastWithMessage(error.localizedDescription)
                        }
                        else {
                            Auth.auth().currentUser?.delete { error in
                                if let error = error {
                                    CommonFunctions.hideActivityLoader()
                                    CommonFunctions.showToastWithMessage(error.localizedDescription)
                                } else {
                                    CommonFunctions.hideActivityLoader()
                                    self.removeKeychain()
                                    self.performCleanUp(for_logout: false)
                                    DispatchQueue.main.async {
                                        AppRouter.goToSignUpVC()
                                    }
                                }
                            }
                        }
                    })
                }
            } cancelcompletion: {}
        case "Logout":
            showAlertWithAction(title: "Logout", msg: "Are you sure want to logout?", cancelTitle: "No", actionTitle: "Yes") {
                FirestoreController.logOut { (isLogout) in
                    if !isLogout {
                        self.performCleanUp()
                        DispatchQueue.main.async {
                            AppRouter.goToLoginVC()
                        }
                    }
                }
            } cancelcompletion: {}
        case "About":
            let vc = AboutSectionVC.instantiate(fromAppStoryboard: .PostLogin)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            CommonFunctions.showToastWithMessage("Under Development")
        }
    }
}

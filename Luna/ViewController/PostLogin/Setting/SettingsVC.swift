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
    var sections: [(UIImage,String)] = [(#imageLiteral(resourceName: "profile"),LocalizedString.profile.localized),(#imageLiteral(resourceName: "changePassword"),LocalizedString.change_Password.localized),(#imageLiteral(resourceName: "faceId"),LocalizedString.face_ID.localized),(#imageLiteral(resourceName: "appleHealth"),LocalizedString.apple_Health.localized),(#imageLiteral(resourceName: "system"),LocalizedString.luna.localized),(#imageLiteral(resourceName: "about"),LocalizedString.about.localized),(#imageLiteral(resourceName: "deleteAccount"),LocalizedString.delete_Account.localized),(#imageLiteral(resourceName: "logout"),LocalizedString.logout.localized)]
    
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
            self.sections = [(#imageLiteral(resourceName: "profile"),LocalizedString.profile.localized),(#imageLiteral(resourceName: "faceId"),!hasTopNotch ? LocalizedString.touch_ID.localized : LocalizedString.face_ID.localized),(#imageLiteral(resourceName: "appleHealth"),LocalizedString.apple_Health.localized),(#imageLiteral(resourceName: "system"),LocalizedString.luna.localized),(#imageLiteral(resourceName: "about"),LocalizedString.about.localized),(#imageLiteral(resourceName: "deleteAccount"),LocalizedString.delete_Account.localized),(#imageLiteral(resourceName: "logout"),LocalizedString.logout.localized)]
        } else{
            self.sections = [(#imageLiteral(resourceName: "profile"),LocalizedString.profile.localized),(#imageLiteral(resourceName: "changePassword"),LocalizedString.change_Password.localized),(#imageLiteral(resourceName: "faceId"),!hasTopNotch ? LocalizedString.touch_ID.localized : LocalizedString.face_ID.localized),(#imageLiteral(resourceName: "appleHealth"),LocalizedString.apple_Health.localized),(#imageLiteral(resourceName: "system"),LocalizedString.luna.localized),(#imageLiteral(resourceName: "about"),LocalizedString.about.localized),(#imageLiteral(resourceName: "deleteAccount"),LocalizedString.delete_Account.localized),(#imageLiteral(resourceName: "logout"),LocalizedString.logout.localized)]
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
        case LocalizedString.face_ID.localized,LocalizedString.touch_ID.localized:
            cell.switchView.isUserInteractionEnabled = true
            cell.nextBtn.isHidden = true
            cell.switchView.isHidden = false
            cell.switchView.isOn = AppUserDefaults.value(forKey: .isBiometricSelected).boolValue
        case LocalizedString.apple_Health.localized:
            cell.switchView.isUserInteractionEnabled = false
            cell.nextBtn.isHidden = true
            cell.switchView.isHidden = false
            cell.switchView.isOn = HealthKitManager.sharedInstance.isEnabled
        default:
            cell.nextBtn.isHidden = false
            cell.switchView.isHidden = true
        }
        cell.switchTapped = { [weak self] sender in
            guard let self = self else { return }
            if self.sections[indexPath.row].1 ==  LocalizedString.face_ID.localized ||  self.sections[indexPath.row].1 ==  LocalizedString.touch_ID.localized {
                let isOn = AppUserDefaults.value(forKey: .isBiometricSelected).boolValue
                self.db.collection(ApiKey.users).document(UserModel.main.id).updateData([ApiKey.isBiometricOn: !isOn])
                AppUserDefaults.save(value: !isOn, forKey: .isBiometricSelected)
                self.settingTableView.reloadData()
            }
            if self.sections[indexPath.row].1 ==  LocalizedString.apple_Health.localized {
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
        case LocalizedString.profile.localized:
            let vc = ProfileVC.instantiate(fromAppStoryboard: .PostLogin)
            self.navigationController?.pushViewController(vc, animated: true)
        case LocalizedString.change_Password.localized:
            let vc = ChangePasswordVC.instantiate(fromAppStoryboard: .PostLogin)
            self.navigationController?.pushViewController(vc, animated: true)
        case LocalizedString.luna.localized:
            let vc = SystemSetupVC.instantiate(fromAppStoryboard: .PostLogin)
            self.navigationController?.pushViewController(vc, animated: true)
        case LocalizedString.delete_Account.localized:
            showAlertWithAction(title: LocalizedString.delete_Account.localized, msg: LocalizedString.are_you_sure_want_to_delete_account.localized, cancelTitle: LocalizedString.no.localized, actionTitle: LocalizedString.yes.localized) {
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
                                    FirestoreController.performCleanUp(for_logout: false)
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
                                    FirestoreController.performCleanUp(for_logout: false)
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
                                    FirestoreController.performCleanUp(for_logout: false)
                                }
                            }
                        }
                    })
                }
            } cancelcompletion: {}
        case LocalizedString.logout.localized:
            showAlertWithAction(title: LocalizedString.logout.localized, msg: LocalizedString.are_you_sure_want_to_logout.localized, cancelTitle: LocalizedString.no.localized, actionTitle: LocalizedString.yes.localized) {
                FirestoreController.performCleanUp(for_logout: true)
            } cancelcompletion: {}
        case LocalizedString.about.localized:
            let vc = AboutSectionVC.instantiate(fromAppStoryboard: .PostLogin)
            self.navigationController?.pushViewController(vc, animated: true)
        case LocalizedString.face_ID.localized,LocalizedString.touch_ID.localized:
            print("Do Nothing.")
        case LocalizedString.apple_Health.localized:
            print("Do Nothing.")
        default:
            CommonFunctions.showToastWithMessage("Under Development")
        }
    }
}

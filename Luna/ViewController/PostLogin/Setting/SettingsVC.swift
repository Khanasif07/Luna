//
//  SettingsVC.swift
//  Luna
//
//  Created by Admin on 22/06/21.
//


import UIKit
import SwiftKeychainWrapper
import FirebaseAuth
import FirebaseFirestore

class SettingsVC: UIViewController {
    
    //MARK:- Setting Section Enum
    enum SettingSection{
        case profile
        case change_Password
        case face_ID
        case touch_ID
        case apple_Health
        case luna_settings
        case app_settings
        case about
        case delete_Account
        case logout
        
        var titleValue: String{
            switch self {
            case .profile:
                return LocalizedString.myProfile.localized
            case .change_Password:
                return LocalizedString.change_Password.localized
            case .face_ID:
                return LocalizedString.face_ID.localized
            case .apple_Health:
                return LocalizedString.apple_Health.localized
            case .luna_settings:
                return LocalizedString.luna_settings.localized
            case .app_settings:
                return LocalizedString.app_settings.localized
            case .about:
                return LocalizedString.about.localized
            case .delete_Account:
                return LocalizedString.delete_Account.localized
            case .touch_ID:
                return LocalizedString.touch_ID.localized
            default:
                return LocalizedString.logout.localized
            }
        }
    }
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var settingTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    var sections: [(UIImage,SettingSection)] = [(#imageLiteral(resourceName: "profile"),.profile),(#imageLiteral(resourceName: "system"),.luna_settings),(#imageLiteral(resourceName: "appSettings"),.app_settings),(#imageLiteral(resourceName: "about"),.about)]
    
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
        FirestoreController.getSessionLoginType()
        HealthKitManager.sharedInstance.readInsulinFromAppleHealthKit { (insulinData) in
            print(insulinData)
        }
    }
    
    private func tableViewSetup(){
        self.settingTableView.delegate = self
        self.settingTableView.dataSource = self
        self.settingTableView.registerHeaderFooter(with: SettingHeaderView.self)
        self.settingTableView.registerCell(with: SettingTableCell.self)
    }
    
    private func setUpdata(){
        if !UserModel.main.isChangePassword {
            self.sections = [(#imageLiteral(resourceName: "profile"),.profile),(#imageLiteral(resourceName: "system"),.luna_settings),(#imageLiteral(resourceName: "appSettings"),.app_settings),(#imageLiteral(resourceName: "about"),.about)]
        } else{
            self.sections = [(#imageLiteral(resourceName: "profile"),.profile),(#imageLiteral(resourceName: "system"),.luna_settings),(#imageLiteral(resourceName: "appSettings"),.app_settings),(#imageLiteral(resourceName: "about"),.about)]
        }
    }
    
    func openUrl(urlString: String) {
       guard let url = URL(string: urlString) else {
           return
       }

       if UIApplication.shared.canOpenURL(url) {
           UIApplication.shared.open(url, options: [:])
       }
   }
}

// MARK: - Extension For TableView
//===========================
extension SettingsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: SettingTableCell.self)
        cell.titleLbl.text = sections[indexPath.section].1.titleValue
        cell.logoImgView.image = sections[indexPath.section].0
        switch sections[indexPath.section].1 {
        case .face_ID,.touch_ID:
            cell.switchView.isUserInteractionEnabled = true
            cell.nextBtn.isHidden = true
            cell.switchView.isHidden = false
            cell.switchView.isOn = AppUserDefaults.value(forKey: .isBiometricSelected).boolValue
        case .apple_Health:
            cell.nextBtn.isHidden = false
            cell.switchView.isOn = HealthKitManager.sharedInstance.isEnabled
            cell.switchView.isHidden = true
        default:
            cell.nextBtn.isHidden = false
            cell.switchView.isHidden = true
        }
        cell.switchTapped = { [weak self] sender in
            guard let self = self else { return }
            if self.sections[indexPath.section].1 ==  .face_ID ||  self.sections[indexPath.section].1 ==  .touch_ID {
                CommonFunctions.showActivityLoader()
                let isOn = AppUserDefaults.value(forKey: .isBiometricSelected).boolValue
                FirestoreController.updateUserBiometricStatus(isBiometricOn: !isOn) {
                    CommonFunctions.hideActivityLoader()
                    AppUserDefaults.save(value: !isOn, forKey: .isBiometricSelected)
                    self.settingTableView.reloadData()
                } failure: { (err) -> (Void) in
                    CommonFunctions.hideActivityLoader()
                    CommonFunctions.showToastWithMessage(err.localizedDescription)
                } failures: {
                    CommonFunctions.hideActivityLoader()
                    print("")
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueHeaderFooter(with: SettingHeaderView.self)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section].1 {
        case .profile:
            let vc = ProfileVC.instantiate(fromAppStoryboard: .PostLogin)
            self.navigationController?.pushViewController(vc, animated: true)
        case .change_Password:
            let vc = ChangePasswordVC.instantiate(fromAppStoryboard: .PostLogin)
            self.navigationController?.pushViewController(vc, animated: true)
        case .luna_settings:
            let vc = SystemSetupVC.instantiate(fromAppStoryboard: .PostLogin)
            vc.settingType = .Luna
            self.navigationController?.pushViewController(vc, animated: true)
        case .app_settings:
            let vc = SystemSetupVC.instantiate(fromAppStoryboard: .PostLogin)
            vc.settingType = .App
            self.navigationController?.pushViewController(vc, animated: true)
        case .delete_Account:
            self.showAlertWithAction(title: LocalizedString.delete_Account.localized, msg: LocalizedString.are_you_sure_want_to_delete_account.localized, cancelTitle: LocalizedString.no.localized, actionTitle: LocalizedString.yes.localized) {
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
                                    FirestoreController.removeKeychain()
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
                                    FirestoreController.removeKeychain()
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
                                    FirestoreController.removeKeychain()
                                    FirestoreController.performCleanUp(for_logout: false)
                                }
                            }
                        }
                    })
                }
            } cancelcompletion: {
                //MARK:- Handle Failure condition
            }
        case .logout:
            showAlertWithAction(title: LocalizedString.logout.localized, msg: LocalizedString.are_you_sure_want_to_logout.localized, cancelTitle: LocalizedString.no.localized, actionTitle: LocalizedString.yes.localized) {
                FirestoreController.performCleanUp(for_logout: true)
            } cancelcompletion: {
                //MARK:- Handle Failure condition
            }
        case .about:
            let vc = AboutSectionVC.instantiate(fromAppStoryboard: .PostLogin)
            self.navigationController?.pushViewController(vc, animated: true)
        case .face_ID,.touch_ID:
            print("Do Nothing.")
        case .apple_Health:
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
               UIApplication.shared.open(settingsUrl)
             }
        }
    }
}

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
    
    //MARK:- Setting Section Enum
    enum SettingSection{
        case profile
        case change_Password
        case face_ID
        case touch_ID
        case apple_Health
        case luna
        case about
        case delete_Account
        case logout
        
        var titleValue: String{
            switch self {
            case .profile:
                return LocalizedString.profile.localized
            case .change_Password:
                return LocalizedString.change_Password.localized
            case .face_ID:
                return LocalizedString.face_ID.localized
            case .apple_Health:
                return LocalizedString.apple_Health.localized
            case .luna:
                return LocalizedString.luna.localized
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
    public let db = Firestore.firestore()
    var sections: [(UIImage,SettingSection)] = [(#imageLiteral(resourceName: "profile"),.profile),(#imageLiteral(resourceName: "changePassword"),.change_Password),(#imageLiteral(resourceName: "faceId"),.face_ID),(#imageLiteral(resourceName: "appleHealth"),.apple_Health),(#imageLiteral(resourceName: "system"),.luna),(#imageLiteral(resourceName: "about"),.about),(#imageLiteral(resourceName: "deleteAccount"),.delete_Account),(#imageLiteral(resourceName: "logout"),.logout)]
    
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
        print(Date().convertToDefaultTimeString())
    }
    
    private func tableViewSetup(){
        self.settingTableView.delegate = self
        self.settingTableView.dataSource = self
        self.settingTableView.registerCell(with: SettingTableCell.self)
    }
    
    private func setUpdata(){
        if !UserModel.main.isChangePassword {
            self.sections = [(#imageLiteral(resourceName: "profile"),.profile),(#imageLiteral(resourceName: "faceId"),!hasTopNotch ? .touch_ID : .face_ID),(#imageLiteral(resourceName: "appleHealth"),.apple_Health),(#imageLiteral(resourceName: "system"),.luna),(#imageLiteral(resourceName: "about"),.about),(#imageLiteral(resourceName: "deleteAccount"),.delete_Account),(#imageLiteral(resourceName: "logout"),.logout)]
        } else{
            self.sections = [(#imageLiteral(resourceName: "profile"),.profile),(#imageLiteral(resourceName: "changePassword"),.change_Password),(#imageLiteral(resourceName: "faceId"),!hasTopNotch ? .touch_ID : .face_ID),(#imageLiteral(resourceName: "appleHealth"),.apple_Health),(#imageLiteral(resourceName: "system"),.luna),(#imageLiteral(resourceName: "about"),.about),(#imageLiteral(resourceName: "deleteAccount"),.delete_Account),(#imageLiteral(resourceName: "logout"),.logout)]
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
                case LoginType.google.title:
                    loginType = .google
                    return
                case LoginType.apple.title:
                    loginType = .apple
                    return
                case LoginType.email_password.title:
                    loginType = .email_password
                    return
                default:
                    print("provider is \(userInfo.providerID)")
                }
            }
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
        return sections.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: SettingTableCell.self)
        cell.titleLbl.text = sections[indexPath.row].1.titleValue
        cell.logoImgView.image = sections[indexPath.row].0
        switch sections[indexPath.row].1 {
        case .face_ID,.touch_ID:
            cell.switchView.isUserInteractionEnabled = true
            cell.nextBtn.isHidden = true
            cell.switchView.isHidden = false
            cell.switchView.isOn = AppUserDefaults.value(forKey: .isBiometricSelected).boolValue
        case .apple_Health:
//            cell.switchView.isUserInteractionEnabled = false
            cell.nextBtn.isHidden = false
//            cell.switchView.isHidden = false
            cell.switchView.isOn = HealthKitManager.sharedInstance.isEnabled
            cell.switchView.isHidden = true
        default:
            cell.nextBtn.isHidden = false
            cell.switchView.isHidden = true
        }
        cell.switchTapped = { [weak self] sender in
            guard let self = self else { return }
            if self.sections[indexPath.row].1 ==  .face_ID ||  self.sections[indexPath.row].1 ==  .touch_ID {
                let isOn = AppUserDefaults.value(forKey: .isBiometricSelected).boolValue
                self.db.collection(ApiKey.users).document(UserModel.main.id).updateData([ApiKey.isBiometricOn: !isOn])
                AppUserDefaults.save(value: !isOn, forKey: .isBiometricSelected)
                self.settingTableView.reloadData()
            }
            if self.sections[indexPath.row].1 ==  .apple_Health {
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
        case .profile:
            let vc = ProfileVC.instantiate(fromAppStoryboard: .PostLogin)
            self.navigationController?.pushViewController(vc, animated: true)
        case .change_Password:
            let vc = ChangePasswordVC.instantiate(fromAppStoryboard: .PostLogin)
            self.navigationController?.pushViewController(vc, animated: true)
        case .luna:
            let vc = SystemSetupVC.instantiate(fromAppStoryboard: .PostLogin)
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

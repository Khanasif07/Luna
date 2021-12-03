//
//  AboutSectionVC.swift
//  Luna
//
//  Created by Admin on 24/06/21.
//

import UIKit
import MessageUI
import SwiftKeychainWrapper
import FirebaseAuth
import FirebaseDatabase
import Firebase

class AboutSectionVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var aboutTableView: UITableView!
    @IBOutlet weak var backView: UIView!
    
    // MARK: - Variables
    //===========================
//    (#imageLiteral(resourceName: "customerSupport"),LocalizedString.customer_Support.localized),
    var sections: [(UIImage,String)] = [(#imageLiteral(resourceName: "appVersion"),LocalizedString.app_Version.localized),(#imageLiteral(resourceName: "termsConditions"),LocalizedString.terms_Conditions.localized),(#imageLiteral(resourceName: "privacy"),LocalizedString.privacy.localized),(#imageLiteral(resourceName: "deleteAccount"),LocalizedString.delete_Account.localized),(#imageLiteral(resourceName: "logout"),LocalizedString.logout.localized)]
    
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
extension AboutSectionVC {
    
    private func initialSetup() {
        if #available(iOS 13.0, *) {
        overrideUserInterfaceStyle = .light
        }
        self.tableViewSetup()
    }
    
    private func tableViewSetup(){
        self.aboutTableView.delegate = self
        self.aboutTableView.dataSource = self
        self.aboutTableView.registerCell(with: SettingTableCell.self)
    }
}

// MARK: - Extension For TableView
//===========================
extension AboutSectionVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: SettingTableCell.self)
        cell.titleLbl.text = sections[indexPath.row].1
        cell.logoImgView.image = sections[indexPath.row].0
        cell.nextBtn.isHidden = false
        cell.switchView.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.row].1 {
//        case LocalizedString.find_Answers.localized:
//            let vc = SettingManualVC.instantiate(fromAppStoryboard: .PostLogin)
//            self.navigationController?.pushViewController(vc, animated: true)
        case LocalizedString.customer_Support.localized:
            let vc = ContactUsVC.instantiate(fromAppStoryboard: .PostLogin)
            self.navigationController?.pushViewController(vc, animated: true)
        case LocalizedString.privacy.localized:
            let vc = AboutTermsPolicyVC.instantiate(fromAppStoryboard: .PostLogin)
            vc.titleString =  sections[indexPath.row].1
            vc.stringType = .privacyPolicy
            self.navigationController?.pushViewController(vc, animated: true)
        case LocalizedString.app_Version.localized:
            let vc = AboutTermsPolicyVC.instantiate(fromAppStoryboard: .PostLogin)
            vc.titleString =  sections[indexPath.row].1
            self.navigationController?.pushViewController(vc, animated: true)
        case LocalizedString.terms_Conditions.localized:
            let vc = AboutTermsPolicyVC.instantiate(fromAppStoryboard: .PostLogin)
            vc.titleString =  sections[indexPath.row].1
            vc.stringType = .tnc
            self.navigationController?.pushViewController(vc, animated: true)
        case LocalizedString.delete_Account.localized:
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
        case LocalizedString.logout.localized:
            showAlertWithAction(title: LocalizedString.logout.localized, msg: LocalizedString.are_you_sure_want_to_logout.localized, cancelTitle: LocalizedString.no.localized, actionTitle: LocalizedString.yes.localized) {
                FirestoreController.performCleanUp(for_logout: true)
            } cancelcompletion: {
                //MARK:- Handle Failure condition
            }
        default:
            CommonFunctions.showToastWithMessage("Under Development")
        }
    }
}

// MARK: - Extension For MFMailComposeViewControllerDelegate
//==========================================================
extension AboutSectionVC: MFMailComposeViewControllerDelegate{
    
    func openMail() {
        if MFMailComposeViewController.canSendMail() {
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            UINavigationBar.appearance().barTintColor = UIColor.white
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients(["support@lunadiabetes.com"])
            composeVC.setSubject("Luna iOS App Feedback")
            composeVC.setMessageBody("""
            ------------------------------
            Device Information
            ------------------------------
            iOS Version = \(DeviceDetail.os_version)
            Luna App Version = \(appVersion ?? "1.0")
            Phone = \(DeviceDetail.device_model)
            Thank you!
            """, isHTML: false)
            self.present(composeVC, animated: true, completion: nil)
        } else{
            showAlert(msg: "Mail not configured")            
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        UINavigationBar.appearance().barTintColor = UIColor.black
        controller.dismiss(animated: true)
    }
}

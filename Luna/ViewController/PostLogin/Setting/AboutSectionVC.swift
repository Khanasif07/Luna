//
//  AboutSectionVC.swift
//  Luna
//
//  Created by Admin on 24/06/21.
//

import UIKit
import SwiftKeychainWrapper

class AboutSectionVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var aboutTableView: UITableView!
    @IBOutlet weak var backView: UIView!
    
    // MARK: - Variables
    //===========================
    var sections: [(UIImage,String)] = [(#imageLiteral(resourceName: "appVersion"),LocalizedString.app_Version.localized),(#imageLiteral(resourceName: "termsConditions"),LocalizedString.terms_Conditions.localized),(#imageLiteral(resourceName: "privacy"),LocalizedString.privacy.localized),(#imageLiteral(resourceName: "deleteAccount"),LocalizedString.delete_Account.localized),(#imageLiteral(resourceName: "logout"),LocalizedString.logout.localized)]
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
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
        self.tableViewSetup()
    }
    
    private func tableViewSetup(){
        self.aboutTableView.delegate = self
        self.aboutTableView.dataSource = self
        self.aboutTableView.registerHeaderFooter(with: SettingHeaderView.self)
        self.aboutTableView.registerCell(with: SettingTableCell.self)
    }
}

// MARK: - Extension For TableView
//===========================
extension AboutSectionVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.endIndex
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueHeaderFooter(with: SettingHeaderView.self)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: SettingTableCell.self)
        cell.titleLbl.text = sections[indexPath.section].1
        cell.logoImgView.image = sections[indexPath.section].0
        cell.nextBtn.isHidden = false
        cell.switchView.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section].1 {
        case LocalizedString.customer_Support.localized:
            let vc = ContactUsVC.instantiate(fromAppStoryboard: .PostLogin)
            self.navigationController?.pushViewController(vc, animated: true)
        case LocalizedString.privacy.localized:
            let vc = AboutTermsPolicyVC.instantiate(fromAppStoryboard: .PostLogin)
            vc.titleString =  sections[indexPath.section].1
            vc.stringType = .privacyPolicy
            self.navigationController?.pushViewController(vc, animated: true)
        case LocalizedString.app_Version.localized:
            let vc = AboutTermsPolicyVC.instantiate(fromAppStoryboard: .PostLogin)
            vc.titleString =  sections[indexPath.section].1
            self.navigationController?.pushViewController(vc, animated: true)
        case LocalizedString.terms_Conditions.localized:
            let vc = AboutTermsPolicyVC.instantiate(fromAppStoryboard: .PostLogin)
            vc.titleString =  sections[indexPath.section].1
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
                    FirestoreController.deleteAppleSignedCreds(idToken: idTokenString, rawNonce: nonce) {
                        CommonFunctions.hideActivityLoader()
                        FirestoreController.removeKeychain()
                        FirestoreController.performCleanUp(for_logout: false)
                    } failure:{ (error) -> (Void) in
                        CommonFunctions.hideActivityLoader()
                        CommonFunctions.showToastWithMessage(error.localizedDescription)
                    }
                case .google:
                    guard let idTokenString = KeychainWrapper.standard.string(forKey: ApiKey.googleIdToken), let accessToken = KeychainWrapper.standard.string(forKey: ApiKey.googleAccessToken) else {
                        CommonFunctions.hideActivityLoader()
                        return
                    }
                    FirestoreController.deleteGoogleSignedCreds(idTokenString: idTokenString, accessToken: accessToken) {
                        CommonFunctions.hideActivityLoader()
                        FirestoreController.removeKeychain()
                        FirestoreController.performCleanUp(for_logout: false)
                    } failure:{ (error) -> (Void) in
                        CommonFunctions.hideActivityLoader()
                        CommonFunctions.showToastWithMessage(error.localizedDescription)
                    }
                case .email_password:
                    let email = AppUserDefaults.value(forKey: .defaultEmail).stringValue
                    let password = AppUserDefaults.value(forKey: .defaultPassword).stringValue
                    FirestoreController.deleteEmailPassSignedCreds(email: email, password: password){
                        CommonFunctions.hideActivityLoader()
                        FirestoreController.removeKeychain()
                        FirestoreController.performCleanUp(for_logout: false)
                    } failure: { (error) -> (Void) in
                        CommonFunctions.hideActivityLoader()
                        CommonFunctions.showToastWithMessage(error.localizedDescription)
                    }
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

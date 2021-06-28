//
//  SettingsVC.swift
//  Luna
//
//  Created by Admin on 22/06/21.
//


import UIKit
import SwiftKeychainWrapper
import FirebaseAuth

class SettingsVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var settingTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    var sections: [(UIImage,String)] = [(#imageLiteral(resourceName: "profile"),"Profile"),(#imageLiteral(resourceName: "changePassword"),"Change Password"),(#imageLiteral(resourceName: "faceId"),"Face ID"),(#imageLiteral(resourceName: "appleHealth"),"Apple Health"),(#imageLiteral(resourceName: "system"),"System"),(#imageLiteral(resourceName: "about"),"About"),(#imageLiteral(resourceName: "deleteAccount"),"Delete Account"),(#imageLiteral(resourceName: "logout"),"Logout")]
    
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
extension SettingsVC {
    
    private func initialSetup() {
        self.setUpdata()
        self.tableViewSetup()
    }
    
    private func tableViewSetup(){
        self.settingTableView.delegate = self
        self.settingTableView.dataSource = self
        self.settingTableView.registerCell(with: SettingTableCell.self)
    }
    
    private func setUpdata(){
        if !UserModel.main.canChangePassword {
            self.sections = [(#imageLiteral(resourceName: "profile"),"Profile"),(#imageLiteral(resourceName: "faceId"),"Face ID"),(#imageLiteral(resourceName: "appleHealth"),"Apple Health"),(#imageLiteral(resourceName: "system"),"System"),(#imageLiteral(resourceName: "about"),"About"),(#imageLiteral(resourceName: "deleteAccount"),"Delete Account"),(#imageLiteral(resourceName: "logout"),"Logout")]
            
        }
    }
    
    private func performCleanUp(for_logout: Bool = true) {
        let isTermsAndConditionSelected  = AppUserDefaults.value(forKey: .isTermsAndConditionSelected).boolValue
        let isBiometricSelected  = AppUserDefaults.value(forKey: .isBiometricSelected).boolValue
        let isBiometricCompleted  = AppUserDefaults.value(forKey: .isBiometricCompleted).boolValue
        AppUserDefaults.removeAllValues()
        UserModel.main = UserModel()
        if for_logout {
        AppUserDefaults.save(value: isBiometricSelected, forKey: .isBiometricSelected)
        AppUserDefaults.save(value: isBiometricCompleted, forKey: .isBiometricCompleted)
        AppUserDefaults.save(value: isTermsAndConditionSelected, forKey: .isTermsAndConditionSelected)
        }
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
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
            cell.nextBtn.isHidden = true
            cell.switchView.isHidden = false
            cell.switchView.isOn = AppUserDefaults.value(forKey: .isBiometricSelected).boolValue
        case "Apple Health":
            cell.nextBtn.isHidden = true
            cell.switchView.isHidden = false
            cell.switchView.isOn = true
        default:
            cell.nextBtn.isHidden = false
            cell.switchView.isHidden = true
        }
        cell.switchTapped = { [weak self] sender in
            guard let self = self else { return }
            if self.sections[indexPath.row].1 ==  "Face ID" {
                let isOn = AppUserDefaults.value(forKey: .isBiometricSelected).boolValue
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
                let email = AppUserDefaults.value(forKey: .defaultEmail).stringValue
                let password = AppUserDefaults.value(forKey: .defaultPassword).stringValue
                let credential = EmailAuthProvider.credential(withEmail: email, password: password)
                FirestoreController.currentUser?.reauthenticate(with: credential, completion: { (result, error) in
                    if let error = error {
                        CommonFunctions.showToastWithMessage(error.localizedDescription)
                    }
                    else {
                        FirestoreController.currentUser?.delete { error in
                            if let error = error {
                                CommonFunctions.showToastWithMessage(error.localizedDescription)
                            } else {
                                KeychainWrapper.standard.removeObject(forKey: ApiKey.password)
                                KeychainWrapper.standard.removeObject(forKey: ApiKey.email)
                                self.performCleanUp(for_logout: false)
                                AppRouter.goToSignUpVC()
                            }
                        }
                    }
                })
            } cancelcompletion: {}
        case "Logout":
            showAlertWithAction(title: "Logout", msg: "Are you sure want to logout?", cancelTitle: "No", actionTitle: "Yes") {
                FirestoreController.logOut { (isLogout) in
                    self.performCleanUp()
                    AppRouter.goToLoginVC()
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

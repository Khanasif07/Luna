//
//  SettingsVC.swift
//  Luna
//
//  Created by Admin on 22/06/21.
//


import UIKit

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
        self.tableViewSetup()
    }
    
    private func tableViewSetup(){
        self.settingTableView.delegate = self
        self.settingTableView.dataSource = self
        self.settingTableView.registerCell(with: SettingTableCell.self)
    }
    
    private func performCleanUp() {
        let isTermsAndConditionSelected  = AppUserDefaults.value(forKey: .isTermsAndConditionSelected).boolValue
        AppUserDefaults.removeAllValues()
        AppUserDefaults.save(value: isTermsAndConditionSelected, forKey: .isTermsAndConditionSelected)
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
        switch indexPath.row {
        case 2:
            cell.nextBtn.isHidden = true
            cell.switchView.isHidden = false
            cell.switchView.isOn = AppUserDefaults.value(forKey: .isBiometricSelected).boolValue
        case 3:
            cell.nextBtn.isHidden = true
            cell.switchView.isHidden = false
            cell.switchView.isOn = true
        default:
            cell.nextBtn.isHidden = false
            cell.switchView.isHidden = true
        }
        cell.switchTapped = { [weak self] sender in
            guard let self = self else { return }
            if indexPath.row == 2 {
                let isOn = AppUserDefaults.value(forKey: .isBiometricSelected).boolValue
                AppUserDefaults.save(value: !isOn, forKey: .isBiometricSelected)
                self.settingTableView.reloadData()
            }
            if indexPath.row == 3 {
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
        case sections[0].1:
            let vc = ProfileVC.instantiate(fromAppStoryboard: .PostLogin)
            self.navigationController?.pushViewController(vc, animated: true)
        case sections[1].1:
            let vc = ChangePasswordVC.instantiate(fromAppStoryboard: .PostLogin)
            self.navigationController?.pushViewController(vc, animated: true)
        case sections[6].1:
            FirestoreController.currentUser?.delete { error in
              if let error = error {
                CommonFunctions.showToastWithMessage(error.localizedDescription)
              } else {
                self.performCleanUp()
                AppRouter.goToSignUpVC()
              }
            }
        case sections[7].1:
            FirestoreController.logOut { (isLogout) in
                self.performCleanUp()
                AppRouter.goToSignUpVC()
            }
        case sections[5].1:
            let vc = AboutSectionVC.instantiate(fromAppStoryboard: .PostLogin)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            CommonFunctions.showToastWithMessage("Under Development")
        }
    }
}

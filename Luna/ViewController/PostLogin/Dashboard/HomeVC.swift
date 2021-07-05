//
//  HomeVC.swift
//  Luna
//
//  Created by Admin on 24/06/21.
//

import UIKit

class HomeVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    
    // MARK: - Variables
    //===========================
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .lightContent
        }
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func settingBtnTapped(_ sender: UIButton) {
        self.gotoSettingVC()
    }
    
    @IBAction func historyBtnTapped(_ sender: UIButton) {
        showAlert(msg: "Under Development")
    }
    
    @IBAction func manualBtnTapped(_ sender: UIButton) {
        showAlert(msg: "Under Development")
    }
    
    @IBAction func infoBtnTapped(_ sender: Any) {
        showAlert(msg: "Under Development")
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension HomeVC {
    
    private func initialSetup() {
        FirestoreController.getFirebaseUserData {
            AppUserDefaults.save(value: UserModel.main.isBiometricOn, forKey: .isBiometricSelected)
        } failure: { (error) -> (Void) in
            CommonFunctions.showToastWithMessage(error.localizedDescription)
        }
        switch traitCollection.userInterfaceStyle {
        case .dark:
            print("dark")
        default:
            print("light")
        }
    }
    
     func gotoSettingVC(){
        let vc = SettingsVC.instantiate(fromAppStoryboard: .PostLogin)
        navigationController?.pushViewController(vc, animated: true)
    }
}

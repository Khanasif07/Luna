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
            if userInterfaceStyle == .dark{
                return .darkContent
            }else{
                return .darkContent
            }
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
        if #available(iOS 13.0, *) {
        overrideUserInterfaceStyle = .light
        }
        FirestoreController.getFirebaseUserData {
            AppUserDefaults.save(value: UserModel.main.isBiometricOn, forKey: .isBiometricSelected)
        } failure: { (error) -> (Void) in
            CommonFunctions.showToastWithMessage(error.localizedDescription)
        }
    }
    
     func gotoSettingVC(){
        let vc = SettingsVC.instantiate(fromAppStoryboard: .PostLogin)
        navigationController?.pushViewController(vc, animated: true)
    }
}

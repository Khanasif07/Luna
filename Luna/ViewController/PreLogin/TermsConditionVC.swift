//
//  TermsConditionVC.swift
//  Luna
//
//  Created by Admin on 16/06/21.
//

import UIKit

class TermsConditionVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var textScrollView: UIScrollView!
    @IBOutlet weak var titleLbl: UILabel!
    
    // MARK: - Variables
    //===========================
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func acceptBtnAction(_ sender: UIButton) {
        AppUserDefaults.save(value: true, forKey: .isTermsAndConditionSelected)
        self.goToLoginVC()
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension TermsConditionVC {
    
    private func initialSetup() {
        
    }
    
    func goToSignUpVC() {
        let signupVC = SignupViewController.instantiate(fromAppStoryboard: .PreLogin)
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
     func goToLoginVC(){
        let vc = LoginViewController.instantiate(fromAppStoryboard: .PreLogin)
        self.navigationController?.pushViewController(vc, animated: true)
    }
  
      
}

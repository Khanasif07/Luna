//
//  CGMLoginVC.swift
//  Luna
//
//  Created by Admin on 07/07/21.
//

import UIKit

class CGMLoginVC: UIViewController {
    
    @IBOutlet weak var IntroLbl: UILabel!
    @IBOutlet weak var EmailLbl: UILabel!
    @IBOutlet weak var PasswordLbl: UILabel!
    
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    
    @IBOutlet weak var ForgetPassBtn: UIButton!
    
    @IBOutlet weak var proceedBtn: AppButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func proceedBtnAction(_ sender: UIButton) {
        self.proceedBtn.isEnabled = true
        let scene =  CGMDATASHAREVC.instantiate(fromAppStoryboard: .CGPStoryboard)
        self.present(scene, animated: true, completion: nil)
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.pop()
    }
    

}



// MARK: - Extension For Functions
//===========================
extension CGMLoginVC {
    
    private func initialSetup() {
       // btmContainerView.setBorder(width: 1.0, color: #colorLiteral(red: 0.9607843137, green: 0.5450980392, blue: 0.262745098, alpha: 1))
      
        
        EmailLbl.text = "Email"
        EmailLbl.textColor = AppColors.fontPrimaryColor
        EmailLbl.font = AppFonts.SF_Pro_Display_Semibold.withSize(.x14)
        
        PasswordLbl.text = "Password"
        PasswordLbl.textColor = AppColors.fontPrimaryColor
        PasswordLbl.font = AppFonts.SF_Pro_Display_Semibold.withSize(.x14)
        
        
        EmailTF.layer.borderWidth = 1
        EmailTF.layer.cornerRadius = 10
        EmailTF.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        EmailTF.layer.borderColor = AppColors.appGreenColor.cgColor

        
        
        PasswordTF.layer.borderWidth = 1
        PasswordTF.layer.cornerRadius = 10
        PasswordTF.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        PasswordTF.layer.borderColor = AppColors.fontPrimaryColor.cgColor
        
        ForgetPassBtn.setTitleColor(AppColors.appGreenColor, for: .normal)
        
        
        self.proceedBtn.layer.cornerRadius = 10
        self.proceedBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
  
}

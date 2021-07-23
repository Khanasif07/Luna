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
    @IBOutlet weak var EmailTF: AppTextField!
    @IBOutlet weak var PasswordTF: AppTextField!
    @IBOutlet weak var ForgetPassBtn: UIButton!
    @IBOutlet weak var proceedBtn: AppButton!
    
    var emailTxt = ""
    var passTxt = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
    
    private func signUpBtnStatus()-> Bool{
        return !self.emailTxt.isEmpty && !self.passTxt.isEmpty
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func proceedBtnAction(_ sender: UIButton) {
        let scene =  CGMDATASHAREVC.instantiate(fromAppStoryboard: .CGPStoryboard)
        scene.CGMConnectNavigation = { [weak self] (sender) in
            guard let selff = self else { return }
            let scene =  CGMConnectedVC.instantiate(fromAppStoryboard: .CGPStoryboard)
            scene.cgmConnectedSuccess = { [weak self] (sender) in
                guard let selff = self else { return }
                if   SystemInfoModel.shared.isFromSetting {
                    CommonFunctions.showActivityLoader()
                    FirestoreController.updateSystemInfoData(userId: AppUserDefaults.value(forKey: .uid).stringValue, longInsulinType: SystemInfoModel.shared.longInsulinType, longInsulinSubType: SystemInfoModel.shared.longInsulinSubType, insulinUnit: SystemInfoModel.shared.insulinUnit, cgmType: SystemInfoModel.shared.cgmType, cgmUnit: SystemInfoModel.shared.cgmUnit) {
                        FirestoreController.getUserSystemInfoData{
                            CommonFunctions.hideActivityLoader()
                            NotificationCenter.default.post(name: Notification.Name.cgmConnectedSuccessfully, object: nil)
                            selff.navigationController?.popToViewControllerOfType(classForCoder: SystemSetupVC.self)
                            CommonFunctions.showToastWithMessage("CGM info updated successfully.")
                        } failure: { (error) -> (Void) in
                            CommonFunctions.hideActivityLoader()
                            CommonFunctions.showToastWithMessage(error.localizedDescription)
                        }
                    } failure: { (error) -> (Void) in
                        CommonFunctions.hideActivityLoader()
                        CommonFunctions.showToastWithMessage(error.localizedDescription)
                    }
                }else {
                    NotificationCenter.default.post(name: Notification.Name.cgmConnectedSuccessfully, object: nil)
                    selff.navigationController?.popToViewControllerOfType(classForCoder: SystemSetupStep1VC.self)
                }
            }
            selff.present(scene, animated: true, completion: nil)
        }
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
        proceedBtn.isEnabled = false
        EmailTF.delegate = self
        PasswordTF.delegate = self
        EmailLbl.text = "Email"
        EmailLbl.textColor = AppColors.fontPrimaryColor
        EmailLbl.font = AppFonts.SF_Pro_Display_Semibold.withSize(.x14)
        
        PasswordLbl.text = "Password"
        PasswordLbl.textColor = AppColors.fontPrimaryColor
        PasswordLbl.font = AppFonts.SF_Pro_Display_Semibold.withSize(.x14)
        
        
        EmailTF.layer.borderWidth = 1
        EmailTF.layer.cornerRadius = 10
        EmailTF.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        EmailTF.layer.borderColor = AppColors.fontPrimaryColor.cgColor

        
        
        PasswordTF.layer.borderWidth = 1
        PasswordTF.layer.cornerRadius = 10
        PasswordTF.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        PasswordTF.layer.borderColor = AppColors.fontPrimaryColor.cgColor
        
        ForgetPassBtn.setTitleColor(AppColors.appGreenColor, for: .normal)
        
        
        self.proceedBtn.layer.cornerRadius = 10
        self.proceedBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
  
}

// MARK: - Extension For TxtField
//===========================
extension CGMLoginVC : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case EmailTF:
            EmailTF.setBorder(width: 1.0, color: AppColors.appGreenColor)
        case PasswordTF:
            PasswordTF.setBorder(width: 1.0, color: AppColors.appGreenColor)
        default:
            print("")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let txt = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        switch textField {
        case EmailTF:
            self.emailTxt = txt
            proceedBtn.isEnabled = signUpBtnStatus()
            EmailTF.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
            if !self.isEmailValid(string: self.emailTxt).0{
                EmailTF.setError(self.isEmailValid(string: self.emailTxt).1)
            }else{
                EmailTF.setError("",show: false)
            }
        case PasswordTF:
            self.passTxt = txt
            proceedBtn.isEnabled = signUpBtnStatus()
            PasswordTF.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
            if !self.isPassValid(string: self.passTxt).0{
                PasswordTF.setError(self.isPassValid(string: self.passTxt).1)
            }else{
                PasswordTF.setError("",show: false)
            }
        default:
            proceedBtn.isEnabled = signUpBtnStatus()
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        switch textField {
        case EmailTF:
            return (string.checkIfValidCharaters(.email) || string.isEmpty) && newString.length <= 50
        case PasswordTF:
            return (string.checkIfValidCharaters(.password) || string.isEmpty) && newString.length <= 25
        default:
            return false
        }
    }
}

//
//  CGMLoginVC.swift
//  Luna
//
//  Created by Admin on 07/07/21.
//

import UIKit

class CGMLoginVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var introLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var emailTF: AppTextField!
    @IBOutlet weak var passwordTF: AppTextField!
    @IBOutlet weak var forgetPassBtn: UIButton!
    @IBOutlet weak var proceedBtn: AppButton!
    
    // MARK: - Variables
    //===========================
    var emailTxt: String = ""
    var passTxt : String = ""
    
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
        AppUserDefaults.save(value: emailTxt, forKey: .shareUserName)
        AppUserDefaults.save(value: passTxt, forKey: .sharePassword)
        let scene =  CGMConnectedVC.instantiate(fromAppStoryboard: .CGPStoryboard)
        scene.cgmConnectedSuccess = { [weak self] (sender,cgmData) in
            guard let self = self else { return }
            if   SystemInfoModel.shared.isFromSetting {
                CommonFunctions.showActivityLoader()
                FirestoreController.checkUserExistInSystemDatabase {
                        FirestoreController.getUserSystemInfoData{
                            CommonFunctions.hideActivityLoader()
                            self.navigationController?.popToViewControllerOfType(classForCoder: SystemSetupVC.self)
                            CommonFunctions.showToastWithMessage("CGM info updated successfully.")
                        } failure: { (error) -> (Void) in
                            CommonFunctions.hideActivityLoader()
                            CommonFunctions.showToastWithMessage(error.localizedDescription)
                        }
                } failure: {
                        CommonFunctions.hideActivityLoader()
                        NotificationCenter.default.post(name: Notification.Name.cgmConnectedSuccessfully, object: [ApiKey.cgmData: cgmData])
                        self.navigationController?.popToViewControllerOfType(classForCoder: SystemSetupVC.self)
                        CommonFunctions.showToastWithMessage("CGM info updated successfully.")
                        AppUserDefaults.save(value: true, forKey: .isSystemSetupCompleted)
                }
            }else {
                NotificationCenter.default.post(name: Notification.Name.cgmConnectedSuccessfully, object: nil)
                self.navigationController?.popToViewControllerOfType(classForCoder: SystemSetupStep1VC.self)
            }
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
        self.setUpTextFont()
    }
    
    @objc func secureTextField(_ sender: UIButton){
        sender.isSelected.toggle()
        self.passwordTF.isSecureTextEntry = !sender.isSelected
    }
    
    private func setUpTextFont(){
        proceedBtn.isEnabled = false
        emailTF.delegate = self
        passwordTF.delegate = self
        passwordTF.isSecureText = true
        emailLbl.text = "User Name"
        emailLbl.textColor = AppColors.fontPrimaryColor
        emailLbl.font = AppFonts.SF_Pro_Display_Semibold.withSize(.x14)
        passwordLbl.text = "Password"
        passwordLbl.textColor = AppColors.fontPrimaryColor
        passwordLbl.font = AppFonts.SF_Pro_Display_Semibold.withSize(.x14)
        emailTF.layer.borderWidth = 1
        emailTF.round(radius: 10.0)
        emailTF.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        emailTF.layer.borderColor = AppColors.fontPrimaryColor.cgColor
        passwordTF.layer.borderWidth = 1
        passwordTF.round(radius: 10.0)
        passwordTF.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        passwordTF.layer.borderColor = AppColors.fontPrimaryColor.cgColor
        let show = UIButton()
        show.isSelected = false
        show.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        show.addTarget(self, action: #selector(secureTextField(_:)), for: .touchUpInside)
        self.passwordTF.setButtonToRightView(btn: show, selectedImage: #imageLiteral(resourceName: "eyeClosedIcon"), normalImage: #imageLiteral(resourceName: "eyeOpenIcon"), size: CGSize(width: 22, height: 22))
        forgetPassBtn.setTitleColor(AppColors.appGreenColor, for: .normal)
        forgetPassBtn.isHidden = true
        self.proceedBtn.round(radius: 10.0)
        self.proceedBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
    
}

// MARK: - Extension For TxtField
//===========================
extension CGMLoginVC : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case emailTF:
            emailTF.setBorder(width: 1.0, color: AppColors.appGreenColor)
        case passwordTF:
            passwordTF.setBorder(width: 1.0, color: AppColors.appGreenColor)
        default:
            print("")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let txt = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        switch textField {
        case emailTF:
            self.emailTxt = txt
            proceedBtn.isEnabled = signUpBtnStatus()
            emailTF.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
        case passwordTF:
            self.passTxt = txt
            proceedBtn.isEnabled = signUpBtnStatus()
            passwordTF.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
        default:
            proceedBtn.isEnabled = signUpBtnStatus()
        }
        
    }
}

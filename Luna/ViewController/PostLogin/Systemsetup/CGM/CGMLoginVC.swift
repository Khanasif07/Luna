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
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
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
    
    private func signUpBtnStatus()-> Bool{
        return !self.emailTxt.isEmpty && !self.passTxt.isEmpty
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func proceedBtnAction(_ sender: UIButton) {
        //        let scene =  CGMDATASHAREVC.instantiate(fromAppStoryboard: .CGPStoryboard)
        //        scene.CGMConnectNavigation = { [weak self] (sender) in
        //
        //        }
        //        self.present(scene, animated: true, completion: nil)
        let scene =  CGMConnectedVC.instantiate(fromAppStoryboard: .CGPStoryboard)
        scene.cgmConnectedSuccess = { [weak self] (sender,cgmData) in
            guard let selff = self else { return }
            UserDefaultsRepository.shareUserName.value =  selff.emailTxt
            UserDefaultsRepository.sharePassword.value = selff.passTxt
            if   SystemInfoModel.shared.isFromSetting {
                CommonFunctions.showActivityLoader()
                FirestoreController.checkUserExistInSystemDatabase {
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
                } failure: {
                    FirestoreController.setSystemInfoData(userId: AppUserDefaults.value(forKey: .uid).stringValue, longInsulinType: SystemInfoModel.shared.longInsulinType, longInsulinSubType: SystemInfoModel.shared.longInsulinSubType, insulinUnit: SystemInfoModel.shared.insulinUnit, cgmType: SystemInfoModel.shared.cgmType, cgmUnit: SystemInfoModel.shared.cgmUnit) {
                        CommonFunctions.hideActivityLoader()
                        NotificationCenter.default.post(name: Notification.Name.cgmConnectedSuccessfully, object: nil)
                        selff.navigationController?.popToViewControllerOfType(classForCoder: SystemSetupVC.self)
                        CommonFunctions.showToastWithMessage("CGM info updated successfully.")
                        AppUserDefaults.save(value: true, forKey: .isSystemSetupCompleted)
                    } failure: { (error) -> (Void) in
                        CommonFunctions.hideActivityLoader()
                        CommonFunctions.showToastWithMessage(error.localizedDescription)
                    }
                }
            }else {
                NotificationCenter.default.post(name: Notification.Name.cgmConnectedSuccessfully, object: nil)
                selff.navigationController?.popToViewControllerOfType(classForCoder: SystemSetupStep1VC.self)
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
        self.PasswordTF.isSecureTextEntry = !sender.isSelected
    }
    
    private func setUpTextFont(){
        proceedBtn.isEnabled = false
        EmailTF.delegate = self
        PasswordTF.delegate = self
        PasswordTF.isSecureText = true
        EmailLbl.text = "User Name"
        EmailLbl.textColor = AppColors.fontPrimaryColor
        EmailLbl.font = AppFonts.SF_Pro_Display_Semibold.withSize(.x14)
        PasswordLbl.text = "Password"
        PasswordLbl.textColor = AppColors.fontPrimaryColor
        PasswordLbl.font = AppFonts.SF_Pro_Display_Semibold.withSize(.x14)
        EmailTF.layer.borderWidth = 1
        EmailTF.round(radius: 10.0)
        EmailTF.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        EmailTF.layer.borderColor = AppColors.fontPrimaryColor.cgColor
        PasswordTF.layer.borderWidth = 1
        PasswordTF.round(radius: 10.0)
        PasswordTF.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        PasswordTF.layer.borderColor = AppColors.fontPrimaryColor.cgColor
        let show = UIButton()
        show.isSelected = false
        show.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        show.addTarget(self, action: #selector(secureTextField(_:)), for: .touchUpInside)
        self.PasswordTF.setButtonToRightView(btn: show, selectedImage: #imageLiteral(resourceName: "eyeClosedIcon"), normalImage: #imageLiteral(resourceName: "eyeOpenIcon"), size: CGSize(width: 22, height: 22))
        ForgetPassBtn.setTitleColor(AppColors.appGreenColor, for: .normal)
        ForgetPassBtn.isHidden = true
        self.proceedBtn.round(radius: 10.0)
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
            UserDefaultsRepository.shareUserName.value = emailTxt
            proceedBtn.isEnabled = signUpBtnStatus()
            EmailTF.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
        case PasswordTF:
            self.passTxt = txt
            UserDefaultsRepository.sharePassword.value = passTxt
            UserDefaultsRepository.shareServer.value = "US"
            proceedBtn.isEnabled = signUpBtnStatus()
            PasswordTF.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
        default:
            proceedBtn.isEnabled = signUpBtnStatus()
        }
        
    }
}

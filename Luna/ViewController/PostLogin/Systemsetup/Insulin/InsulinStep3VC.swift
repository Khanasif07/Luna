//
//  InsulinStep3VC.swift
//  Luna
//
//  Created by Admin on 07/07/21.
//

import UIKit
import IQKeyboardManagerSwift

class InsulinStep3VC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var insulinImgView: UIImageView!
    @IBOutlet weak var insulinDescLbl: UILabel!
    @IBOutlet weak var doneBtn: AppButton!
    @IBOutlet weak var insulinSubType: UILabel!
    @IBOutlet weak var insulinType: UILabel!
    @IBOutlet weak var insulinCountTxtField: AppTextField!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var doneBtnBtmCost: NSLayoutConstraint!
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        insulinCountTxtField?.round(radius: 8.0)
        doneBtn.round(radius: 8.0)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func doneBtnAction(_ sender: AppButton) {
        self.view.endEditing(true)
        SystemInfoModel.shared.insulinUnit =  Int(self.insulinCountTxtField.text ?? "0") ?? 0
        let vc = InsulinStep4VC.instantiate(fromAppStoryboard: .SystemSetup)
        vc.insulinConnectedSuccess = { [weak self] (sender) in
            guard let self = self else { return }
            self.view.endEditing(true)
            if   SystemInfoModel.shared.isFromSetting {
                CommonFunctions.showActivityLoader()
                FirestoreController.checkUserExistInSystemDatabase {
                    FirestoreController.updateSystemInfoData(userId: AppUserDefaults.value(forKey: .uid).stringValue, longInsulinType: SystemInfoModel.shared.longInsulinType, longInsulinSubType: SystemInfoModel.shared.longInsulinSubType, insulinUnit: SystemInfoModel.shared.insulinUnit, cgmType: SystemInfoModel.shared.cgmType, cgmUnit: SystemInfoModel.shared.cgmUnit) {
                        FirestoreController.getUserSystemInfoData{
                            CommonFunctions.hideActivityLoader()
                            NotificationCenter.default.post(name: Notification.Name.insulinConnectedSuccessfully, object: nil)
                            self.navigationController?.popToViewControllerOfType(classForCoder: SystemSetupVC.self)
                            CommonFunctions.showToastWithMessage("Insulin info updated successfully.")
                        } failure: { (error) -> (Void) in
                            CommonFunctions.hideActivityLoader()
                            CommonFunctions.showToastWithMessage(error.localizedDescription)
                        }
                    } failure: { (error) -> (Void) in
                        CommonFunctions.hideActivityLoader()
                        CommonFunctions.showToastWithMessage(error.localizedDescription)
                    }
                } failure: {
                    FirestoreController.setSystemInfoData(userId: AppUserDefaults.value(forKey: .uid).stringValue, longInsulinType: SystemInfoModel.shared.longInsulinType, longInsulinSubType: SystemInfoModel.shared.longInsulinSubType, insulinUnit: SystemInfoModel.shared.insulinUnit, cgmType: SystemInfoModel.shared.cgmType) {
                        CommonFunctions.hideActivityLoader()
                        NotificationCenter.default.post(name: Notification.Name.insulinConnectedSuccessfully, object: nil)
                        self.navigationController?.popToViewControllerOfType(classForCoder: SystemSetupVC.self)
                        CommonFunctions.showToastWithMessage("Insulin info updated successfully.")
                        AppUserDefaults.save(value: true, forKey: .isSystemSetupCompleted)
                    } failure: { (error) -> (Void) in
                        CommonFunctions.hideActivityLoader()
                        CommonFunctions.showToastWithMessage(error.localizedDescription)
                    }
                }
            }else{
                NotificationCenter.default.post(name: Notification.Name.insulinConnectedSuccessfully, object: nil)
                self.navigationController?.popToViewControllerOfType(classForCoder: SystemSetupStep1VC.self)
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func bckBtnTapped(_ sender: UIButton) {
        self.pop()
    }
}

// MARK: - Extension For Functions
//===========================
extension InsulinStep3VC {
    
    private func initialSetup() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        registerNotification()
        insulinCountTxtField.delegate = self
        insulinCountTxtField.keyboardType = .numberPad
        insulinCountTxtField.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
        insulinCountTxtField.text = "\(SystemInfoModel.shared.insulinUnit)"
        insulinType.text = "\(SystemInfoModel.shared.longInsulinType)"
        insulinSubType.text = "\(SystemInfoModel.shared.longInsulinSubType)"
        insulinImgView.image = SystemInfoModel.shared.longInsulinImage
        insulinDescLbl.text = "How many units of \(SystemInfoModel.shared.longInsulinType) do you normally take daily?"
      //  This should be what your doctor has prescribed for you to take regularly.
        self.doneBtn.isEnabled = !(insulinCountTxtField.text?.isEmpty ?? true)
    }
    
    private func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIApplication.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        guard let info = sender.userInfo, let keyboardHeight = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height, let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }
        self.doneBtnBtmCost.constant = keyboardHeight
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        guard let info = sender.userInfo, let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }
        self.doneBtnBtmCost.constant = 30.0
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
}

// MARK: - Extension For TextField Delegate
//====================================
extension InsulinStep3VC : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        insulinCountTxtField.setBorder(width: 1.0, color: AppColors.appGreenColor)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        insulinCountTxtField.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
        self.doneBtn.isEnabled = !(textField.text?.isEmpty ?? true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        self.insulinCountTxtField.setBorder(width: 1.0, color: AppColors.appGreenColor)
        self.doneBtn.isEnabled = !(newString.isEqual(to: ""))
        if textField.text?.count == 0 && string == "0" {
            return false
        }
        return (string.checkIfValidCharaters(.mobileNumber) || string.isEmpty) && newString.length <= 2
    }
}

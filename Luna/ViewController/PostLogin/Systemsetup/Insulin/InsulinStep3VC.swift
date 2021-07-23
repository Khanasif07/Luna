//
//  InsulinStep3VC.swift
//  Luna
//
//  Created by Admin on 07/07/21.
//

import UIKit

class InsulinStep3VC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var insulinDescLbl: UILabel!
    @IBOutlet weak var doneBtn: AppButton!
    @IBOutlet weak var insulinSubType: UILabel!
    @IBOutlet weak var insulinType: UILabel!
    @IBOutlet weak var insulinCountTxtField: AppTextField!
    @IBOutlet weak var backBtn: UIButton!
    
    // MARK: - Variables
    //===========================
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        insulinCountTxtField?.layer.cornerRadius = 8.0
        doneBtn.round(radius: 8.0)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func doneBtnAction(_ sender: AppButton) {
        SystemInfoModel.shared.insulinUnit =  Int(self.insulinCountTxtField.text ?? "0") ?? 0
        let vc = InsulinStep4VC.instantiate(fromAppStoryboard: .SystemSetup)
        vc.insulinConnectedSuccess = { [weak self] (sender) in
            guard let selff = self else { return }
            if   SystemInfoModel.shared.isFromSetting {
                CommonFunctions.showActivityLoader()
                FirestoreController.updateSystemInfoData(userId: AppUserDefaults.value(forKey: .uid).stringValue, longInsulinType: SystemInfoModel.shared.longInsulinType, longInsulinSubType: SystemInfoModel.shared.longInsulinSubType, insulinUnit: SystemInfoModel.shared.insulinUnit, cgmType: SystemInfoModel.shared.cgmType, cgmUnit: SystemInfoModel.shared.cgmUnit) {
                    FirestoreController.getUserSystemInfoData{
                        CommonFunctions.hideActivityLoader()
                        NotificationCenter.default.post(name: Notification.Name.insulinConnectedSuccessfully, object: nil)
                        selff.navigationController?.popToViewControllerOfType(classForCoder: SystemSetupVC.self)
                        CommonFunctions.showToastWithMessage("Insulin info updated successfully.")
                    } failure: { (error) -> (Void) in
                        CommonFunctions.hideActivityLoader()
                        CommonFunctions.showToastWithMessage(error.localizedDescription)
                    }
                } failure: { (error) -> (Void) in
                    CommonFunctions.hideActivityLoader()
                    CommonFunctions.showToastWithMessage(error.localizedDescription)
                }
            }else{
                NotificationCenter.default.post(name: Notification.Name.insulinConnectedSuccessfully, object: nil)
                selff.navigationController?.popToViewControllerOfType(classForCoder: SystemSetupStep1VC.self)
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
        insulinCountTxtField.delegate = self
        insulinCountTxtField.keyboardType = .numberPad
        insulinCountTxtField.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
        insulinCountTxtField.text = "\(SystemInfoModel.shared.insulinUnit)"
        insulinType.text = "\(SystemInfoModel.shared.longInsulinType)"
        insulinSubType.text = "\(SystemInfoModel.shared.longInsulinSubType)"
        insulinDescLbl.text = "How much \(SystemInfoModel.shared.longInsulinType) did you take in the last 24 hours?"
        self.doneBtn.isEnabled = !(insulinCountTxtField.text?.isEmpty ?? true)
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
        insulinCountTxtField.setBorder(width: 1.0, color: AppColors.appGreenColor)
        if textField.text?.count == 0 && string == "0" {
            return false
        }
        return (string.checkIfValidCharaters(.mobileNumber) || string.isEmpty) && newString.length <= 2
    }
}

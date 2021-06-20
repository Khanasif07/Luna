//
//  ForgotPasswordVC.swift
//  Luna
//
//  Created by Admin on 16/06/21.
//

import UIKit
import Firebase
import FirebaseAuth

class ForgotPasswordVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var confirmBtn: AppButton!
    @IBOutlet weak var emailTxtField: AppTextField!
    @IBOutlet weak var backBtnView: UIView!
    
    // MARK: - Variables
    //===========================
    var emailTxt = ""
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backBtnView.round()
        emailTxtField.layer.cornerRadius = 8.0
        emailTxtField.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
        confirmBtn.round(radius: 8.0)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    
    @IBAction func confirmEmailAction(_ sender: AppButton) {
        CommonFunctions.showActivityLoader()
            FirestoreController.forgetPassword(email:  self.emailTxt, completion: {
                CommonFunctions.hideActivityLoader()
                self.gotoPassResetPopUpVC()
            }) { (error) -> (Void) in
                CommonFunctions.hideActivityLoader()
                CommonFunctions.showToastWithMessage(error.localizedDescription)
            }
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension ForgotPasswordVC {
    
    private func initialSetup() {
        self.emailTxtField.delegate = self
        self.emailTxtField.placeholder = LocalizedString.emailID.localized
        self.emailTxtField.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
        self.confirmBtn.isEnabled = false
    }
    
    private func gotoPassResetPopUpVC(){
        let scene =  PassResetPopUpVC.instantiate(fromAppStoryboard: .PreLogin)
        scene.popupType = .resetPassword 
        scene.resetPasswordSuccess  = { [weak self] in
            guard let selff = self else { return }
            selff.pop()
        }
        self.present(scene, animated: true, completion: nil)
    }
}


// MARK: - Extension For TextField Delegate
//====================================
extension ForgotPasswordVC : UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        let txt = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        self.emailTxt = txt
        self.confirmBtn.isEnabled = !self.emailTxt.isEmpty
        self.emailTxtField.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return (string.checkIfValidCharaters(.email) || string.isEmpty) && newString.length <= 50
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.emailTxtField.setBorder(width: 1.0, color: AppColors.appGreenColor)
    }
}

//
//  ChangePasswordVC.swift
//  Luna
//
//  Created by Admin on 24/06/21.
//

import UIKit
import FirebaseAuth
import Firebase


class ChangePasswordVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    
    @IBOutlet weak var saveBtn: AppButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var settingTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    var newPass : String = ""
    var confirmPass : String = ""
    var currentPass: String = ""
    var sections: [String] = ["Old Password","New Password","Confirm Password"]
   
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backView.round()
        saveBtn.round(radius: 8.0)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func saveBtnAction(_ sender: AppButton) {
        CommonFunctions.showActivityLoader()
        let email  = AppUserDefaults.value(forKey: .defaultEmail).stringValue
        self.changePassword(email: email , currentPassword: self.currentPass, newPassword: self.newPass) { (error) in
            if let error = error {
                CommonFunctions.hideActivityLoader()
                CommonFunctions.showToastWithMessage(error.localizedDescription)
                return
            }
            CommonFunctions.hideActivityLoader()
            CommonFunctions.showToastWithMessage("Password is successfully updated")
            self.pop()
        }
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension ChangePasswordVC {
    
    private func initialSetup() {
        tableViewSetup()
    }
   
    private func tableViewSetup(){
        self.saveBtn.isEnabled = false
        self.settingTableView.delegate = self
        self.settingTableView.dataSource = self
        self.settingTableView.registerCell(with: ProfileTableCell.self)
    }
    
    private func signUpBtnStatus()-> Bool{
        return true
    }
    
    func changePassword(email: String, currentPassword: String, newPassword: String, completion: @escaping (Error?) -> Void) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
            if let error = error {
                completion(error)
            }
            else {
                Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in
                    completion(error)
                })
            }
        })
    }
}

// MARK: - Extension For TableView
//===========================
extension ChangePasswordVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: ProfileTableCell.self)
        cell.isSetupforPasswordTxtfield = true
        cell.txtField.delegate = self
        cell.titleLbl.text = sections[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


// MARK: - Extension For TextField Delegate
//====================================
extension ChangePasswordVC : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let cell = settingTableView.cell(forItem: textField) as? ProfileTableCell
        switch cell?.titleLbl.text {
        case sections[0]:
            cell?.txtField.setBorder(width: 1.0, color: AppColors.appGreenColor)
        case sections[1]:
            cell?.txtField.setBorder(width: 1.0, color: AppColors.appGreenColor)
        default:
            cell?.txtField.setBorder(width: 1.0, color: AppColors.appGreenColor)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let txt = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        let cell = settingTableView.cell(forItem: textField) as? ProfileTableCell
        switch cell?.titleLbl.text {
        case sections[0]:
            currentPass = txt
            saveBtn.isEnabled =  (currentPass.count >= 6)
            cell?.txtField.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
        case sections[1]:
            newPass = txt
            saveBtn.isEnabled = (newPass == confirmPass)  && (newPass.count >= 6)
            cell?.txtField.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
        default:
            confirmPass = txt
            saveBtn.isEnabled = (newPass == confirmPass) && (confirmPass.count >= 6)
            cell?.txtField.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cell = settingTableView.cell(forItem: textField) as? ProfileTableCell
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        switch cell?.titleLbl.text {
        case sections[0]:
            saveBtn.isEnabled = newString.length >= 6
            return (string.checkIfValidCharaters(.password) || string.isEmpty) && newString.length <= 25
        case sections[1]:
            saveBtn.isEnabled = newString.length >= 6  && (newPass == confirmPass)
            return (string.checkIfValidCharaters(.password) || string.isEmpty) && newString.length <= 25
        default:
            saveBtn.isEnabled = newString.length >= 6  && (newPass == confirmPass)
            return (string.checkIfValidCharaters(.password) || string.isEmpty) && newString.length <= 25
        }
    }
}

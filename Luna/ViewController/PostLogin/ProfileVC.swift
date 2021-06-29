//
//  ProfileVC.swift
//  Luna
//
//  Created by Admin on 24/06/21.
//

import UIKit

class ProfileVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var saveBtn: AppButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var profileTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    var sections: [(String,String)] = [("First Name",""),("Last Name",""),("Date Of Birth",""),("Email",""),("Diabetes Type","")]
    var typePickerView = WCCustomPickerView()
    
    
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
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func saveBtnAction(_ sender: AppButton) {
        CommonFunctions.showActivityLoader()
        FirestoreController.updateUserNode(email: sections[3].1, password: AppUserDefaults.value(forKey: .defaultPassword).stringValue, firstName: sections[0].1, lastName: sections[1].1, dob: sections[2].1, diabetesType: sections[4].1, isProfileStepCompleted: UserModel.main.isProfileStepCompleted, isBiometricOn: UserModel.main.isBiometricOn) {
            CommonFunctions.hideActivityLoader()
            self.pop()
            CommonFunctions.showToastWithMessage("Profile updated successfully.")
        } failure: { (error) -> (Void) in
            CommonFunctions.hideActivityLoader()
            CommonFunctions.showToastWithMessage(error.localizedDescription)
        }

    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension ProfileVC {
    
    private func initialSetup() {
        setUpData()
        tableViewSetup()
    }
   
    private func tableViewSetup(){
        self.typePickerView.delegate = self
        self.typePickerView.dataArray = ["Type 1","Type 2"]
        self.saveBtn.isEnabled = (!UserModel.main.firstName.isEmpty && !UserModel.main.lastName.isEmpty && !UserModel.main.dob.isEmpty && !UserModel.main.email.isEmpty && !UserModel.main.diabetesType.isEmpty)
        self.profileTableView.delegate = self
        self.profileTableView.dataSource = self
        self.profileTableView.registerCell(with: ProfileTableCell.self)
    }
    
    private func setUpData(){
        self.sections = [("First Name",UserModel.main.firstName),("Last Name",UserModel.main.lastName),("Date Of Birth",UserModel.main.dob),("Email",UserModel.main.email),("Diabetes Type",UserModel.main.diabetesType)]
    }
    
    private func signUpBtnStatus()-> Bool{
        return true
    }
    
    private func saveBtnStatus()-> Bool{
        return !self.sections[0].1.isEmpty && !self.sections[1].1.isEmpty && (!self.sections[2].1.isEmpty && !(self.sections[2].1.count != 10)) && !self.sections[3].1.isEmpty && !self.sections[4].1.isEmpty
    }
    
    
}

// MARK: - Extension For TableView
//===========================
extension ProfileVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: ProfileTableCell.self)
        cell.txtField.delegate = self
        cell.txtField.text = sections[indexPath.row].1
        cell.titleLbl.text = sections[indexPath.row].0
        if sections[indexPath.row].0 == "Diabetes Type" {
            let show = UIButton()
            show.isSelected = false
            show.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
            cell.txtField.inputView = typePickerView
            cell.txtField.setButtonToRightView(btn: show, selectedImage: #imageLiteral(resourceName: "dropdownMobilenumber"), normalImage: #imageLiteral(resourceName: "dropdownMobilenumber"), size: CGSize(width: 20, height: 20))
            
        }else {
            cell.txtField.inputView = nil
            cell.txtField.setButtonToRightView(btn: UIButton(), selectedImage: nil, normalImage: nil, size: CGSize(width: 0, height: 0))
        }
        if  sections[indexPath.row].0 == "Email"{
            cell.isUserInteractionEnabled = false
            cell.txtField.textColor = .lightGray
        }else{
            cell.isUserInteractionEnabled = true
            cell.txtField.textColor = .black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


// MARK: - Extension For TextField Delegate
//====================================
extension ProfileVC : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let cell = profileTableView.cell(forItem: textField) as? ProfileTableCell
        switch cell?.titleLbl.text {
        case sections[0].0:
            cell?.txtField.setBorder(width: 1.0, color: AppColors.appGreenColor)
        case sections[1].0:
            cell?.txtField.setBorder(width: 1.0, color: AppColors.appGreenColor)
        case sections[2].0:
            cell?.txtField.keyboardType = .numberPad
            cell?.txtField.placeholder = "01/01/2000"
        default:
            cell?.txtField.setBorder(width: 1.0, color: AppColors.appGreenColor)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let txt = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        let cell = profileTableView.cell(forItem: textField) as? ProfileTableCell
        switch cell?.titleLbl.text {
        case sections[0].0:
            cell?.txtField.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
            sections[0].1 = txt
            saveBtn.isEnabled = saveBtnStatus()
        case sections[1].0:
            cell?.txtField.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
            sections[1].1 = txt
            saveBtn.isEnabled = saveBtnStatus()
        case sections[2].0:
            cell?.txtField.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
            sections[2].1 = txt
            saveBtn.isEnabled = saveBtnStatus()
        case sections[3].0:
            cell?.txtField.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
            sections[3].1 = txt
            saveBtn.isEnabled = saveBtnStatus()
        default:
            cell?.txtField.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
            saveBtn.isEnabled = saveBtnStatus()
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let txt = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        let cell = profileTableView.cell(forItem: textField) as? ProfileTableCell
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        switch cell?.titleLbl.text {
        case sections[0].0:
            return (string.checkIfValidCharaters(.email) || string.isEmpty) && newString.length <= 50
        case sections[1].0:
            return (string.checkIfValidCharaters(.email) || string.isEmpty) && newString.length <= 25
        case sections[2].0:
            switch txt.count {
            case 2,5:
                if newString.length < currentString.length {cell?.txtField.text = txt } else {
                    cell?.txtField.text = txt + "/" }
            default:
                cell?.txtField.text = txt
            }
            saveBtn.isEnabled = !(newString.length != 10)
            return (string.checkIfValidCharaters(.name) || string.isEmpty) && newString.length <= 10
        default:
            return true
        }
    }
}

// MARK:- Extension For TextField Delegate
//====================================
extension ProfileVC: WCCustomPickerViewDelegate {
    
    func userDidSelectRow(_ text : String){
        let indexx = sections.firstIndex(where: { (tupls) -> Bool in
            return tupls.0 == "Diabetes Type"
        })
        guard let selectedIndexx = indexx else {return}
        sections[selectedIndexx].1 = text
        saveBtn.isEnabled = saveBtnStatus()
        self.profileTableView.reloadRows(at: [IndexPath.init(row: selectedIndexx, section: 0)], with: .fade)
    }
}

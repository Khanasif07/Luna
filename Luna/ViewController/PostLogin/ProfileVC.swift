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
    var sections: [(String,String)] = [("First Name",""),("Last Name",""),("Date Of Birth",""),("Apple Health",""),("Email",""),("Diabetes Type","")]
   
    
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
    
    
}

// MARK: - Extension For Functions
//===========================
extension ProfileVC {
    
    private func initialSetup() {
        setUpData()
        tableViewSetup()
    }
   
    private func tableViewSetup(){
        self.saveBtn.isEnabled = false
        self.profileTableView.delegate = self
        self.profileTableView.dataSource = self
        self.profileTableView.registerCell(with: ProfileTableCell.self)
    }
    
    private func setUpData(){
        self.sections = [("First Name",UserModel.main.firstName),("Last Name",UserModel.main.lastName),("Date Of Birth",UserModel.main.dob),("Apple Health",""),("Email",UserModel.main.email),("Diabetes Type",UserModel.main.diabetesType)]
    }
    private func signUpBtnStatus()-> Bool{
        return true
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
        default:
            cell?.txtField.setBorder(width: 1.0, color: AppColors.appGreenColor)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let _ = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        let cell = profileTableView.cell(forItem: textField) as? ProfileTableCell
        switch cell?.titleLbl.text {
        case sections[0].0:
            cell?.txtField.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
        case sections[1].0:
            cell?.txtField.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
        default:
            cell?.txtField.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cell = profileTableView.cell(forItem: textField) as? ProfileTableCell
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        switch cell?.titleLbl.text {
        case sections[0].0:
            return (string.checkIfValidCharaters(.email) || string.isEmpty) && newString.length <= 50
        case sections[1].0:
            return (string.checkIfValidCharaters(.password) || string.isEmpty) && newString.length <= 25
        default:
            return false
        }
    }
}

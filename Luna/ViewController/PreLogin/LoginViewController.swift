//
//  LoginViewController.swift
//  Luna
//
//  Created by Admin on 15/06/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var loginTableView: UITableView!
    
    
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
            return .darkContent
        } else {
            // Fallback on earlier versions
            return .lightContent
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - IBActions
    //===========================
    
    
}

// MARK: - Extension For Functions
//===========================
extension LoginViewController {
    
    private func initialSetup() {
        self.tableViewSetUp()
    }
    
    public func tableViewSetUp(){
        self.loginTableView.delegate = self
        self.loginTableView.dataSource = self
        self.loginTableView.tableHeaderView = headerView
        self.loginTableView.tableHeaderView?.height = 200.0
        self.loginTableView.registerCell(with: LoginSocialTableCell.self)
        self.loginTableView.registerCell(with: SignUpTopTableCell.self)
    }
    
    private func signUpBtnStatus()-> Bool{
        return true
    }
}

// MARK: - Extension For TableView
//===========================

extension LoginViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueCell(with: SignUpTopTableCell.self, indexPath: indexPath)
            cell.titleLbl.text = LocalizedString.login.localized
            cell.subTitleLbl.text = LocalizedString.please_login_to_get_good_sleep.localized
            cell.signUpBtn.setTitle(LocalizedString.login.localized, for: .normal)
            [cell.emailIdTxtField,cell.passTxtField].forEach({$0?.delegate = self})
            cell.signUpBtnTapped = { [weak self]  (sender) in
                guard let `self` = self else { return }
            }
            return cell
        default:
            let cell = tableView.dequeueCell(with: LoginSocialTableCell.self, indexPath: indexPath)
            cell.googleBtnTapped = {[weak self] in
                guard let self = `self` else { return }
            }
            cell.appleBtnTapped = { [weak self] in
                guard let self = `self` else { return }
            }
            cell.loginBtnTapped = { [weak self] in
                guard let self = `self` else { return }
                self.pop()
                
            }

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}



// MARK: - Extension For TextField Delegate
//====================================
extension LoginViewController : UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        let _ = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        let cell = loginTableView.cell(forItem: textField) as? SignUpTopTableCell
        switch textField {
        case cell?.emailIdTxtField:
            cell?.signUpBtn.isEnabled = signUpBtnStatus()
        case cell?.passTxtField:
            cell?.signUpBtn.isEnabled = signUpBtnStatus()
        default:
            cell?.signUpBtn.isEnabled = signUpBtnStatus()
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cell = loginTableView.cell(forItem: textField) as? SignUpTopTableCell
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        switch textField {
        case cell?.emailIdTxtField:
            return (string.checkIfValidCharaters(.email) || string.isEmpty) && newString.length <= 50
        case cell?.passTxtField:
            return (string.checkIfValidCharaters(.password) || string.isEmpty) && newString.length <= 25
        default:
            return false
        }
    }
}

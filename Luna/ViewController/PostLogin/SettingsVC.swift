//
//  SettingsVC.swift
//  Luna
//
//  Created by Admin on 22/06/21.
//


import UIKit

class SettingsVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var settingTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    var sections: [(UIImage,String)] = [(#imageLiteral(resourceName: "profile"),"Profile"),(#imageLiteral(resourceName: "changePassword"),"Change Password"),(#imageLiteral(resourceName: "faceId"),"Face ID"),(#imageLiteral(resourceName: "appleHealth"),"Apple Health"),(#imageLiteral(resourceName: "system"),"System"),(#imageLiteral(resourceName: "about"),"About"),(#imageLiteral(resourceName: "deleteAccount"),"Delete Account")]
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backView.round()
    }
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.pop()
    }
    
}

// MARK: - Extension For Functions
//===========================
extension SettingsVC {
    
    private func initialSetup() {
        self.tableViewSetup()
    }
    
    private func tableViewSetup(){
        self.settingTableView.delegate = self
        self.settingTableView.dataSource = self
        self.settingTableView.registerCell(with: SettingTableCell.self)
    }
}

// MARK: - Extension For TableView
//===========================
extension SettingsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: SettingTableCell.self)
        cell.titleLbl.text = sections[indexPath.row].1
        cell.logoImgView.image = sections[indexPath.row].0
        if indexPath.row == 2 || indexPath.row == 3 {
            cell.nextBtn.isHidden = true
            cell.switchView.isHidden = false
        }else {
            cell.nextBtn.isHidden = false
            cell.switchView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//
//  SystemSetupVC.swift
//  Luna
//
//  Created by Admin on 28/06/21.
//

import UIKit

class SystemSetupVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    
    @IBOutlet weak var systemTableView: UITableView!
    @IBOutlet weak var backView: UIView!
    
    // MARK: - Variables
    //===========================
    var sections: [(UIImage,String,String)] = [(#imageLiteral(resourceName: "changeLongActingInsulin"),"Change Long Acting Insulin","Basaglar | 8 units"),(#imageLiteral(resourceName: "changeCgm"),"Change CGM","Dexcom G6"),(#imageLiteral(resourceName: "changeConnectedLunaDevice"),"Change connected Luna",""),(#imageLiteral(resourceName: "alerts"),"Alerts","Explainer what they do")]
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
extension SystemSetupVC {
    
    private func initialSetup() {
        self.getSystemInfo()
        if #available(iOS 13.0, *) {
        overrideUserInterfaceStyle = .light
        }
        self.sections = [(#imageLiteral(resourceName: "changeLongActingInsulin"),"Change Long Acting Insulin","\(SystemInfoModel.shared.longInsulinType) | \(SystemInfoModel.shared.insulinUnit) units"),(#imageLiteral(resourceName: "changeCgm"),"Change CGM","\(SystemInfoModel.shared.cgmType)"),(#imageLiteral(resourceName: "changeConnectedLunaDevice"),"Change connected Luna",""),(#imageLiteral(resourceName: "alerts"),"Alerts","Explainer what they do")]
        self.tableViewSetup()
        self.addObserver()
    }
    
    private func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(lunaPairedFinish), name: .lunaPairedSuccessfully, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(insulinConnectedFinish), name: .insulinConnectedSuccessfully, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cgmConnectedFinish), name: .cgmConnectedSuccessfully, object: nil)
    }
    
    @objc func lunaPairedFinish(){
        self.sections = [(#imageLiteral(resourceName: "changeLongActingInsulin"),"Change Long Acting Insulin","\(SystemInfoModel.shared.longInsulinType) | \(SystemInfoModel.shared.insulinUnit) units"),(#imageLiteral(resourceName: "changeCgm"),"Change CGM","\(SystemInfoModel.shared.cgmType)"),(#imageLiteral(resourceName: "changeConnectedLunaDevice"),"Change connected Luna",""),(#imageLiteral(resourceName: "alerts"),"Alerts","Explainer what they do")]
        self.systemTableView.reloadData()
    }
    
    @objc func  insulinConnectedFinish(){
        self.sections = [(#imageLiteral(resourceName: "changeLongActingInsulin"),"Change Long Acting Insulin","\(SystemInfoModel.shared.longInsulinType) | \(SystemInfoModel.shared.insulinUnit) units"),(#imageLiteral(resourceName: "changeCgm"),"Change CGM","\(SystemInfoModel.shared.cgmType)"),(#imageLiteral(resourceName: "changeConnectedLunaDevice"),"Change connected Luna",""),(#imageLiteral(resourceName: "alerts"),"Alerts","Explainer what they do")]
        self.systemTableView.reloadData()
    }
    
    @objc func  cgmConnectedFinish(){
        self.sections = [(#imageLiteral(resourceName: "changeLongActingInsulin"),"Change Long Acting Insulin","\(SystemInfoModel.shared.longInsulinType) | \(SystemInfoModel.shared.insulinUnit) units"),(#imageLiteral(resourceName: "changeCgm"),"Change CGM","\(SystemInfoModel.shared.cgmType)"),(#imageLiteral(resourceName: "changeConnectedLunaDevice"),"Change connected Luna",""),(#imageLiteral(resourceName: "alerts"),"Alerts","Explainer what they do")]
        self.systemTableView.reloadData()
    }
    
    private func tableViewSetup(){
        self.systemTableView.delegate = self
        self.systemTableView.dataSource = self
        self.systemTableView.registerCell(with: SettingTableCell.self)
    }
    
    private func getSystemInfo(){
        CommonFunctions.showActivityLoader()
        FirestoreController.getUserSystemInfoData{
            CommonFunctions.hideActivityLoader()
            self.sections = [(#imageLiteral(resourceName: "changeLongActingInsulin"),"Change Long Acting Insulin","\(SystemInfoModel.shared.longInsulinType) | \(SystemInfoModel.shared.insulinUnit) units"),(#imageLiteral(resourceName: "changeCgm"),"Change CGM","\(SystemInfoModel.shared.cgmType)"),(#imageLiteral(resourceName: "changeConnectedLunaDevice"),"Change connected Luna",""),(#imageLiteral(resourceName: "alerts"),"Alerts","Explainer what they do")]
            self.systemTableView.reloadData()
        } failure: { (error) -> (Void) in
            CommonFunctions.hideActivityLoader()
            CommonFunctions.showToastWithMessage(error.localizedDescription)
        }
    }
}

// MARK: - Extension For TableView
//===========================
extension SystemSetupVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: SettingTableCell.self)
        cell.subTitlelbl.isHidden = false
        cell.titleLbl.text = sections[indexPath.row].1
        cell.subTitlelbl.text = sections[indexPath.row].2
        cell.logoImgView.image = sections[indexPath.row].0
        cell.nextBtn.isHidden = false
        cell.switchView.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2:
            SystemInfoModel.shared.isFromSetting = true
            let vc = PairLunaVC.instantiate(fromAppStoryboard: .CGPStoryboard)
            self.navigationController?.pushViewController(vc, animated: true)
        case 0:
            SystemInfoModel.shared.isFromSetting = true
            let vc = InsulinStep1VC.instantiate(fromAppStoryboard: .SystemSetup)
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            SystemInfoModel.shared.isFromSetting = true
            let vc = CGMSelectorVC.instantiate(fromAppStoryboard: .CGPStoryboard)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            CommonFunctions.showToastWithMessage("Under Development")
        }
    }
}

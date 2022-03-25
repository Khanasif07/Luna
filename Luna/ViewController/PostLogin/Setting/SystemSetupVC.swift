//
//  SystemSetupVC.swift
//  Luna
//
//  Created by Admin on 28/06/21.
//

import UIKit

class SystemSetupVC: UIViewController {
    
    enum SettingType{
        case Luna
        case App
    }
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var systemTableView: UITableView!
    @IBOutlet weak var backView: UIView!
    
    // MARK: - Variables
    //===========================
    var backgroundView1 = UIView(frame: CGRect.zero)
    var customView: CustomView?
    var settingType : SettingType = .Luna
    var sections: [(UIImage,String,String)] = [(#imageLiteral(resourceName: "changeLongActingInsulin"),LocalizedString.change_Long_Acting_Insulin.localized,""),(#imageLiteral(resourceName: "changeCgm"),LocalizedString.change_CGM.localized,""),(#imageLiteral(resourceName: "changeConnectedLunaDevice"),LocalizedString.change_connected_Luna_Device.localized,""),(#imageLiteral(resourceName: "alerts"),LocalizedString.alerts.localized,LocalizedString.explainer_what_they_do.localized)]
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backView.round()
        self.backgroundView1.frame = self.view.frame
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            let position = touch.location(in: customView)
            if position.y <= 102.0 && position.y >= 0.0 {
            }else{ backgroundView1.removeFromSuperview()}
        }
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
        if settingType == .Luna {
            self.getSystemInfo()
            self.titleLbl.text = LocalizedString.luna_settings.localized
        }
        else{ self.titleLbl.text = LocalizedString.app_settings.localized}
        self.customView = CustomView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.customView?.delegate = self
        self.setUpSectionData()
        self.tableViewSetup()
        self.addObserver()
    }
    
    private func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(lunaPairedFinish), name: .lunaPairedSuccessfully, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(insulinConnectedFinish), name: .insulinConnectedSuccessfully, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cgmConnectedFinish), name: .cgmConnectedSuccessfully, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(lunaPairedFinish), name: .bLEDidDisConnectSuccessfully, object: nil)
    }
    
    private func setUpSectionData(){
        if settingType == .Luna {
            if UserDefaultsRepository.shareUserName.value.isEmpty || UserDefaultsRepository.sharePassword.value.isEmpty{
                self.sections = [(#imageLiteral(resourceName: "changeLongActingInsulin"),LocalizedString.change_Long_Acting_Insulin.localized,"\(SystemInfoModel.shared.longInsulinType) | \(SystemInfoModel.shared.insulinUnit) units"),(#imageLiteral(resourceName: "changeCgm"),LocalizedString.change_CGM.localized,"\(SystemInfoModel.shared.cgmType)"),(#imageLiteral(resourceName: "changeConnectedLunaDevice"),LocalizedString.change_connected_Luna_Device.localized,BleManager.sharedInstance.myperipheral?.name ?? ""),(#imageLiteral(resourceName: "alerts"),LocalizedString.alerts.localized,LocalizedString.explainer_what_they_do.localized)]
            }else {
                self.sections = [(#imageLiteral(resourceName: "changeLongActingInsulin"),LocalizedString.change_Long_Acting_Insulin.localized,"\(SystemInfoModel.shared.longInsulinType) | \(SystemInfoModel.shared.insulinUnit) units"),(#imageLiteral(resourceName: "changeCgm"),LocalizedString.change_CGM.localized,"\(SystemInfoModel.shared.cgmType)"),(#imageLiteral(resourceName: "changeConnectedLunaDevice"),LocalizedString.change_connected_Luna_Device.localized,BleManager.sharedInstance.myperipheral?.name ?? ""),(#imageLiteral(resourceName: "alerts"),LocalizedString.alerts.localized,LocalizedString.explainer_what_they_do.localized)]
            }
        }else {
            if !UserModel.main.isChangePassword {
                self.sections = [(#imageLiteral(resourceName: "faceId"),!hasTopNotch ? LocalizedString.touch_ID.localized : LocalizedString.face_ID.localized,""),(#imageLiteral(resourceName: "appleHealth"),LocalizedString.apple_Health.localized,"")]
            } else{
                self.sections = [(#imageLiteral(resourceName: "faceId"),!hasTopNotch ? LocalizedString.touch_ID.localized : LocalizedString.face_ID.localized,""),(#imageLiteral(resourceName: "appleHealth"),LocalizedString.apple_Health.localized,""),(#imageLiteral(resourceName: "changePassword"),LocalizedString.change_Password.localized,"")]
            }
        }
    }
    
    @objc func lunaPairedFinish(){
        self.setUpSectionData()
        self.systemTableView.reloadData()
    }
    
    @objc func  insulinConnectedFinish(){
        self.setUpSectionData()
        self.systemTableView.reloadData()
    }
    
    @objc func  cgmConnectedFinish(){
        self.setUpSectionData()
        self.systemTableView.reloadData()
    }
    
    private func tableViewSetup(){
        self.systemTableView.delegate = self
        self.systemTableView.dataSource = self
        self.systemTableView.registerHeaderFooter(with: SettingHeaderView.self)
        self.systemTableView.registerCell(with: SettingTableCell.self)
    }
    
    private func getSystemInfo(){
        CommonFunctions.showActivityLoader()
        FirestoreController.checkUserExistInSystemDatabase{
            FirestoreController.getUserSystemInfoData{
                CommonFunctions.hideActivityLoader()
                self.setUpSectionData()
                self.systemTableView.reloadData()
            } failure: { (error) -> (Void) in
                CommonFunctions.hideActivityLoader()
                CommonFunctions.showToastWithMessage(error.localizedDescription)
            }
        }failure: { () -> (Void) in
            CommonFunctions.hideActivityLoader()
        }
    }
    
    func showPopupMsg() {
        self.backgroundView1.removeFromSuperview()
        if let infoView = self.customView {
            backgroundView1.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            customView?.frame = CGRect(x: 20.0, y: UIDevice.height / 2.0 - (50.0), width: UIDevice.width - 40.0 , height: 120.0)
            backgroundView1.addSubview(infoView)
            self.view.addSubview(backgroundView1)
        }
    }
}

// MARK: - Extension For TableView
//===========================
extension SystemSetupVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.endIndex
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueHeaderFooter(with: SettingHeaderView.self)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch settingType {
        case .Luna:
            let cell = tableView.dequeueCell(with: SettingTableCell.self)
            cell.subTitlelbl.isHidden = false
            cell.titleLbl.text = sections[indexPath.section].1
            cell.subTitlelbl.text = sections[indexPath.section].2
            cell.logoImgView.image = sections[indexPath.section].0
            if self.sections[indexPath.section].1 == LocalizedString.alerts.localized{
                cell.switchView.isUserInteractionEnabled = true
                cell.nextBtn.isHidden = true
                cell.switchView.isHidden = false
                cell.switchView.isOn = AppUserDefaults.value(forKey: .isAlertsOn).boolValue
            }else{
                cell.nextBtn.isHidden = false
                cell.switchView.isHidden = true
            }
            cell.switchTapped = { [weak self] sender in
                guard let self = self else { return }
                if self.sections[indexPath.section].1 == LocalizedString.alerts.localized {
                    CommonFunctions.showActivityLoader()
                    let isOn = AppUserDefaults.value(forKey: .isAlertsOn).boolValue
                    FirestoreController.updateUserAlertsStatus(isAlertsOn: !isOn) {
                        CommonFunctions.hideActivityLoader()
                        AppUserDefaults.save(value: !isOn, forKey: .isAlertsOn)
                        UserModel.main.isAlertsOn = !isOn
                        self.systemTableView.reloadData()
                    } failure: { (err) -> (Void) in
                        CommonFunctions.hideActivityLoader()
                        CommonFunctions.showToastWithMessage(err.localizedDescription)
                    } failures: {
                        CommonFunctions.hideActivityLoader()
                        print("Do nothing")
                    }
                }
            }
            return cell
        case .App:
            let cell = tableView.dequeueCell(with: SettingTableCell.self)
            cell.subTitlelbl.isHidden = true
            cell.titleLbl.text = sections[indexPath.section].1
            cell.logoImgView.image = sections[indexPath.section].0
            if indexPath.section == 0{
                cell.switchView.isUserInteractionEnabled = true
                cell.nextBtn.isHidden = true
                cell.switchView.isHidden = false
                cell.switchView.isOn = AppUserDefaults.value(forKey: .isBiometricSelected).boolValue
            }else{
                cell.nextBtn.isHidden = false
                cell.switchView.isHidden = true
            }
            cell.switchTapped = { [weak self] sender in
                guard let self = self else { return }
                if indexPath.section == 0 {
                    CommonFunctions.showActivityLoader()
                    let isOn = AppUserDefaults.value(forKey: .isBiometricSelected).boolValue
                    FirestoreController.updateUserBiometricStatus(isBiometricOn:  !isOn) {
                        CommonFunctions.hideActivityLoader()
                        AppUserDefaults.save(value: !isOn, forKey: .isBiometricSelected)
                        self.systemTableView.reloadData()
                    } failure: { (err) -> (Void) in
                        CommonFunctions.hideActivityLoader()
                        CommonFunctions.showToastWithMessage(err.localizedDescription)
                    } failures: {
                        CommonFunctions.hideActivityLoader()
                        print("Do nothing")
                    }
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch settingType {
        case .App:
            switch indexPath.section {
            case 0:
                print("Do Nothing.")
            case 1:
                self.showPopupMsg()
            default:
                let vc = ChangePasswordVC.instantiate(fromAppStoryboard: .PostLogin)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            switch self.sections[indexPath.section].1 {
            case LocalizedString.change_connected_Luna_Device.localized:
                SystemInfoModel.shared.isFromSetting = true
                let vc = PairLunaVC.instantiate(fromAppStoryboard: .CGPStoryboard)
                self.navigationController?.pushViewController(vc, animated: true)
            case LocalizedString.change_Long_Acting_Insulin.localized:
                SystemInfoModel.shared.isFromSetting = true
                let vc = InsulinStep1VC.instantiate(fromAppStoryboard: .SystemSetup)
                self.navigationController?.pushViewController(vc, animated: true)
            case LocalizedString.change_CGM.localized:
                SystemInfoModel.shared.isFromSetting = true
                let vc = CGMSelectorVC.instantiate(fromAppStoryboard: .CGPStoryboard)
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                print("Do Nothing.")
            }
        }
    }
}


//MARK:- CustomViewDelegate
//=================
extension SystemSetupVC: CustomViewDelegate {
    
    func successBtnAction() {
        self.backgroundView1.removeFromSuperview()
        if let settingsUrl = URL(string: "x-apple-health://") {
            UIApplication.shared.open(settingsUrl)
        }
    }
}

//
//  SystemSetupVC.swift
//  Luna
//
//  Created by Admin on 28/06/21.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import FirebaseCore

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
    public let db = Firestore.firestore()
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
        if #available(iOS 13.0, *) {
        overrideUserInterfaceStyle = .light
        }
        if settingType == .Luna {
            self.getSystemInfo()
            self.titleLbl.text = LocalizedString.luna_settings.localized
        }
        else{self.titleLbl.text = LocalizedString.app_settings.localized}
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
        NotificationCenter.default.addObserver(self, selector: #selector(lunaPairedFinish), name: .BLEDidDisConnectSuccessfully, object: nil)
    }
        
        private func setUpSectionData(){
            if settingType == .Luna {
                self.sections = [(#imageLiteral(resourceName: "changeLongActingInsulin"),LocalizedString.change_Long_Acting_Insulin.localized,"\(SystemInfoModel.shared.longInsulinType) | \(SystemInfoModel.shared.insulinUnit) units"),(#imageLiteral(resourceName: "changeCgm"),LocalizedString.change_CGM.localized,"\(SystemInfoModel.shared.cgmType)"),(#imageLiteral(resourceName: "changeConnectedLunaDevice"),LocalizedString.change_connected_Luna_Device.localized,BleManager.sharedInstance.myperipheral?.name ?? ""),(#imageLiteral(resourceName: "alerts"),LocalizedString.alerts.localized,LocalizedString.explainer_what_they_do.localized)]
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
//            notificationPopUp?.message.text = msg
//            notificationPopUp?.yesBtn.setTitle(ApiKey.continueUpperCase, for: .normal)
//            notificationPopUp?.noBtn.setTitle(ApiKey.cancel, for: .normal)
//            notificationPopUp?.noBtn.backgroundColor = AppColors.disableGrayColor
//            notificationPopUp?.noBtn.setTitleColor(AppColors.blackColor, for: .normal)
//            notificationPopUp?.title.text = forSuccess ? ApiKey.successUpperCase : LocalizedString.are_you_sure.localized
//            notificationPopUp?.button.isHidden = !forSuccess
//            notificationPopUp?.stackView.isHidden = forSuccess
            backgroundView1.addSubview(infoView)
            self.view.addSubview(backgroundView1)
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
        switch settingType {
        case .Luna:
            let cell = tableView.dequeueCell(with: SettingTableCell.self)
            cell.subTitlelbl.isHidden = false
            cell.titleLbl.text = sections[indexPath.row].1
            cell.subTitlelbl.text = sections[indexPath.row].2
            cell.logoImgView.image = sections[indexPath.row].0
            if indexPath.row == 3{
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
                if indexPath.row == 3 {
                    let isOn = AppUserDefaults.value(forKey: .isAlertsOn).boolValue
                    self.db.collection(ApiKey.users).document(UserModel.main.id).updateData([ApiKey.isAlertsOn: !isOn])
                    AppUserDefaults.save(value: !isOn, forKey: .isAlertsOn)
                    self.systemTableView.reloadData()
                }
            }
            return cell
        case .App:
            let cell = tableView.dequeueCell(with: SettingTableCell.self)
            cell.subTitlelbl.isHidden = true
            cell.titleLbl.text = sections[indexPath.row].1
            cell.logoImgView.image = sections[indexPath.row].0
            if indexPath.row == 0{
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
                if indexPath.row == 0 {
                    let isOn = AppUserDefaults.value(forKey: .isBiometricSelected).boolValue
                    self.db.collection(ApiKey.users).document(UserModel.main.id).updateData([ApiKey.isBiometricOn: !isOn])
                    AppUserDefaults.save(value: !isOn, forKey: .isBiometricSelected)
                    self.systemTableView.reloadData()
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
            switch indexPath.row {
            case 0:
                print("Do Nothing.")
            case 1:
//                UIApplication.openSettingsURLString
//                showAlert(msg: "To modify which data Luna shares with Apple Health:Open the Health App,select sources tab and select Luna App,Set desired permissions.")
                self.showPopupMsg()
//                if let settingsUrl = URL(string: "x-apple-health://") {
//                   UIApplication.shared.open(settingsUrl)
//                 }
            default:
                let vc = ChangePasswordVC.instantiate(fromAppStoryboard: .PostLogin)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
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

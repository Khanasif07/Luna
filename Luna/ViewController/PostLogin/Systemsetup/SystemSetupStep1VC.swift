//
//  SystemSetupStep1VC.swift
//  Luna
//
//  Created by Admin on 01/07/21.
//


import UIKit

class SystemSetupStep1VC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var doneBtnHeightCost: NSLayoutConstraint!
    @IBOutlet weak var doneBtn: AppButton!
    @IBOutlet weak var manualView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var doneBtnBottmCost: NSLayoutConstraint!
    
    // MARK: - Variables
    //===========================
    var sections: [(String,Bool)] = [(LocalizedString.pair_luna.localized,false),(LocalizedString.link_cgm.localized,false),(LocalizedString.insulin_info.localized,false)]
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.manualView.round()
        self.infoView.round()
        self.doneBtn.round(radius: 4.0)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func skipBtnAction(_ sender: UIButton) {
        CommonFunctions.showActivityLoader()
        FirestoreController.updateUserSystemSetupStatus(isSystemSetupCompleted: true) {
            SystemInfoModel.shared = SystemInfoModel()
            CommonFunctions.hideActivityLoader()
            //MARK: - Important
            if let uuid = UIDevice.current.identifierForVendor?.uuidString {
                FirestoreController.updateDeviceID(deviceId: uuid)
            }
            AppUserDefaults.save(value: true, forKey: .isSystemSetupCompleted)
            AppRouter.gotoHomeVC()
        } failure: { (error) -> (Void) in
            CommonFunctions.hideActivityLoader()
            CommonFunctions.showToastWithMessage(error.localizedDescription)
        }
    }
    
    @IBAction func infoBtnTapped(_ sender: UIButton) {
        showAlert(msg: "UNDER DEVELOPMENT")
    }
    
    @IBAction func manualBtnTapped(_ sender: UIButton) {
        showAlert(msg: "UNDER DEVELOPMENT")
    }
    
    @IBAction func doneBtnAction(_ sender: AppButton) {
        //MARK:- Need to manage all three casE
        CommonFunctions.showActivityLoader()
        FirestoreController.setSystemInfoData(userId: AppUserDefaults.value(forKey: .uid).stringValue, longInsulinType: SystemInfoModel.shared.longInsulinType, longInsulinSubType: SystemInfoModel.shared.longInsulinSubType, insulinUnit: SystemInfoModel.shared.insulinUnit, cgmType: SystemInfoModel.shared.cgmType) {
            FirestoreController.updateUserSystemSetupStatus(isSystemSetupCompleted: true) {
                CommonFunctions.hideActivityLoader()
                //MARK: - Important
                if let uuid = UIDevice.current.identifierForVendor?.uuidString {
                    FirestoreController.updateDeviceID(deviceId: uuid)
                }
                AppUserDefaults.save(value: true, forKey: .isSystemSetupCompleted)
                AppRouter.gotoHomeVC()
            } failure: { (error) -> (Void) in
                CommonFunctions.hideActivityLoader()
                AppUserDefaults.save(value: false, forKey: .isSystemSetupCompleted)
                CommonFunctions.showToastWithMessage(error.localizedDescription)
            }
        } failure: { (error) -> (Void) in
            CommonFunctions.hideActivityLoader()
            AppUserDefaults.save(value: false, forKey: .isSystemSetupCompleted)
            CommonFunctions.showToastWithMessage(error.localizedDescription)
        }
    }
    
}

// MARK: - Extension For Functions
//===========================
extension SystemSetupStep1VC {
    
    private func initialSetup() {
        self.addObserver()
        self.tableViewSetup()
        self.setupProgressView()
       
    }
    
    private func setupProgressView(){
        self.doneBtn.isHidden = true
        self.doneBtnBottmCost.constant = 0.0
        self.doneBtnHeightCost.constant = 0.0
        self.progressView.progressTintColor = #colorLiteral(red: 0.2392156863, green: 0.7882352941, blue: 0.5764705882, alpha: 1)
        self.progressView.round(radius: 3.0)
        self.progressView.clipsToBounds = true
        // Set the rounded edge for the inner bar
        self.progressView.layer.sublayers![1].cornerRadius = 3
        self.progressView.subviews[1].clipsToBounds = true
        CommonFunctions.delay(delay: 0.0) {
            self.progressView.setProgress(0.0, animated: true)
        }
    }
    
    private func tableViewSetup(){
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.registerCell(with: SystemStep1TableCell.self)
    }
    
    private func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(lunaPairedFinish), name: .lunaPairedSuccessfully, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(insulinConnectedFinish), name: .insulinConnectedSuccessfully, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cgmConnectedFinish), name: .cgmConnectedSuccessfully, object: nil)
        
    }
    
    @objc func lunaPairedFinish(){
        //MARK:- Need to manage all three case
        self.sections[0].1 = true
        let count = self.sections.filter { (tupls) -> Bool in
            return tupls.1
        }
        let selectedStep = count.endIndex
        CommonFunctions.delay(delay: 1.0) {
            self.progressView.setProgress(Float(selectedStep) * 1/3, animated: true)
        }
        tableViewReload(selectedStep: selectedStep)
    }
    
    @objc func  insulinConnectedFinish(){
        //MARK:- Need to manage all three case
        self.sections[2].1 = true
        let count = self.sections.filter { (tupls) -> Bool in
            return tupls.1
        }
        let selectedStep = count.endIndex
        CommonFunctions.delay(delay: 1.0) {
            self.progressView.setProgress(Float(selectedStep) * 1/3, animated: true)
        }
        tableViewReload(selectedStep: selectedStep)
    }
    
    @objc func  cgmConnectedFinish(){
        //MARK:- Need to manage all three case
        self.sections[1].1 = true
        let count = self.sections.filter { (tupls) -> Bool in
            return tupls.1
        }
        let selectedStep = count.endIndex
        CommonFunctions.delay(delay: 1.0) {
            self.progressView.setProgress(Float(selectedStep) * 1/3, animated: true)
        }
        tableViewReload(selectedStep: selectedStep)
    }
    
    private func tableViewReload(selectedStep: Int){
        if selectedStep == 3 {
            self.doneBtn.isEnabled = true
            self.doneBtn.isHidden = false
            self.doneBtnBottmCost.constant = 30.0
            self.doneBtnHeightCost.constant = 44.0
        }
        self.view.layoutIfNeeded()
        self.mainTableView.beginUpdates()
        self.mainTableView.endUpdates()
        self.mainTableView.reloadData()
    }
    
    private func cellForRowSetUp(indexPath: IndexPath,cell: SystemStep1TableCell){
        switch indexPath.row {
        case 0:
            cell.stepLbl.text = LocalizedString.step.localized + " \(indexPath.row + 1)"
            cell.pairedDeviceImgView.isHidden = !sections[indexPath.row].1
            cell.cgmInsulinDataView.isHidden = true
            cell.titleLbl.text =  sections[indexPath.row].1 ? LocalizedString.luna_Device_Paired.localized : LocalizedString.pair_luna.localized
            cell.startBtn.setTitle(sections[indexPath.row].1 ? LocalizedString.edit.localized : LocalizedString.start.localized, for: .normal)
            cell.startBtn.tag = sections[indexPath.row].1 ? 2 : 1
            if sections[indexPath.row].1 {
                cell.startBtn.isEditable = true
            }
            cell.timeDescView.isHidden = sections[indexPath.row].1
        case 1:
            cell.stepLbl.text = LocalizedString.step.localized + " \(indexPath.row + 1)"
            cell.pairedDeviceImgView.isHidden = true
            cell.cgmInsulinDataView.isHidden = !sections[indexPath.row].1
            cell.timeToCompleteLabel.text = LocalizedString.about_5_minutes_to_complete.localized
            cell.titleLbl.text =  sections[indexPath.row].1 ? SystemInfoModel.shared.cgmType : LocalizedString.link_cgm.localized
            cell.startBtn.setTitle(sections[indexPath.row].1 ? LocalizedString.edit.localized : LocalizedString.start.localized, for: .normal)
            cell.startBtn.tag = sections[indexPath.row].1 ? 2 : 1
            cell.timeDescView.isHidden = sections[indexPath.row].1
            if sections[indexPath.row].1 {
                cell.startBtn.isEditable = true
            }
        default:
            cell.stepLbl.text = LocalizedString.step.localized + " \(indexPath.row + 1)"
            cell.pairedDeviceImgView.isHidden = true
            cell.cgmInsulinDataView.isHidden = !sections[indexPath.row].1
            cell.unitLbl.text = LocalizedString.per_day.localized
            cell.quantityLbl.text = "\(SystemInfoModel.shared.insulinUnit)" + " u"
            cell.directionText.isHidden = true
            cell.titleLbl.text =  sections[indexPath.row].1 ? SystemInfoModel.shared.longInsulinType : LocalizedString.insulin_info.localized
            cell.startBtn.setTitle(sections[indexPath.row].1 ? LocalizedString.edit.localized : LocalizedString.start.localized, for: .normal)
            cell.startBtn.tag = sections[indexPath.row].1 ? 2 : 1
            cell.timeDescView.isHidden = sections[indexPath.row].1
            if sections[indexPath.row].1 {
                cell.startBtn.isEditable = true
            }
        }
    }
}

// MARK: - Extension For TableView
//===========================
extension SystemSetupStep1VC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: SystemStep1TableCell.self)
        //MARK:- Start Button Action
        cell.startBtnTapped = { [weak self] in
            guard let self = self else { return }
            switch indexPath.row {
            case 0:
                SystemInfoModel.shared.isFromSetting = false
                let vc = PairLunaVC.instantiate(fromAppStoryboard: .CGPStoryboard)
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                SystemInfoModel.shared.isFromSetting = false
                if cell.startBtn.tag == 1{
                    SystemInfoModel.shared.cgmUnit = 0
                }
                let vc = CGMSelectorVC.instantiate(fromAppStoryboard: .CGPStoryboard)
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                SystemInfoModel.shared.isFromSetting = false
                if cell.startBtn.tag == 1{
                    SystemInfoModel.shared.insulinUnit = 0
                    SystemInfoModel.shared.longInsulinSubType = ""
                    SystemInfoModel.shared.longInsulinType = ""
                }
                let vc = InsulinStep1VC.instantiate(fromAppStoryboard: .SystemSetup)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        self.cellForRowSetUp(indexPath: indexPath,cell:cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if hasTopNotch{
            return UITableView.automaticDimension
        }else{
            return mainTableView.frame.height / 3.0
        }
    }
}

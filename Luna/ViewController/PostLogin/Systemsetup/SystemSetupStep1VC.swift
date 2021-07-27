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
    @IBOutlet weak var doneBtnHeightCost: NSLayoutConstraint!
    @IBOutlet weak var doneBtn: AppButton!
    @IBOutlet weak var manualView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var doneBtnBottmCost: NSLayoutConstraint!
    
    // MARK: - Variables
    //===========================
    var sections: [(String,Bool)] = [("Pair Luna",false),("Link CGM",false),("Insulin Information",false)]
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        manualView.round()
        infoView.round()
        doneBtn.round(radius: 4.0)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func infoBtnTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func manualBtnTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func doneBtnAction(_ sender: AppButton) {
        //MARK:- Need to manage all three case
        AppUserDefaults.save(value: true, forKey: .isSystemSetupCompleted)
        FirestoreController.updateUserSystemSetupStatus(isSystemSetupCompleted: true)
        AppRouter.gotoHomeVC()
    }
    
}

// MARK: - Extension For Functions
//===========================
extension SystemSetupStep1VC {
    
    private func initialSetup() {
        self.addObserver()
        self.tableViewSetup()
        self.doneBtn.isHidden = true
        self.doneBtnBottmCost.constant = 0.0
        self.doneBtnHeightCost.constant = 0.0
        self.progressView.progressTintColor = #colorLiteral(red: 0.2392156863, green: 0.7882352941, blue: 0.5764705882, alpha: 1)
        self.progressView.layer.cornerRadius = 3
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
}

// MARK: - Extension For TableView
//===========================
extension SystemSetupStep1VC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: SystemStep1TableCell.self)
        cell.startBtnTapped = { [weak self] in
            guard let self = self else { return }
            switch indexPath.row {
            case 0:
                let vc = PairLunaVC.instantiate(fromAppStoryboard: .CGPStoryboard)
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = CGMSelectorVC.instantiate(fromAppStoryboard: .CGPStoryboard)
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                let vc = InsulinStep1VC.instantiate(fromAppStoryboard: .SystemSetup)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        switch indexPath.row {
        case 0:
            cell.stepLbl.text = "STEP" + " \(indexPath.row + 1)"
            cell.pairedDeviceImgView.isHidden = !sections[indexPath.row].1
            cell.cgmInsulinDataView.isHidden = true
            cell.titleLbl.text =  sections[indexPath.row].1 ? "Luna Device Paired" : "Pair Luna"
            cell.startBtn.setTitle(sections[indexPath.row].1 ? "Edit" : "Start", for: .normal)
            if sections[indexPath.row].1 {
                cell.startBtn.isEditable = true
            }
            cell.timeDescView.isHidden = sections[indexPath.row].1
        case 1:
            cell.stepLbl.text = "STEP" + " \(indexPath.row + 1)"
            cell.pairedDeviceImgView.isHidden = true
            cell.cgmInsulinDataView.isHidden = !sections[indexPath.row].1
            cell.unitLbl.text = "mg/dL"
            cell.quantityLbl.text = AppUserDefaults.value(forKey: .cgmValue).stringValue
            cell.arrowImgView.isHidden = false
            cell.titleLbl.text =  sections[indexPath.row].1 ? "Dexcom G6" : "Link CGM"
            cell.startBtn.setTitle(sections[indexPath.row].1 ? "Edit" : "Start", for: .normal)
            cell.timeDescView.isHidden = sections[indexPath.row].1
            if sections[indexPath.row].1 {
                cell.startBtn.isEditable = true
            }
        default:
            cell.stepLbl.text = "STEP" + " \(indexPath.row + 1)"
            cell.pairedDeviceImgView.isHidden = true
            cell.cgmInsulinDataView.isHidden = !sections[indexPath.row].1
            cell.unitLbl.text = "per day"
            cell.quantityLbl.text = "8 u"
            cell.arrowImgView.isHidden = true
            cell.titleLbl.text =  sections[indexPath.row].1 ? "Lilly Basaglar" : "Insulin Information"
            cell.startBtn.setTitle(sections[indexPath.row].1 ? "Edit" : "Start", for: .normal)
            cell.timeDescView.isHidden = sections[indexPath.row].1
            if sections[indexPath.row].1 {
                cell.startBtn.isEditable = true
            }
        }
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

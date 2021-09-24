//
//  CGMSelectorVC.swift
//  Luna
//
//  Created by Admin on 06/07/21.
//

import UIKit

class CGMSelectorVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var introLbl: UILabel!
    @IBOutlet weak var cgmTypesTV: UITableView!
    @IBOutlet weak var proceedBtn: AppButton!
    var vcObj:UIViewController = UIViewController()
    
    // MARK: - Variables
    //===========================
    var CGMTypeArray = [LocalizedString.dexcomG6.localized,LocalizedString.dexcomG7.localized,LocalizedString.freestyle_Libre2.localized,LocalizedString.freestyle_Libre3.localized]

    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
        overrideUserInterfaceStyle = .light
        }
        self.proceedBtn.isEnabled = true
        initialSetup()
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
    
    // MARK: - IBActions
    //===========================
    @IBAction func proceedBtnAction(_ sender: UIButton) {
        SystemInfoModel.shared.cgmType =  CGMTypeArray.first ?? ""
        self.proceedBtn.isEnabled = true
        let vc = CGMLoginVC.instantiate(fromAppStoryboard: .CGPStoryboard)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.pop()
    }

}


// MARK: - Extension For Functions
//===========================
extension CGMSelectorVC {
    
    private func initialSetup() {
        cgmTypesTV.isHidden = false
        self.proceedBtn.round(radius: 10.0)
        self.proceedBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        self.introLbl.textColor = AppColors.fontPrimaryColor
        cgmTypesTV.registerCell(with: CGMTypeTableViewCell.self)
        cgmTypesTV.delegate = self
        cgmTypesTV.dataSource = self
        cgmTypesTV.reloadData()
    }
    
}


// MARK: - Extension For TableView
//===========================
extension CGMSelectorVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(CGMTypeArray.count)
        return CGMTypeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: CGMTypeTableViewCell.self)
        cell.subTitlelbl.text = CGMTypeArray[indexPath.row]
        if indexPath.row == 0{
            cell.nextBtn.setImage(UIImage(named: "Radio_selected"), for: .normal)
            cell.subTitlelbl.textColor = UIColor.black
            cell.outerView.layer.borderColor = AppColors.appGreenColor.cgColor
        }
        else{
            cell.nextBtn.setImage(UIImage(named: "Radio_unselected"), for: .normal)
            cell.subTitlelbl.textColor = AppColors.fontPrimaryColor
            cell.outerView.layer.borderColor = AppColors.fontPrimaryColor.cgColor
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

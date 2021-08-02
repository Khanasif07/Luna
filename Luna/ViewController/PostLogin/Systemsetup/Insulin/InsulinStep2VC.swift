//
//  InsulinStep2VC.swift
//  Luna
//
//  Created by Admin on 06/07/21.
//

import UIKit

class InsulinStep2VC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var selectBtn: AppButton!
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    var sections: [(String,Bool,String,UIImage)] = [("Basaglar",false,"Lilly",#imageLiteral(resourceName: "basaglar")),("Lantus",false,"Sanofi",#imageLiteral(resourceName: "lantus")),("Levemir",false,"Novo Nordisk",#imageLiteral(resourceName: "levemir")),("Toujeo",false,"Sanofi",#imageLiteral(resourceName: "toujeo")),("Toujeo Max",false,"Sanofi",#imageLiteral(resourceName: "toujeoMax")),("Tresiba",false,"Novo Nordisk",#imageLiteral(resourceName: "tresiba"))]
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
        overrideUserInterfaceStyle = .light
        }
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        selectBtn.round(radius: 8.0)
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
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func selectBtnTapped(_ sender: AppButton) {
        let vc = InsulinStep3VC.instantiate(fromAppStoryboard: .SystemSetup)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

// MARK: - Extension For Functions
//===========================
extension InsulinStep2VC {
    
    private func initialSetup() {
        self.tableViewSetup()
        self.setData()
    }
    
    private func tableViewSetup(){
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.registerCell(with: InsulinStep2Cell.self)
        self.selectBtn.isEnabled = false
    }
    
    private func setData(){
        if let index = self.sections.firstIndex(where: { (tupls) -> Bool in
            tupls.0 == SystemInfoModel.shared.longInsulinType
        }){
            self.sections[index].1 = true
            self.selectBtn.isEnabled = true
            self.mainTableView.reloadData()
        }
    }
    

}

// MARK: - Extension For TableView
//===========================
// MARK: - Extension For TableView
//===========================
extension InsulinStep2VC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: InsulinStep2Cell.self)
        cell.insulinType.text = sections[indexPath.row].0
        cell.insulinSubType.text = sections[indexPath.row].2
        cell.logoImgView.image = sections[indexPath.row].3
        cell.dataContainerView.setBorder(width: 1.0, color: !sections[indexPath.row].1 ? AppColors.fontPrimaryColor : AppColors.appGreenColor)
        cell.radioBtn.isSelected = sections[indexPath.row].1
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectBtn.isEnabled = true
        if let selectedIndex = sections.firstIndex(where: { (tupls) -> Bool in
            return tupls.1 == true
        }){
            self.sections[selectedIndex].1 = false
            self.sections[indexPath.row].1 = true
            SystemInfoModel.shared.longInsulinType =  self.sections[indexPath.row].0
            SystemInfoModel.shared.longInsulinSubType =  self.sections[indexPath.row].2
            SystemInfoModel.shared.longInsulinImage =  self.sections[indexPath.row].3
            self.mainTableView.reloadData()
        }else{
            self.sections[indexPath.row].1 = true
            SystemInfoModel.shared.longInsulinType =  self.sections[indexPath.row].0
            SystemInfoModel.shared.longInsulinSubType =  self.sections[indexPath.row].2
            SystemInfoModel.shared.longInsulinImage =  self.sections[indexPath.row].3
            self.mainTableView.reloadData()
        }
    }
}


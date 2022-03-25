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
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var selectBtn: AppButton!
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    var sections: [(String,Bool,String,UIImage)] = [("Levemir",false,"Novo Nordisk",#imageLiteral(resourceName: "levemir")),
                                                    ("Tresiba",false,"Novo Nordisk",#imageLiteral(resourceName: "tresiba")),
                                                    ("Basaglar",false,"Lilly",#imageLiteral(resourceName: "basaglar")),
                                                    ("Lantus",false,"Sanofi",#imageLiteral(resourceName: "lantus")),
                                                    ("Toujeo",false,"Sanofi",#imageLiteral(resourceName: "toujeo")),
                                                    ("Toujeo Max",false,"Sanofi",#imageLiteral(resourceName: "toujeoMax"))]
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        selectBtn.round(radius: 8.0)
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
        self.mainTableView.tableHeaderView = headerView
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
extension InsulinStep2VC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: InsulinStep2Cell.self)
        cell.configureCell(model: sections[indexPath.row])
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


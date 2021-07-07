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
    var sections: [(String,Bool)] = [("Pair Luna",false),("Pair Luna",false),("Pair Luna",false),("Pair Luna",false),("Pair Luna",false),("Pair Luna",false)]
    
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
        self.selectBtn.isEnabled = false
    }
    
    private func tableViewSetup(){
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.registerCell(with: InsulinStep2Cell.self)
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
            self.mainTableView.reloadData()
        }else{
            self.sections[indexPath.row].1 = true
            self.mainTableView.reloadData()
        }
    }
}


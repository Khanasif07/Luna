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
    var sections: [String] = ["Pair Luna","Link CGM","Insulin Information","Pair Luna","Link CGM","Insulin Information","Pair Luna","Link CGM","Insulin Information"]
    
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
        self.selectBtn.isEnabled = true
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
//        cell.titleLbl.text = sections[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2:
            showAlert(msg: "Under Development")
        default:
            showAlert(msg: "Under Development")
        }
    }
}


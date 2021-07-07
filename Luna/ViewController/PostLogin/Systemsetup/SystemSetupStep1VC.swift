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
    @IBOutlet weak var manualView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var progressView: UIProgressView!
    
    // MARK: - Variables
    //===========================
    var sections: [String] = ["Pair Luna","Link CGM","Insulin Information"]
    
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
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func infoBtnTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func manualBtnTapped(_ sender: UIButton) {
        
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension SystemSetupStep1VC {
    
    private func initialSetup() {
        self.tableViewSetup()
        self.progressView.progressTintColor = #colorLiteral(red: 0.2392156863, green: 0.7882352941, blue: 0.5764705882, alpha: 1)
        self.progressView.layer.cornerRadius = 3
        self.progressView.clipsToBounds = true
        // Set the rounded edge for the inner bar
        self.progressView.layer.sublayers![1].cornerRadius = 3
        self.progressView.subviews[1].clipsToBounds = true
        CommonFunctions.delay(delay: 2.0) {
            self.progressView.setProgress(0.25, animated: true)
        }
    }
    
    private func tableViewSetup(){
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.registerCell(with: SystemStep1TableCell.self)
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
        cell.titleLbl.text = sections[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2:
            let vc = InsulinStep1VC.instantiate(fromAppStoryboard: .SystemSetup)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            showAlert(msg: "Under Development")
        }
    }
}

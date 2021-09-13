//
//  SettingManualVC.swift
//  Luna
//
//  Created by Admin on 28/07/21.
//


import UIKit

class SettingManualVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    
    @IBOutlet weak var aboutTableView: UITableView!
    @IBOutlet weak var backView: UIView!
    
    // MARK: - Variables
    //===========================
    var sections: [(UIImage,String,String,Bool)] = [(#imageLiteral(resourceName: "charge"),LocalizedString.how_to_charge_Luna.localized,"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut bibendum consectetur libero, vel convallis arcu pretium a. ",false),(#imageLiteral(resourceName: "pair"),LocalizedString.how_to_pair_Luna.localized,"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut bibendum consectetur libero, vel convallis arcu pretium a. ",false),(#imageLiteral(resourceName: "reservoir"),LocalizedString.how_to_fill_and_apply_your_Insulin.localized,"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut bibendum consectetur libero, vel convallis arcu pretium a. ",false),(#imageLiteral(resourceName: "cgm"),LocalizedString.how_to_connect_your_CGM.localized,"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut bibendum consectetur libero, vel convallis arcu pretium a. ",false)]
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backView.round()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func backBtnAction(_ sender: Any) {
        self.pop()
    }
    
}

// MARK: - Extension For Functions
//===========================
extension SettingManualVC {
    
    private func initialSetup() {
        if #available(iOS 13.0, *) {
        overrideUserInterfaceStyle = .light
        }
        self.tableViewSetup()
    }
    
    private func tableViewSetup(){
        self.aboutTableView.delegate = self
        self.aboutTableView.dataSource = self
        self.aboutTableView.registerCell(with: SettingManualCell.self)
    }
}

// MARK: - Extension For TableView
//===========================
extension SettingManualVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: SettingManualCell.self)
        cell.ansLbl.isHidden = !sections[indexPath.row].3
        cell.queLbl.text = sections[indexPath.row].1
        cell.ansLbl.text = sections[indexPath.row].2
        cell.logoBtn.setImage(sections[indexPath.row].0, for: .normal)
        cell.arrowBtn.setImage(sections[indexPath.row].3 ? #imageLiteral(resourceName: "uparrow") : #imageLiteral(resourceName: "dropdown") , for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sections[indexPath.row].3 =   !self.sections[indexPath.row].3
        self.aboutTableView.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .fade)
    }
}

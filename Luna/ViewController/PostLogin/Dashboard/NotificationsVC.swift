//
//  NotificationsVC.swift
//  Luna
//
//  Created by Admin on 10/01/22.
//

import UIKit

class NotificationsVC : UIViewController{
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet var notiTableView: UITableView!
    @IBOutlet var titleLbl: UILabel!
    // MARK: - Variables
    //===========================
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func backBtnAction(sender: UIButton){
        self.pop()
    }
    
}

// MARK: - Extension For Functions
//===========================
extension NotificationsVC {
    
    private func initialSetup() {
        self.tableViewSetup()
    }
    
    private func tableViewSetup(){
        self.notiTableView.delegate = self
        self.notiTableView.dataSource = self
        self.notiTableView.registerHeaderFooter(with: SettingHeaderView.self)
        self.notiTableView.registerCell(with: NotificationsCell.self)
    }
}

// MARK: - Extension For TableView
//===========================
extension NotificationsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: NotificationsCell.self)
//        cell.titleLbl.text = sections[indexPath.section].1
//        cell.logoImgView.image = sections[indexPath.section].0
//        cell.nextBtn.isHidden = false
//        cell.switchView.isHidden = true
        return cell
    }
}

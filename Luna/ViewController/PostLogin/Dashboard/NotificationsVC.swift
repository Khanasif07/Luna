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
    var notificationListing = [NotificationModel]()
    
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
        self.getNotificationListing()
    }
    
    private func tableViewSetup(){
        self.notiTableView.delegate = self
        self.notiTableView.dataSource = self
//        self.notiTableView.registerHeaderFooter(with: SettingHeaderView.self)
//        self.notiTableView.registerCell(with: NotificationsCell.self)
    }
    
    private func getNotificationListing(){
        CommonFunctions.showActivityLoader()
        FirestoreController.getNotificationData { (notiListing) in
            self.notificationListing = notiListing
            self.notiTableView.reloadData()
            CommonFunctions.hideActivityLoader()
            FirestoreController.deleteNotificationDataOlderThanWeek {
                print("OneWeekOldNotificationDeleted.")
            }
        } failure: { (error) -> (Void) in
            CommonFunctions.showToastWithMessage("No Notification data available.")
            CommonFunctions.hideActivityLoader()
        }
    }
}

// MARK: - Extension For TableView
//===========================
extension NotificationsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationListing.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueCell(with: NotificationsCell.self)
        //        cell.populateCell(model: self.notificationListing[indexPath.row])
        //        return cell
        NotificationRowViewCell(model: self.notificationListing[indexPath.row])
    }
}

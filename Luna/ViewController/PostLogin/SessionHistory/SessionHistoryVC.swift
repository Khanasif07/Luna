//
//  SessionHistoryVC.swift
//  Luna
//
//  Created by Admin on 08/07/21.
//

import UIKit

class SessionHistoryVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var sessionHistoryTV: UITableView!
    
    // MARK: - Variables
    //===========================
    var insulinSectionDataArray : [(Int,[SessionHistory])] = []
    var sessionHistory = [SessionHistory]()
    var startdate: Date?
    var enddate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func filterBtnTapped(_ sender: AppButton) {
        let vc = SessionFilterVC.instantiate(fromAppStoryboard: .CGPStoryboard)
        vc.delegate = self
        vc.startdate = startdate
        vc.enddate = enddate
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func crossBtnTapped(_ sender: AppButton) {
        self.pop()
    }
}

// MARK: - Extension For Functions
//===========================
extension SessionHistoryVC {
    
    private func initialSetup() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.sessionHistoryTV.registerCell(with: SessionHistoryTableViewCell.self)
        self.sessionHistoryTV.delegate = self
        self.sessionHistoryTV.dataSource = self
        self.getSessionHistoryData()
    }
    
    private func getSessionHistoryData(){
        CommonFunctions.showActivityLoader()
        CommonFunctions.delay(delay: 10.0) {
            CommonFunctions.hideActivityLoader()
        }
        FirestoreController.getFirebaseSessionHistoryData{ (dataArray) in
            self.sessionHistory = dataArray
            self.sessionHistory.forEach({ (data) in
                let month = data.startDate.getMonthInterval()
                if self.insulinSectionDataArray.contains(where: {$0.0 == month}){
                    if let selectedIndex = self.insulinSectionDataArray.firstIndex(where: {$0.0 == month}){
                        self.insulinSectionDataArray[selectedIndex].1.append(data)
                    }
                } else {
                    self.insulinSectionDataArray.append((month, [data]))
                }
            })
            self.insulinSectionDataArray = self.insulinSectionDataArray.reversed()
//            self.insulinSectionDataArray = self.insulinSectionDataArray.
            self.sessionHistoryTV.reloadData()
            CommonFunctions.hideActivityLoader()
        }failure: {
            CommonFunctions.showToastWithMessage("No Session History data available.")
            CommonFunctions.hideActivityLoader()
        }
    }
    
    
}


// MARK: - Extension For TableView
//===========================
extension SessionHistoryVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.insulinSectionDataArray.endIndex
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.insulinSectionDataArray[section].1.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueCell(with: SessionHistoryTableViewCell.self)
        cell.configureCellData(model: self.insulinSectionDataArray[indexPath.section].1[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = Bundle.main.loadNibNamed("SessionHistoryHeader", owner: self, options: nil)?.first as! SessionHistoryHeader
        sectionHeaderView.month =  self.insulinSectionDataArray[section].0
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  let cell = tableView.cellForRow(at: indexPath) as? SessionHistoryTableViewCell {
            let vc = SessionDescriptionVC.instantiate(fromAppStoryboard: .CGPStoryboard)
            vc.sessionModel = self.insulinSectionDataArray[indexPath.section].1[indexPath.row]
            vc.titleValue = cell.dateLbl.text ?? ""
            vc.sessionStartDate = self.insulinSectionDataArray[indexPath.section].1[indexPath.row].startDate
            vc.sessionEndDate = self.insulinSectionDataArray[indexPath.section].1[indexPath.row].endDate
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

 //MARK: - SessionFilterVCDelegate
//=====================================
extension SessionHistoryVC: SessionFilterVCDelegate{
    func filterApplied(startDate: Date?, endDate: Date?) {
        if let selectedStartDate = startDate{
            self.startdate = selectedStartDate
        }
        if let selectedEndDate = endDate{
            self.enddate = selectedEndDate
        }
        let output = self.sessionHistory.filter { (NSDate(timeIntervalSince1970: TimeInterval($0.startDate)) as Date) >= self.startdate! && (NSDate(timeIntervalSince1970: TimeInterval($0.startDate)) as Date) <= self.enddate! }
        self.insulinSectionDataArray = []
        output.forEach({ (data) in
            let month = data.startDate.getMonthInterval()
            if self.insulinSectionDataArray.contains(where: {$0.0 == month}){
                if let selectedIndex = self.insulinSectionDataArray.firstIndex(where: {$0.0 == month}){
                    self.insulinSectionDataArray[selectedIndex].1.append(data)
                }
            } else {
                self.insulinSectionDataArray.append((month, [data]))
            }
        })
        self.insulinSectionDataArray = self.insulinSectionDataArray.reversed()
        self.sessionHistoryTV.reloadData()
    }
    
    func resetFilter() {
        self.startdate = nil
        self.enddate = nil
        self.insulinSectionDataArray = []
        self.sessionHistory.forEach({ (data) in
            let month = data.startDate.getMonthInterval()
            if self.insulinSectionDataArray.contains(where: {$0.0 == month}){
                if let selectedIndex = self.insulinSectionDataArray.firstIndex(where: {$0.0 == month}){
                    self.insulinSectionDataArray[selectedIndex].1.append(data)
                }
            } else {
                self.insulinSectionDataArray.append((month, [data]))
            }
        })
        self.insulinSectionDataArray = self.insulinSectionDataArray.reversed()
        self.sessionHistoryTV.reloadData()
    }
}

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
    var insulinSectionDataArray : [(String,[SessionHistory])] = []
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
        self.setUpTableView()
        CommonFunctions.showActivityLoader()
        FirestoreController.getNetworkStatus { (isNetworkAvailable) in
            self.getSessionHistoryData(isNetworkAvailable)
        }
    }
    
    private func setUpTableView(){
        self.sessionHistoryTV.registerCell(with: SessionHistoryTableViewCell.self)
        self.sessionHistoryTV.delegate = self
        self.sessionHistoryTV.dataSource = self
    }
    
    private func getSessionHistoryData(_ isNetworkAvailable: Bool){
        FirestoreController.getFirebaseSessionHistoryData(isNetworkAvailable: isNetworkAvailable) { (sessionHistoryArray) in
            self.insulinSectionDataArray  = []
            self.sessionHistory = sessionHistoryArray
            self.sessionHistory = self.sessionHistory.sorted(by: { $0.startDate > $1.startDate})
            self.sessionHistory.forEach({ (data) in
                let month = data.startDate.getMonthInterval()
                if self.insulinSectionDataArray.contains(where: {$0.0 == month}){
                    if let selectedIndex = self.insulinSectionDataArray.firstIndex(where: {$0.0 == data.title}){
                        self.insulinSectionDataArray[selectedIndex].1.append(data)
                    }else{
                        self.insulinSectionDataArray.append((data.title, [data]))
                    }
                } else {
                    self.insulinSectionDataArray.append((month, []))
                    self.insulinSectionDataArray.append((data.title, [data]))
                }
            })
            self.insulinSectionDataArray = self.insulinSectionDataArray.map({ (tuples) -> (String,[SessionHistory]) in
                return (tuples.0,tuples.1.reversed())
            })
            self.sessionHistoryTV.reloadData()
            CommonFunctions.hideActivityLoader()
        }failure: {
            CommonFunctions.showToastWithMessage(LocalizedString.no_session_history_data_available.localized)
            CommonFunctions.hideActivityLoader()
        }
    }
}


// MARK: - Extension For TableView
//===========================
extension SessionHistoryVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.insulinSectionDataArray.count == 0 {
            self.sessionHistoryTV.setEmptyMessage(LocalizedString.no_session_history_data_available.localized)
        } else {
            self.sessionHistoryTV.restore()
        }
        return self.insulinSectionDataArray.endIndex
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.insulinSectionDataArray[section].1.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueCell(with: SessionHistoryTableViewCell.self)
        cell.configureCellData(model: self.insulinSectionDataArray[indexPath.section].1[indexPath.row])
        return cell
//          SessionHistoryRowViewCell(model: self.insulinSectionDataArray[indexPath.section].1[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = Bundle.main.loadNibNamed("SessionHistoryHeader", owner: self, options: nil)?.first as! SessionHistoryHeader
        sectionHeaderView.month =  self.insulinSectionDataArray[section].0
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SessionDescriptionVC.instantiate(fromAppStoryboard: .CGPStoryboard)
        vc.sessionModel = self.insulinSectionDataArray[indexPath.section].1[indexPath.row]
        vc.titleValue = self.insulinSectionDataArray[indexPath.section].1[indexPath.row].title
        vc.sessionStartDate = self.insulinSectionDataArray[indexPath.section].1[indexPath.row].startDate
        vc.sessionEndDate = self.insulinSectionDataArray[indexPath.section].1[indexPath.row].endDate
        navigationController?.pushViewController(vc, animated: true)
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
                if let selectedIndex = self.insulinSectionDataArray.firstIndex(where: {$0.0 == data.title}){
                    self.insulinSectionDataArray[selectedIndex].1.append(data)
                }else{
                    self.insulinSectionDataArray.append((data.title, [data]))
                }
            } else {
                self.insulinSectionDataArray.append((month, []))
                self.insulinSectionDataArray.append((data.title, [data]))
            }
        })
        self.insulinSectionDataArray = self.insulinSectionDataArray.map({ (tuples) -> (String,[SessionHistory]) in
            return (tuples.0,tuples.1.reversed())
        })
        self.sessionHistoryTV.reloadData()
    }
    
    func resetFilter() {
        self.startdate = nil
        self.enddate = nil
        self.insulinSectionDataArray = []
        self.sessionHistory.forEach({ (data) in
            let month = data.startDate.getMonthInterval()
            if self.insulinSectionDataArray.contains(where: {$0.0 == month}){
                if let selectedIndex = self.insulinSectionDataArray.firstIndex(where: {$0.0 == data.title}){
                    self.insulinSectionDataArray[selectedIndex].1.append(data)
                }else{
                    self.insulinSectionDataArray.append((data.title, [data]))
                }
            } else {
                self.insulinSectionDataArray.append((month, []))
                self.insulinSectionDataArray.append((data.title, [data]))
            }
        })
        self.insulinSectionDataArray = self.insulinSectionDataArray.map({ (tuples) -> (String,[SessionHistory]) in
            return (tuples.0,tuples.1.reversed())
        })
        self.sessionHistoryTV.reloadData()
    }
}

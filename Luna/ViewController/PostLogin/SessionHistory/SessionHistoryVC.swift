//
//  SessionHistoryVC.swift
//  Luna
//
//  Created by Admin on 08/07/21.
//

import UIKit

class SessionHistoryVC: UIViewController {
    
    @IBOutlet weak var SessionHistoryTV: UITableView!
    
    var insulinSectionDataArray : [(Int,[ShareGlucoseData])] = []
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
        CommonFunctions.showActivityLoader()
        self.getInsulinData()
        SessionHistoryTV.register(UINib(nibName: "SessionHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "SessionHistoryTableViewCell")
        SessionHistoryTV.delegate = self
        SessionHistoryTV.dataSource = self
    }
    
    private func getInsulinData(){
//        FirestoreController.getFirebaseInsulinData { (insulinDataArray) in
//            print(insulinDataArray)
//            SystemInfoModel.shared.insulinData = insulinDataArray
//            SystemInfoModel.shared.insulinData?.forEach({ (dataModel) in
//                let month = dataModel.date.getMonthInterval()
//                if self.insulinSectionDataArray.contains(where: {$0.0 == month}){
//                    if let selectedIndex = self.insulinSectionDataArray.firstIndex(where: {$0.0 == month}){
//                        self.insulinSectionDataArray[selectedIndex].1.append(dataModel)
//                    }
//                } else {
//                    self.insulinSectionDataArray.append((month, [dataModel]))
//                }
//            })
//            self.SessionHistoryTV.reloadData()
//            CommonFunctions.hideActivityLoader()
//        } failure: { (error) -> (Void) in
//            CommonFunctions.showToastWithMessage(error.localizedDescription)
//            CommonFunctions.hideActivityLoader()
//        }
        FirestoreController.getFirebaseCGMData { (cgmDataArray) in
            print(cgmDataArray)
            SystemInfoModel.shared.cgmData = cgmDataArray
            SystemInfoModel.shared.cgmData?.forEach({ (dataModel) in
                let month = dataModel.date.getMonthInterval()
                if self.insulinSectionDataArray.contains(where: {$0.0 == month}){
                    if let selectedIndex = self.insulinSectionDataArray.firstIndex(where: {$0.0 == month}){
                        self.insulinSectionDataArray[selectedIndex].1.append(dataModel)
                    }
                } else {
                    self.insulinSectionDataArray.append((month, [dataModel]))
                }
            })
            self.SessionHistoryTV.reloadData()
            CommonFunctions.hideActivityLoader()
        } failure: { (error) -> (Void) in
            CommonFunctions.showToastWithMessage(error.localizedDescription)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SessionHistoryTableViewCell = SessionHistoryTV.dequeueReusableCell(withIdentifier: "SessionHistoryTableViewCell", for: indexPath) as! SessionHistoryTableViewCell
        cell.dateLbl.text  = self.insulinSectionDataArray[indexPath.section].1[indexPath.row].date.getDateTimeFromTimeInterval("MM/dd")
        cell.unitLbl.text = "7 units delivered" + " | " + "0% in range"
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
            vc.titleValue = cell.dateLbl.text ?? ""
            vc.insulinDataModel = self.insulinSectionDataArray[indexPath.section].1[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension SessionHistoryVC: SessionFilterVCDelegate{
    func filterApplied(startDate: Date?, endDate: Date?) {
        self.startdate = startDate!
        self.enddate = endDate!
        let output = SystemInfoModel.shared.cgmData?.filter { (NSDate(timeIntervalSince1970: TimeInterval($0.date)) as Date) >= self.startdate! && (NSDate(timeIntervalSince1970: TimeInterval($0.date)) as Date) <= self.enddate! }
        self.insulinSectionDataArray = []
        output?.forEach({ (dataModel) in
            let month = dataModel.date.getMonthInterval()
            if self.insulinSectionDataArray.contains(where: {$0.0 == month}){
                if let selectedIndex = self.insulinSectionDataArray.firstIndex(where: {$0.0 == month}){
                    self.insulinSectionDataArray[selectedIndex].1.append(dataModel)
                }
            } else {
                self.insulinSectionDataArray.append((month, [dataModel]))
            }
        })
        self.SessionHistoryTV.reloadData()
    }
    
    func resetFilter() {
        self.startdate = nil
        self.enddate = nil
        SystemInfoModel.shared.cgmData?.forEach({ (dataModel) in
            let month = dataModel.date.getMonthInterval()
            if self.insulinSectionDataArray.contains(where: {$0.0 == month}){
                if let selectedIndex = self.insulinSectionDataArray.firstIndex(where: {$0.0 == month}){
                    self.insulinSectionDataArray[selectedIndex].1.append(dataModel)
                }
            } else {
                self.insulinSectionDataArray.append((month, [dataModel]))
            }
        })
        self.SessionHistoryTV.reloadData()
    }
}

//
//  SessionDescriptionVC.swift
//  Luna
//
//  Created by Admin on 08/07/21.
//

import UIKit
import KDCircularProgress

class SessionDescriptionVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var rangePerValueLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var lowestGlucoseLbl: UILabel!
    @IBOutlet weak var highestGlucoseLbl: UILabel!
    @IBOutlet weak var insulinQty: UILabel!
    @IBOutlet weak var progress: KDCircularProgress!
    @IBOutlet weak var topNavView: UIView!
    @IBOutlet weak var mainTaeView: UITableView!
    
    // MARK: - Variables
    //==========================
    var sections = ["Glucose Graph","List View"]
    var sessionModel : SessionHistory?
    var sessionStartDate : Double?
    var sessionEndDate : Double?
    var titleValue: String = ""
    var cgmDataArray : [ShareGlucoseData] = []
    var insulinDataArray : [ShareGlucoseData]?
    var filterInsulinDataArray: [ShareGlucoseData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.titleLbl.text = titleValue
        self.setupTableView()
        self.setupProgressBar()
        self.getCgmDataFromFirestore()
        CommonFunctions.delay(delay: 2.5) {
            CommonFunctions.hideActivityLoader()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mainTaeView.reloadData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.pop()
    }
    
    private func setupProgressBar(){
        progress.startAngle = -90
        progress.progressThickness = 0.25
        progress.trackThickness = 0.25
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = true
        progress.glowMode = .forward
        progress.glowAmount = 0.9
        progress.set(colors: #colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1))
        progress.trackColor = #colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9176470588, alpha: 1)
        rangePerValueLbl.text = "\(Int(self.sessionModel?.range ?? 0.0))%"
        progress.progress = (sessionModel?.range ?? 0.0) / 100.0
    }
    
    private func setupTableView(){
        self.mainTaeView.delegate = self
        self.mainTaeView.dataSource = self
        self.mainTaeView.registerHeaderFooter(with: SessionHistoryHeader.self)
        self.mainTaeView.registerCell(with: BottomSheetChartCell.self)
        self.mainTaeView.registerCell(with: BottomSheetBottomCell.self)
    }
    
    private func getRangeValue(isShowPer: Bool = false)-> Double{
        if self.cgmDataArray.endIndex > 0 {
            let rangeArray = self.cgmDataArray.filter { (glucoseValue) -> Bool in
                return glucoseValue.sgv >= Int((UserDefaultsRepository.lowLine.value)) && glucoseValue.sgv <= Int((UserDefaultsRepository.highLine.value))
            }
            if isShowPer {
                let rangePercentValue = ((100 * (rangeArray.endIndex)) / (self.cgmDataArray.endIndex))
                return Double(rangePercentValue)
            } else {
                let rangePercentValue = (Double(rangeArray.endIndex) / Double(self.cgmDataArray.endIndex))
                return rangePercentValue
            }
        }
        return 0.0
    }
    
    private func filterInsulinDosesListing(){
        let filteredInsulinArray =  self.cgmDataArray.filter({$0.insulin == "0.5" || $0.insulin == "0.25" || $0.insulin == "0.75"})
        self.insulinDataArray = filteredInsulinArray
        self.filterInsulinDataArray = self.insulinDataArray?.filter({ (bgData) -> Bool in
            return bgData.insulin == "0.5"
        }).sorted(by: {$0.date > $1.date})
        if filterInsulinDataArray?.endIndex ?? 0 > 0 {
            self.sections = ["Glucose Graph","List View"]
            if let insulinUnitValue = filterInsulinDataArray?.endIndex{
                self.insulinQty.text = "\(Double(insulinUnitValue) / 2) units"
            }
        }else{
            self.sections = ["Glucose Graph"]
            self.insulinQty.text = "0 units"
        }
    }
    
    private func getCgmDataFromFirestore(){
        CommonFunctions.showActivityLoader()
        FirestoreController.getFirebaseCGMData(sessionId: sessionModel?.sessionId ?? "",startDate: sessionStartDate ?? 0.0,endDate: sessionEndDate ?? 0.0) { (bgData) in
            CommonFunctions.hideActivityLoader()
            self.cgmDataArray = bgData
            self.filterInsulinDosesListing()
            let sortedCgmData = bgData.sorted(by: { (model1, model2) -> Bool in
                return model1.sgv < model2.sgv
            })
            self.lowestGlucoseLbl.text = "\(sortedCgmData.first?.sgv ?? 0)" + " \(UserDefaultsRepository.units.value)"
            self.highestGlucoseLbl.text = "\(sortedCgmData.last?.sgv ?? 0)" + " \(UserDefaultsRepository.units.value)"
            self.progress.progress = Double(self.getRangeValue())
            self.mainTaeView.reloadData()
        } failure: { (error) -> (Void) in
            print(error)
            CommonFunctions.hideActivityLoader()
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
//===========================
extension SessionDescriptionVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.endIndex
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ?  1 :  (self.filterInsulinDataArray?.endIndex ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueCell(with: BottomSheetChartCell.self)
            cell.insulinData = insulinDataArray?.reversed() ?? []
            cell.cgmData = self.cgmDataArray
            return cell
        default:
            let cell = tableView.dequeueCell(with: BottomSheetBottomCell.self)
            if let insulinData = self.filterInsulinDataArray {
                cell.populateCellForCGMModel(model:insulinData[indexPath.row])
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueHeaderFooter(with: SessionHistoryHeader.self)
        view.haedingLbl.text = sections[section]
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}

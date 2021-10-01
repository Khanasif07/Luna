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
//    var insulinDataModel : ShareGlucoseData?
    var sessionDay : Double?
    var titleValue: String = ""
    var cgmDataArray : [ShareGlucoseData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        titleLbl.text = titleValue
        setupTableView()
        setupProgressBar()
        FirestoreController.getFirebaseCGMData(date: sessionDay!) { (bgData) in
            self.cgmDataArray = bgData
            self.insulinQty.text = "-- units"
            let sortedCgmData = bgData.sorted(by: { (model1, model2) -> Bool in
                return model1.sgv < model2.sgv
            })
            self.lowestGlucoseLbl.text = "\(sortedCgmData.first?.sgv ?? 0)" + " mg/dl"
            self.highestGlucoseLbl.text = "\(sortedCgmData.last?.sgv ?? 0)" + " mg/dl"
            self.mainTaeView.reloadData()
        } failure: { (error) -> (Void) in
            print(error)
        }

//        if let selectedDate = insulinDataModel?.date{
//            let selectedLastDate = Calendar.current.date(byAdding: .minute, value: 5, to: (NSDate(timeIntervalSince1970: TimeInterval(selectedDate)) as Date))
//            let output = SystemInfoModel.shared.cgmData?.filter { (NSDate(timeIntervalSince1970: TimeInterval($0.date)) as Date) >= (NSDate(timeIntervalSince1970: TimeInterval(selectedDate)) as Date) && (NSDate(timeIntervalSince1970: TimeInterval($0.date)) as Date) <= selectedLastDate! }
//            cgmData = output ?? []
            
//        }
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.pop()
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
        progress.progress = 0
//        progress.animate(fromAngle:  -90, toAngle: -90, duration: 2.0) { (success) in
//            print(success)
//            self.progress.pauseAnimation()
//        }
    }
    
    private func setupTableView(){
        self.mainTaeView.delegate = self
        self.mainTaeView.dataSource = self
        self.mainTaeView.registerHeaderFooter(with: SessionHistoryHeader.self)
        self.mainTaeView.registerCell(with: BottomSheetChartCell.self)
        self.mainTaeView.registerCell(with: BottomSheetBottomCell.self)
    }
}


extension SessionDescriptionVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ?  1 :  0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueCell(with: BottomSheetChartCell.self)
            cell.cgmData = self.cgmDataArray
            return cell
        default:
            let cell = tableView.dequeueCell(with: BottomSheetBottomCell.self)
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

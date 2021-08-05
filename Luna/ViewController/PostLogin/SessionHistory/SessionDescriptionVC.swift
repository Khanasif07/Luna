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
    @IBOutlet weak var lowestGlucoseLbl: UILabel!
    @IBOutlet weak var highestGlucoseLbl: UILabel!
    @IBOutlet weak var insulinQty: UILabel!
    @IBOutlet weak var progress: KDCircularProgress!
    @IBOutlet weak var topNavView: UIView!
    @IBOutlet weak var mainTaeView: UITableView!
    
    // MARK: - Variables
    //==========================
    var sections = ["Glucose Graph","List View"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        setupTableView()
        setupProgressBar()
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
        progress.progress = 0.7
        progress.animate(fromAngle:  -90, toAngle: -90, duration: 2.0) { (success) in
            print(success)
            self.progress.pauseAnimation()
        }
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
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 5
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueCell(with: BottomSheetChartCell.self)
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

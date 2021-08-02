//
//  CGMSelectorVC.swift
//  Luna
//
//  Created by Admin on 06/07/21.
//

import UIKit

class CGMSelectorVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var IntroLbl: UILabel!
    @IBOutlet weak var CGMTypesTV: UITableView!
    @IBOutlet weak var proceedBtn: AppButton!
    var vcObj:UIViewController = UIViewController()
    
    // MARK: - Variables
    //===========================
    
    var CGMTypeArray = ["Dexcom G6","Dexcom G7","Freestyle Libre 2","Freestyle Libre 3"]

    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
        overrideUserInterfaceStyle = .light
        }
        self.proceedBtn.isEnabled = true
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
    
    // MARK: - IBActions
    //===========================
    @IBAction func proceedBtnAction(_ sender: UIButton) {
        SystemInfoModel.shared.cgmType =  CGMTypeArray.first ?? ""
        self.proceedBtn.isEnabled = true
        let vc = CGMLoginVC.instantiate(fromAppStoryboard: .CGPStoryboard)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.pop()
    }

}


// MARK: - Extension For Functions
//===========================
extension CGMSelectorVC {
    
    private func initialSetup() {
       // btmContainerView.setBorder(width: 1.0, color: #colorLiteral(red: 0.9607843137, green: 0.5450980392, blue: 0.262745098, alpha: 1))
        CGMTypesTV.isHidden = false
        
        self.proceedBtn.layer.cornerRadius = 10
        self.proceedBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
     
        self.IntroLbl.textColor = AppColors.fontPrimaryColor
        
        
        CGMTypesTV.register(UINib(nibName: "CGMTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "CGMTypeTableViewCell")
        CGMTypesTV.delegate = self
        CGMTypesTV.dataSource = self
        
     
        CGMTypesTV.reloadData()
        
       // self.CGMTypesTV.registerCell(with: CGMTypeTableViewCell.self)
        
    }
    
}


// MARK: - Extension For TableView
//===========================
extension CGMSelectorVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(CGMTypeArray.count)
        return CGMTypeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CGMTypeTableViewCell = CGMTypesTV.dequeueReusableCell(withIdentifier: "CGMTypeTableViewCell", for: indexPath) as! CGMTypeTableViewCell
        
   
        cell.subTitlelbl.text = CGMTypeArray[indexPath.row]
        if indexPath.row == 0{
            cell.nextBtn.setImage(UIImage(named: "Radio_selected"), for: .normal)
            cell.subTitlelbl.textColor = UIColor.black
            cell.outerView.layer.borderColor = AppColors.appGreenColor.cgColor
        }
        else{
            cell.nextBtn.setImage(UIImage(named: "Radio_unselected"), for: .normal)
            cell.subTitlelbl.textColor = AppColors.fontPrimaryColor
            cell.outerView.layer.borderColor = AppColors.fontPrimaryColor.cgColor
        }
        
        cell.subTitlelbl.font = AppFonts.SF_Pro_Display_Medium.withSize(.x16)
        
        cell.outerView.layer.borderWidth = 1
        cell.outerView.layer.cornerRadius = 10
        cell.outerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

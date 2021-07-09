//
//  PairLunaVC.swift
//  Luna
//
//  Created by Admin on 07/07/21.
//

import UIKit

class PairLunaVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var IntroLbl: UILabel!
    @IBOutlet weak var SubIntroLbl: UILabel!
    @IBOutlet weak var InfoIntroLbl: UILabel!
    @IBOutlet weak var proceedBtn: AppButton!
    var vcObj:UIViewController = UIViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func proceedBtnAction(_ sender: UIButton) {
        self.proceedBtn.isEnabled = true
        let scene =  SearchingDeviceVC.instantiate(fromAppStoryboard: .CGPStoryboard)
        self.present(scene, animated: true, completion: nil)
        
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.pop()
    }

}


// MARK: - Extension For Functions
//===========================
extension PairLunaVC {
    
    private func initialSetup() {
     
        SubIntroLbl.textColor = AppColors.fontPrimaryColor
        InfoIntroLbl.textColor =  AppColors.fontPrimaryColor
        
        self.proceedBtn.layer.cornerRadius = 10
        self.proceedBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
  
}

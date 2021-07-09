//
//  SearchingDeviceVC.swift
//  Luna
//
//  Created by Admin on 07/07/21.
//

import UIKit

class SearchingDeviceVC: UIViewController {

    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var IntroLbl: UILabel!
    @IBOutlet weak var outerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IntroLbl.textColor =  AppColors.fontPrimaryColor
        outerView.layer.cornerRadius = 10
        outerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]

    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func proceedBtnAction(_ sender: UIButton) {
       
        let scene =  DeviceConnectedVC.instantiate(fromAppStoryboard: .CGPStoryboard)
        self.present(scene, animated: true, completion: nil)
        
    }
    
    @IBAction func dissmissBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }

}

//
//  LunaDevicesVC.swift
//  Luna
//
//  Created by Admin on 07/07/21.
//

import UIKit

class LunaDevicesVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var introLbl: UILabel!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var oKBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.oKBtn.round(radius: 10.0)
        self.oKBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        outerView.round(radius: 10.0)
        outerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func proceedBtnAction(_ sender: UIButton) {
        self.dismiss(animated: false, completion: {
        })
    }
    
    @IBAction func dissmissBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}

// MARK: - Extension For Functions
//===========================
extension LunaDevicesVC {
    
    private func initialSetup() {
        self.oKBtn.isEnabled = true
        self.introLbl.textColor =  AppColors.fontPrimaryColor
    }
}

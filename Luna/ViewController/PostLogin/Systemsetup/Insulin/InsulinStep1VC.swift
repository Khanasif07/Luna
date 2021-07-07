//
//  InsulinStep1VC.swift
//  Luna
//
//  Created by Admin on 01/07/21.
//

import UIKit

class InsulinStep1VC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var btmContainerView: UIView!
    @IBOutlet weak var proceedBtn: AppButton!
    
    // MARK: - Variables
    //===========================
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backView.round()
        proceedBtn.layer.cornerRadius = 8.0
        btmContainerView.layer.cornerRadius = 10.0
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func proceedBtnAction(_ sender: UIButton) {
        let vc = InsulinStep2VC.instantiate(fromAppStoryboard: .SystemSetup)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
}

// MARK: - Extension For Functions
//===========================
extension InsulinStep1VC {
    
    private func initialSetup() {
        btmContainerView.setBorder(width: 1.0, color: #colorLiteral(red: 0.9607843137, green: 0.5450980392, blue: 0.262745098, alpha: 1))
        proceedBtn.isEnabled = true
    }
}

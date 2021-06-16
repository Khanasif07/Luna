//
//  PassResetPopUpVC.swift
//  Luna
//
//  Created by Admin on 16/06/21.
//

import UIKit

class PassResetPopUpVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var okBtn: AppButton!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
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
        okBtn.round(radius: 8.0)
        self.dataContainerView.addShadow(cornerRadius: 10.0, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 4)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func okBtnTapped(_ sender: AppButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension PassResetPopUpVC {
    
    private func initialSetup() {
        self.okBtn.isEnabled = true
    }
}

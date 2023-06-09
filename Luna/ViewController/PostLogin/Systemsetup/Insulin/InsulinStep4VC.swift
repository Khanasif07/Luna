//
//  InsulinStep4VC.swift
//  Luna
//
//  Created by Admin on 07/07/21.
//

import UIKit

class InsulinStep4VC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var insulinType: UILabel!
    @IBOutlet weak var doneBtn: AppButton!
    @IBOutlet weak var insulinCountLbl: UILabel!
    @IBOutlet weak var dataContainerView: UIView!
    
    // MARK: - Variables
    //===========================
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        doneBtn.round(radius: 8.0)
        self.dataContainerView.addShadow(cornerRadius: 10.0, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 4)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func doneBtnTapped(_ sender: AppButton) {
        
    }
    
    @IBAction func crossBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Extension For Functions
//===========================
extension InsulinStep4VC {
    
    private func initialSetup() {
        self.doneBtn.isEnabled = true
    }
}


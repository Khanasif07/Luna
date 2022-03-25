//
//  PairLunaProblemVC.swift
//  Luna
//
//  Created by Admin on 27/07/21.
//

import UIKit

class PairLunaProblemVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var pairBtn: AppButton!
    
    // MARK: - Variables
    //===========================
    var lunaStartPairing: BtnTapAction = nil
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.layoutIfNeeded()
        outerView.round(radius: 10.0)
        outerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        pairBtn.round(radius: 4.0)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func pairBtnAction(_ sender: AppButton) {
        self.dismiss(animated: true) {
            if let handle = self.lunaStartPairing{
                handle(sender)
            }
        }
    }
    
    @IBAction func connectWithUsAction(_ sender: UIButton) {
        showAlert(msg: "UNDER DEVELOPMENT")
    }
    
    @IBAction func crossBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}

// MARK: - Extension For Functions
//===========================
extension PairLunaProblemVC {
    private func initialSetup() {
        pairBtn.isEnabled = true
    }
}


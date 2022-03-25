//
//  DeviceConnectedVC.swift
//  Luna
//
//  Created by Admin on 07/07/21.
//

import UIKit

class DeviceConnectedVC: UIViewController {
    
    // MARK: - Variables
    //===========================
    var lunaPairedSuccess: BtnTapAction
        = nil
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var okBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.okBtn.round(radius: 10.0)
        self.okBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        outerView.round(radius: 10.0)
        outerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func proceedBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            if let handle = self.lunaPairedSuccess{
                handle(sender)
            }
        }
    }
    
    @IBAction func dissmissBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}


// MARK: - Extension For Functions
//===========================
extension DeviceConnectedVC {
    
    private func initialSetup() {
        self.okBtn.isEnabled = true
    }
}

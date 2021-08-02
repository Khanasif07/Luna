//
//  DeviceConnectedVC.swift
//  Luna
//
//  Created by Admin on 07/07/21.
//

import UIKit

class DeviceConnectedVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var OKBtn: UIButton!
    
    var lunaPairedSuccess: ((UIButton)->())?

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
        if #available(iOS 13.0, *) {
        overrideUserInterfaceStyle = .light
        }
        self.OKBtn.isEnabled = true
        self.OKBtn.layer.cornerRadius = 10
        self.OKBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
   
        outerView.layer.cornerRadius = 10
        outerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
    }
}

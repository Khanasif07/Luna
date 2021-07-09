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

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func proceedBtnAction(_ sender: UIButton) {
//        self.dismiss(animated: false, completion: {
//        })

        let scene =  LunaDevicesVC.instantiate(fromAppStoryboard: .CGPStoryboard)
        self.present(scene, animated: true, completion: nil)
    }
    
    @IBAction func dissmissBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }

  

}


// MARK: - Extension For Functions
//===========================
extension DeviceConnectedVC {
    
    private func initialSetup() {
        
        self.OKBtn.isEnabled = true
        self.OKBtn.layer.cornerRadius = 10
        self.OKBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
   
        outerView.layer.cornerRadius = 10
        outerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
    }
}

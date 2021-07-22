//
//  PairLunaVC.swift
//  Luna
//
//  Created by Admin on 07/07/21.
//

import UIKit
import Pulsator
class PairLunaVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var IntroLbl: UILabel!
    @IBOutlet weak var SubIntroLbl: UILabel!
    @IBOutlet weak var InfoIntroLbl: UILabel!
    @IBOutlet weak var proceedBtn: AppButton!
    var vcObj:UIViewController = UIViewController()
    let pulsator = Pulsator()

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.layoutIfNeeded()
        pulsator.position = view.layer.position
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func proceedBtnAction(_ sender: UIButton) {
        self.proceedBtn.isEnabled = true
        let scene =  SearchingDeviceVC.instantiate(fromAppStoryboard: .CGPStoryboard)
        scene.deviceConnectedNavigation = { [weak self] (sender) in
            guard let selff = self else { return }
            let scene =  DeviceConnectedVC.instantiate(fromAppStoryboard: .CGPStoryboard)
            scene.lunaPairedSuccess = { [weak self] (sender) in
                guard let selff = self else { return }
                NotificationCenter.default.post(name: Notification.Name.lunaPairedSuccessfully, object: nil)
                selff.navigationController?.popToViewControllerOfType(classForCoder: SystemSetupStep1VC.self)
            }
            selff.present(scene, animated: true, completion: nil)
        }
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
       
//        pulsator.radius = 50.0
//        pulsator.backgroundColor = UIColor.red.cgColor
////        view.layer.superlayer?.insertSublayer(pulsator, below: view.layer)
//        view.layer.addSublayer(pulsator)
//        pulsator.start()
    }
  
}

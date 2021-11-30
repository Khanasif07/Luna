//
//  PairLunaVC.swift
//  Luna
//
//  Created by Admin on 07/07/21.
//

import UIKit
class PairLunaVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var IntroLbl: UILabel!
    @IBOutlet weak var SubIntroLbl: UILabel!
    @IBOutlet weak var InfoIntroLbl: UILabel!
    @IBOutlet weak var proceedBtn: AppButton!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
        overrideUserInterfaceStyle = .light
        }
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
        view.layer.layoutIfNeeded()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func proceedBtnAction(_ sender: UIButton) {
        //
        if BleManager.sharedInstance.myperipheral?.state == .connected {
            BleManager.sharedInstance.disConnect()
            self.pop()
            return
        }
        //
        let scene =  SearchingDeviceVC.instantiate(fromAppStoryboard: .CGPStoryboard)
        scene.deviceConnectedNavigation = { [weak self] (sender) in
            guard let self = self else { return }
            let scene =  DeviceConnectedVC.instantiate(fromAppStoryboard: .CGPStoryboard)
            scene.lunaPairedSuccess = { [weak self] (sender) in
                guard let self = self else { return }
                if   SystemInfoModel.shared.isFromSetting {
                    NotificationCenter.default.post(name: Notification.Name.lunaPairedSuccessfully, object: nil)
                    self.navigationController?.popToViewControllerOfType(classForCoder: SystemSetupVC.self)
                    CommonFunctions.showToastWithMessage("Paired Luna successfully.")
                }else {
                    NotificationCenter.default.post(name: Notification.Name.lunaPairedSuccessfully, object: nil)
                    self.navigationController?.popToViewControllerOfType(classForCoder: SystemSetupStep1VC.self)
                }
            }
            self.present(scene, animated: true, completion: nil)
        }
        
        scene.deviceNotConnectedNavigation = {  [weak self] (sender) in
            guard let self = self else { return }
            let scene =  PairLunaProblemVC.instantiate(fromAppStoryboard: .CGPStoryboard)
            scene.lunaStartPairing = { [weak self] (sender) in
                guard let self = self else { return }
                let scene =  SearchingDeviceVC.instantiate(fromAppStoryboard: .CGPStoryboard)
                scene.deviceConnectedNavigation = { [weak self] (sender) in
                    guard let self = self else { return }
                    let scene =  DeviceConnectedVC.instantiate(fromAppStoryboard: .CGPStoryboard)
                    scene.lunaPairedSuccess = { [weak self] (sender) in
                        guard let self = self else { return }
                        if   SystemInfoModel.shared.isFromSetting {
                            NotificationCenter.default.post(name: Notification.Name.lunaPairedSuccessfully, object: nil)
                            self.navigationController?.popToViewControllerOfType(classForCoder: SystemSetupVC.self)
                            CommonFunctions.showToastWithMessage("Paired Luna successfully.")
                        }else {
                            NotificationCenter.default.post(name: Notification.Name.lunaPairedSuccessfully, object: nil)
                            self.navigationController?.popToViewControllerOfType(classForCoder: SystemSetupStep1VC.self)
                        }
                    }
                    self.present(scene, animated: true, completion: nil)
                }
                scene.deviceNotConnectedNavigation = {  [weak self] (sender) in
                    guard let self = self else { return }
                    print(self)
                   // MARK:- Need to work=================
                }
                let transition = CATransition()
                transition.duration = 0.5
                transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                transition.type = CATransitionType.moveIn
                transition.subtype = CATransitionSubtype.fromTop
                self.navigationController?.view.layer.add(transition, forKey: nil)
                self.navigationController?.pushViewController(scene, animated: false)
            }
            self.present(scene, animated: true, completion: nil)
            
        }
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(scene, animated: false)
        
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
        self.proceedBtn.isEnabled = true
        if BleManager.sharedInstance.myperipheral?.state == .connected {
            self.proceedBtn.setTitle("Unpair", for: .normal)
            self.InfoIntroLbl.text = "Your Luna Controller is paired, to unpair your Luna Controller, tap the “Unpair” button below"
        }else {
            self.proceedBtn.setTitle("Pair", for: .normal)
            self.InfoIntroLbl.text = "To pair your Luna Controller, bring it close to your phone and tap the “Pair” button below"
        }
        self.proceedBtn.round(radius: 10.0)
        self.proceedBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
}

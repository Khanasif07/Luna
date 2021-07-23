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
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.layoutIfNeeded()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func proceedBtnAction(_ sender: UIButton) {
        let scene =  SearchingDeviceVC.instantiate(fromAppStoryboard: .CGPStoryboard)
        scene.deviceConnectedNavigation = { [weak self] (sender) in
            guard let selff = self else { return }
            let scene =  DeviceConnectedVC.instantiate(fromAppStoryboard: .CGPStoryboard)
            scene.lunaPairedSuccess = { [weak self] (sender) in
                guard let selff = self else { return }
                if   SystemInfoModel.shared.isFromSetting {
//                    CommonFunctions.showActivityLoader()
//                    FirestoreController.updateSystemInfoData(userId: AppUserDefaults.value(forKey: .uid).stringValue, longInsulinType: SystemInfoModel.shared.longInsulinType, longInsulinSubType: SystemInfoModel.shared.longInsulinSubType, insulinUnit: SystemInfoModel.shared.insulinUnit, cgmType: SystemInfoModel.shared.cgmType, cgmUnit: SystemInfoModel.shared.cgmUnit) {
//                        FirestoreController.getUserSystemInfoData{
//                            CommonFunctions.hideActivityLoader()
                            NotificationCenter.default.post(name: Notification.Name.lunaPairedSuccessfully, object: nil)
                            selff.navigationController?.popToViewControllerOfType(classForCoder: SystemSetupVC.self)
                            CommonFunctions.showToastWithMessage("Paired Luna successfully.")
//                        } failure: { (error) -> (Void) in
//                            CommonFunctions.hideActivityLoader()
//                            CommonFunctions.showToastWithMessage(error.localizedDescription)
//                        }
//                    } failure: { (error) -> (Void) in
//                        CommonFunctions.hideActivityLoader()
//                        CommonFunctions.showToastWithMessage(error.localizedDescription)
//                    }
                }else {
                NotificationCenter.default.post(name: Notification.Name.lunaPairedSuccessfully, object: nil)
                selff.navigationController?.popToViewControllerOfType(classForCoder: SystemSetupStep1VC.self)
                }
            }
            selff.present(scene, animated: true, completion: nil)
        }
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//           let viewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController

           let transition = CATransition()
           transition.duration = 0.5
           transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
           transition.type = CATransitionType.moveIn
           transition.subtype = CATransitionSubtype.fromTop
           self.navigationController?.view.layer.add(transition, forKey: nil)
           self.navigationController?.pushViewController(scene, animated: false)
//        self.navigationController?.pushViewController(scene, animated: true)
//        self.present(scene, animated: true, completion: nil)
        
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
        self.proceedBtn.layer.cornerRadius = 10
        self.proceedBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
  
}

//
//  CGMDATASHAREVC.swift
//  Luna
//
//  Created by Admin on 07/07/21.
//

import UIKit

class CGMDATASHAREVC: UIViewController {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var okBtn: AppButton!
    @IBOutlet weak var conformLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    var CGMConnectNavigation: BtnTapAction = nil
    
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
    
    // MARK: - IBActions
    //===========================
    @IBAction func okBtnTapped(_ sender: AppButton) {
        self.dismiss(animated: true) {
            if let handle = self.CGMConnectNavigation{
                handle(sender)
            }
        }
    }
    
    @IBAction func crossBtnTapped(_ sender: AppButton) {
        self.dismiss(animated: false, completion: nil)
    }
}


// MARK: - Extension For Functions
//===========================
extension CGMDATASHAREVC {
    private func initialSetup() {
        if #available(iOS 13.0, *) {
        overrideUserInterfaceStyle = .light
        }
        self.titleLbl.textColor = UIColor.black
        self.subTitleLbl.textColor = AppColors.fontPrimaryColor
        self.conformLbl.textColor = UIColor.black
        outerView.round(radius: 10.0)
        outerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        self.okBtn.isEnabled = true
        self.okBtn.round(radius: 10.0)
        self.okBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
}

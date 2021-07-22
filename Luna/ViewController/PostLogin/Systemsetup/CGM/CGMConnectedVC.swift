//
//  CGMConnectedVC.swift
//  Luna
//
//  Created by Admin on 07/07/21.
//

import UIKit

class CGMConnectedVC: UIViewController {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var okBtn: AppButton!
    @IBOutlet weak var ValueLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var ValueImage : UIImageView!
    
    var vcObj:UIViewController = UIViewController()
    var cgmConnectedSuccess: ((UIButton)->())?

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func okBtnTapped(_ sender: AppButton) {
        self.dismiss(animated: true) {
            if let handle = self.cgmConnectedSuccess{
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
extension CGMConnectedVC {
    
    private func initialSetup() {
        if #available(iOS 13.0, *) {
        overrideUserInterfaceStyle = .light
        }
        self.titleLbl.textColor = UIColor.black
        self.subTitleLbl.textColor = AppColors.fontPrimaryColor
        
        outerView.layer.cornerRadius = 10
        outerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]

        self.okBtn.isEnabled = true
        
        self.okBtn.layer.cornerRadius = 10
        self.okBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
}

//
//  PassResetPopUpVC.swift
//  Luna
//
//  Created by Admin on 16/06/21.
//

import UIKit

class PassResetPopUpVC: UIViewController {
    
    enum PopupType{
        case resetPassword
        case emailVerification
    }
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var okBtn: AppButton!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    // MARK: - Variables
    //===========================
    var popupType: PopupType = .resetPassword
    var titleDesc: String = LocalizedString.password_Reset.localized
    var subTitleDesc : String = LocalizedString.reset_password_link_sent.localized
    var emailVerificationSuccess: TapAction = nil
    var resetPasswordSuccess: TapAction = nil
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        okBtn.round(radius: 8.0)
        self.dataContainerView.addShadow(cornerRadius: 10.0, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 4)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func okBtnTapped(_ sender: AppButton) {
        switch popupType {
        case .emailVerification:
            self.dismiss(animated: true) {
                if let handle = self.emailVerificationSuccess{
                    handle()
                }
            }
        default:
            self.dismiss(animated: true) {
                if let handle = self.resetPasswordSuccess{
                    handle()
                }
            }
        }
    }
}

// MARK: - Extension For Functions
//===========================
extension PassResetPopUpVC {
    
    private func initialSetup() {
        self.titleLbl.text = titleDesc
        self.subtitleLbl.text = subTitleDesc
        self.okBtn.isEnabled = true
    }
}

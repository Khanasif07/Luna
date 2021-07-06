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
    var titleDesc: String = "Password Reset"
    var subTitleDesc : String = "Reset password link has been shared on your registered email. Check and create new password"
    var emailVerificationSuccess: (()->())?
    var resetPasswordSuccess: (()->())?
    
    // MARK: - Lifecycle
    //===========================
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
        if #available(iOS 13.0, *) {
        overrideUserInterfaceStyle = .light
        }
        self.titleLbl.text = titleDesc
        self.subtitleLbl.text = subTitleDesc
        self.okBtn.isEnabled = true
    }
}

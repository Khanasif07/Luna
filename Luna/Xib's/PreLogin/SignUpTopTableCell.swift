//
//  SignUpTopTableCell.swift
//  Luna
//
//  Created by Admin on 15/06/21.
//

import UIKit

class SignUpTopTableCell: UITableViewCell {
    
    var signUpBtnTapped: ((UIButton)->())?
    var forgotPassBtnTapped: ((UIButton)->())?
    
    @IBOutlet weak var phoneTxtField: AppTextField!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var forgotPassBtn: UIButton!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var signUpBtn: AppButton!
    @IBOutlet weak var passTxtField: AppTextField!
    @IBOutlet weak var emailIdTxtField:AppTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpTextField()
        self.setUpFont()
    }
    
    
    public func setUpFont(){
        //        signUpBtn.titleLabel?.font = AppFonts.SF_Pro_Display_Medium.withSize(.x15)
        //        titleLbl.font = AppFonts.SF_Pro_Display_Bold.withSize(.x24)
        //        subTitleLbl.font = AppFonts.SF_Pro_Display_Regular.withSize(.x14)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        [emailIdTxtField,passTxtField,phoneNumberView].forEach { (txtField) in
            txtField?.layer.cornerRadius = 8.0
            txtField?.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
        }
        signUpBtn.round(radius: 4.0)
    }
    
    public func setUpTextField(){
        self.phoneTxtField.keyboardType = .numberPad
        self.passTxtField.placeholder = LocalizedString.password.localized
        self.emailIdTxtField.placeholder = LocalizedString.emailID.localized
        self.signUpBtn.backgroundColor = AppColors.primaryBlueColor
        self.signUpBtn.isEnabled = false
        self.passTxtField.isSecureTextEntry = true
        let show = UIButton()
        show.isSelected = false
        show.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        show.addTarget(self, action: #selector(secureTextField(_:)), for: .touchUpInside)
        self.passTxtField.setButtonToRightView(btn: show, selectedImage: #imageLiteral(resourceName: "eyeClosedIcon"), normalImage: #imageLiteral(resourceName: "eyeOpenIcon"), size: CGSize(width: 22, height: 22))
    }
    
    
    @objc func secureTextField(_ sender: UIButton){
        sender.isSelected.toggle()
        self.passTxtField.isSecureTextEntry = !sender.isSelected
    }
    
    
    @IBAction func forgotPassBtnAction(_ sender: UIButton) {
        if let handle = forgotPassBtnTapped{
            handle(sender)
        }
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        if let handle = signUpBtnTapped{
            handle(sender)
        }
    }
    
}

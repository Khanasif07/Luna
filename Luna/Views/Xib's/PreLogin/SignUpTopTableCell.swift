//
//  SignUpTopTableCell.swift
//  Luna
//
//  Created by Admin on 15/06/21.
//

import UIKit
class SignUpTopTableCell: UITableViewCell {
        
    //MARK:-IBOutlets
    //==========================================
    @IBOutlet weak var forgotPassBtn: UIButton!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var signUpBtn: AppButton!
    @IBOutlet weak var passTxtField: AppTextField!
    @IBOutlet weak var emailIdTxtField:AppTextField!
    
    //MARK:-Variables
    //==========================================
    var signUpBtnTapped: BtnTapAction = nil
    var forgotPassBtnTapped: BtnTapAction = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpFont()
        self.setUpTextField()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        [emailIdTxtField,passTxtField].forEach { (txtField) in
            txtField?.round(radius: 8.0)
            txtField?.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
        }
        signUpBtn.round(radius: 4.0)
    }
    
    public func setUpFont(){
        self.titleLbl.font = AppFonts.SF_Pro_Display_Bold.withSize(.x24)
        self.subTitleLbl.font = AppFonts.SF_Pro_Display_Regular.withSize(.x14)
        self.signUpBtn.titleLabel?.font = AppFonts.SF_Pro_Display_Semibold.withSize(.x16)
        self.forgotPassBtn.titleLabel?.font = AppFonts.SF_Pro_Display_Semibold.withSize(.x14)
        self.passTxtField.font = AppFonts.SF_Pro_Display_Medium.withSize(.x16)
        self.emailIdTxtField.font = AppFonts.SF_Pro_Display_Medium.withSize(.x16)
    }
    
    public func setUpTextField(){
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
    
    public func configureCellSignInScreen(emailTxt:String,passTxt:String){
        self.emailIdTxtField.text = emailTxt
        self.passTxtField.text = passTxt
        self.titleLbl.text = LocalizedString.lOGIN_TO_LUNA.localized
        self.subTitleLbl.text = ""
        self.signUpBtn.setTitle(LocalizedString.login.localized, for: .normal)
        self.forgotPassBtn.isHidden = false
    }
    
    public func configureCellSignupScreen(){
        self.titleLbl.text = LocalizedString.signup.localized.uppercased()
        self.subTitleLbl.text = ""
        self.signUpBtn.setTitle(LocalizedString.signup.localized, for: .normal)
        self.forgotPassBtn.isHidden = true
    }

    @objc func secureTextField(_ sender: UIButton){
        sender.isSelected.toggle()
        self.passTxtField.isSecureTextEntry = !sender.isSelected
    }
    
    //MARK:-IBActions
    //==========================================
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

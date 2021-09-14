//
//  LoginSocialTableCell.swift
//  Luna
//
//  Created by Admin on 15/06/21.
//

import UIKit
import Foundation

class LoginSocialTableCell: UITableViewCell {

    //MARK:-IBOutlets

    @IBOutlet weak var appleBtnView: UIView!
    @IBOutlet weak var googleBtnView: UIView!
    @IBOutlet weak var appleBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var loginSocialLbl: UILabel!
    @IBOutlet weak var socialBtnStackView: UIStackView!

    //MARK:-Variables
    var signupLoginDescText = LocalizedString.alreadyHaveAnAccount.localized
    var signupLoginText = LocalizedString.login.localized
    var appleBtnTapped: (()->())?
    var googleBtnTapped: (()->())?
    var loginBtnTapped: (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpAttributedString()
        self.setUpButtonInset()
        self.setUpBorder()
        let imageView = UIImageView(image: UIImage(named: "apple"))
        appleBtn.setImage(imageView.image, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        [self.googleBtnView,self.appleBtnView].forEach { (btnView) in
            btnView?.round(radius: 8.0)
        }
    }
    
    private func setUpBorder(){
        self.googleBtnView.borderWidth = 1.0
        self.appleBtnView.borderWidth = 1.0
        self.googleBtnView.borderColor = #colorLiteral(red: 0.662745098, green: 0.662745098, blue: 0.662745098, alpha: 1)
        self.appleBtnView.borderColor = #colorLiteral(red: 0.662745098, green: 0.662745098, blue: 0.662745098, alpha: 1)
    }
    
    public func setUpAttributedString(){
        let attributedString = NSMutableAttributedString(string: signupLoginDescText , attributes: [
            .font: AppFonts.SF_Pro_Display_Regular.withSize(.x14)
        ])
        let privactAttText = (NSAttributedString(string: signupLoginText, attributes: [NSAttributedString.Key.foregroundColor: UIColor(r: 61, g: 201, b: 147, alpha: 1.0),NSAttributedString.Key.font: AppFonts.SF_Pro_Display_Bold.withSize(.x15)]))
        attributedString.append(privactAttText)
        loginSocialLbl.attributedText = attributedString
        loginSocialLbl.isUserInteractionEnabled = true
        loginSocialLbl.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.tapLabel(_:))))
        
    }
    
    @objc func tapLabel(_ gesture: UITapGestureRecognizer) {
        let string = "\(self.loginSocialLbl.text ?? "")"
        let termsAndCondition = signupLoginText
        if let range = string.range(of: termsAndCondition) {
            if gesture.didTapAttributedTextsInLabel(label: self.loginSocialLbl, inRange: NSRange(range, in: string)) {
                if let handle = loginBtnTapped{
                    handle()
                }
            }
        }
    }
    
    public func setUpButtonInset(){
        googleBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7.5, bottom: 0, right: 0)
        appleBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7.5, bottom: 0, right: 0)
    }
    
    @IBAction func googleBtnAction(_ sender: UIButton) {
        googleBtnTapped?()
    }
    
    @IBAction func appleBtnAction(_ sender: UIButton) {
        appleBtnTapped?()
    }
    
}
 

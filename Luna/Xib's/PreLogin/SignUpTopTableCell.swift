//
//  SignUpTopTableCell.swift
//  Luna
//
//  Created by Admin on 15/06/21.
//

import UIKit

class SignUpTopTableCell: UITableViewCell {
    
    var signUpBtnTapped: ((UIButton)->())?
    
    
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var signUpBtn: AppButton!
    @IBOutlet weak var passTxtField: UITextField!
    @IBOutlet weak var emailIdTxtField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpTextField()
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
           self.passTxtField.setButtonToRightView(btn: show, selectedImage: #imageLiteral(resourceName: "eyeOpenIcon"), normalImage: #imageLiteral(resourceName: "eyeOpenIcon"), size: CGSize(width: 22, height: 22))
       }
       
       
       @objc func secureTextField(_ sender: UIButton){
           sender.isSelected.toggle()
           self.passTxtField.isSecureTextEntry = !sender.isSelected
       }
    
       override func layoutSubviews() {
           super.layoutSubviews()
           signUpBtn.round(radius: 4.0)
       }
       
       
       @IBAction func signUpAction(_ sender: UIButton) {
           if let handle = signUpBtnTapped{
               handle(sender)
           }
       }
       
   }

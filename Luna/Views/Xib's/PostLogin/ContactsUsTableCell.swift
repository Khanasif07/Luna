//
//  ContactsUsTableCell.swift
//  Luna
//
//  Created by Admin on 01/10/21.
//

import UIKit

class ContactsUsTableCell: UITableViewCell {
    
    @IBOutlet weak var textViewContainer: UIView!
    @IBOutlet weak var messageTxtView: PlaceholderTextView!
    @IBOutlet weak var emailTxtFld: AppTextField!
    @IBOutlet weak var nameTxtFld: AppTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpFont()
        self.setUpTextField()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        [nameTxtFld,emailTxtFld].forEach { (txtField) in
            txtField?.isUserInteractionEnabled = false
            txtField?.textColor = AppColors.fontPrimaryColor
        }
        [nameTxtFld,emailTxtFld,textViewContainer].forEach { (txtField) in
            txtField?.round(radius: 8.0)
            txtField?.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
        }
    }
    
    override func prepareForReuse() {
        messageTxtView.inputView = nil
    }
    
    public func setUpFont(){
        self.nameTxtFld.font = AppFonts.SF_Pro_Display_Medium.withSize(.x16)
        self.emailTxtFld.font = AppFonts.SF_Pro_Display_Medium.withSize(.x16)
        self.messageTxtView.font = AppFonts.SF_Pro_Display_Medium.withSize(.x16)
    }
    
    public func setUpTextField(){
        self.nameTxtFld.placeholder = LocalizedString.first_Name.localized
        self.emailTxtFld.placeholder = LocalizedString.email.localized
    }
}




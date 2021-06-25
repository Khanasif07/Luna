//
//  ProfileTableCell.swift
//  Luna
//
//  Created by Admin on 24/06/21.
//

import UIKit

class ProfileTableCell: UITableViewCell {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var txtField: AppTextField!
    @IBOutlet weak var titleLbl: UILabel!
    
    // MARK: - Variables
    //===========================
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.txtField.rightView  = nil
        self.txtField.inputView = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        [txtField].forEach { (txtFld) in
            txtFld?.layer.cornerRadius = 8.0
            txtFld?.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
        }
    }
    
    // MARK: - IBActions
    //===========================
    
    
}

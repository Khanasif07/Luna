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
    var isSetupforPasswordTxtfield: Bool = false{
        didSet{
            self.setupforPasswordTxtfield()
        }
    }
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        if isSetupforPasswordTxtfield{
            self.setupforPasswordTxtfield()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.txtField.rightView  = nil
        self.txtField.inputView = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        [txtField].forEach { (txtFld) in
            txtFld?.round(radius: 8.0)
            txtFld?.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
        }
    }
    
    func setupforPasswordTxtfield(){
        self.txtField.isSecureTextEntry = true
        let show = UIButton()
        show.isSelected = false
        show.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        show.addTarget(self, action: #selector(secureTextField(_:)), for: .touchUpInside)
        self.txtField.setButtonToRightView(btn: show, selectedImage: #imageLiteral(resourceName: "eyeClosedIcon"), normalImage: #imageLiteral(resourceName: "eyeOpenIcon"), size: CGSize(width: 22, height: 22))
    }
    // MARK: - IBActions
    //===========================
    @objc func secureTextField(_ sender: UIButton){
        sender.isSelected.toggle()
        self.txtField.isSecureTextEntry = !sender.isSelected
    }
    
}

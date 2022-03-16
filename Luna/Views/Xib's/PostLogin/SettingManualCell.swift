//
//  SettingManualCell.swift
//  Luna
//
//  Created by Admin on 28/07/21.
//

import UIKit

class SettingManualCell: UITableViewCell {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var arrowBtn: UIButton!
    @IBOutlet weak var ansLbl: UILabel!
    @IBOutlet weak var queLbl: UILabel!
    @IBOutlet weak var logoBtn: UIButton!
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpFont()
    }
    
    public func setUpFont(){
        self.queLbl.font = AppFonts.SF_Pro_Display_Medium.withSize(.x16)
        self.ansLbl.font = AppFonts.SF_Pro_Display_Regular.withSize(.x14)
    }
    
    public func configureCell(model: (UIImage,String,String,Bool)){
        self.ansLbl.isHidden = !model.3
        self.queLbl.text = model.1
        self.ansLbl.text = model.2
        self.logoBtn.setImage(model.0, for: .normal)
        self.arrowBtn.setImage(model.3 ? #imageLiteral(resourceName: "uparrow") : #imageLiteral(resourceName: "dropdown") , for: .normal)
    }
}

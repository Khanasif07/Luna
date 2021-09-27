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
}

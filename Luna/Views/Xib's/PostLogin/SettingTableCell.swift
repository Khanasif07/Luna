//
//  SettingTableCell.swift
//  Luna
//
//  Created by Admin on 22/06/21.
//

import UIKit

class SettingTableCell: UITableViewCell {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var subTitlelbl: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var switchView: UISwitch!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var logoImgView: UIImageView!
    
    //MARK:-Variables
    //==========================================
    var switchTapped: switchBtnAction = nil
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpFont()
    }
    public func setUpFont(){
        self.titleLbl.font = AppFonts.SF_Pro_Display_Medium.withSize(.x16)
        self.subTitlelbl.font = AppFonts.SF_Pro_Display_Regular.withSize(.x14)
    }
    // MARK: - IBActions
    //===========================
    @IBAction func switchBtnAction(_ sender: UISwitch) {
        if let handle = switchTapped{
            handle(sender)
        }
    }
}

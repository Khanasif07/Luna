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
    var switchTapped: ((UISwitch)->())?
    
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func switchBtnAction(_ sender: UISwitch) {
        if let handle = switchTapped{
            handle(sender)
        }
    }
}

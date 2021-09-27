//
//  BottomSheetTopCell.swift
//  Luna
//
//  Created by Admin on 08/07/21.
//

import UIKit

class BottomSheetTopCell: UITableViewCell {

    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var cgmUnitLbl: UILabel!
    @IBOutlet weak var timeAgoLbl: UILabel!
    @IBOutlet weak var cgmArrowIcon: UIImageView!
    @IBOutlet weak var cgmValueLbl: UILabel!
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpFont()
    }
    
    public func setUpFont(){
        self.cgmValueLbl.font = AppFonts.SF_Pro_Display_Bold.withSize(.x44)
        self.timeAgoLbl.font = AppFonts.SF_Pro_Display_Medium.withSize(.x14)
        self.cgmUnitLbl.font = AppFonts.SF_Pro_Display_Medium.withSize(.x14)
    }
}

//
//  BottomSheetBottomCell.swift
//  Luna
//
//  Created by Admin on 09/07/21.
//

import UIKit

class BottomSheetBottomCell: UITableViewCell {
    
    // MARK: -IBOutlets
    //===========================
    @IBOutlet weak var topLineDashView: LineDashedView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var unitLbl: UILabel!
    @IBOutlet weak var cgmLbl: UILabel!
    
    // MARK: - Life cycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpFont()
    }
    
    public func setUpFont(){
        self.timeLbl.font = AppFonts.SF_Pro_Display_Medium.withSize(.x16)
        self.cgmLbl.font = AppFonts.SF_Pro_Display_Regular.withSize(.x14)
        self.unitLbl.font = AppFonts.SF_Pro_Display_Regular.withSize(.x14)
    }
}

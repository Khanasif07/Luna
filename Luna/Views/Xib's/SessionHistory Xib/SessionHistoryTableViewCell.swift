//
//  SessionHistoryTableViewCell.swift
//  Luna
//
//  Created by Admin on 08/07/21.
//

import UIKit

class SessionHistoryTableViewCell: UITableViewCell {

    // MARK: -IBOutlets
    //===========================
    @IBOutlet weak var unitLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    // MARK: -Life cycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpFont()
    }
    
    public func setUpFont(){
        self.dateLbl.font = AppFonts.SF_Pro_Display_Semibold.withSize(.x16)
        self.unitLbl.font = AppFonts.SF_Pro_Display_Regular.withSize(.x14)
    }
    
    func configureCellData(model: SessionHistory){
        self.dateLbl.text = "\(model.startDate.getDateTimeFromTimeInterval(Date.DateFormat.mmdd.rawValue)) " + "-" + " \(model.endDate.getDateTimeFromTimeInterval(Date.DateFormat.mmdd.rawValue))"
        self.unitLbl.text = "-- units delivered" + " | " +   "\(Int(model.range))% in range"
    }
}

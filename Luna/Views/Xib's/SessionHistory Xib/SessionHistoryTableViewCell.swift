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
    
    // MARK: -Life cycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpFont()
    }
    
    public func setUpFont(){
        self.unitLbl.font = AppFonts.SF_Pro_Display_Regular.withSize(.x16)
    }
    
    func configureCellData(model: SessionHistory){
        self.unitLbl.text = "\(model.insulin / 2) units delivered" + " | " +   "\(Int(model.range))% in range"
    }
}

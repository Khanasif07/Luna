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
    }
}

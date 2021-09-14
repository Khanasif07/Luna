//
//  CGMTypeTableViewCell.swift
//  Luna
//
//  Created by Admin on 06/07/21.
//

import UIKit

class CGMTypeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subTitlelbl: UILabel!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var nextBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.subTitlelbl.font = AppFonts.SF_Pro_Display_Medium.withSize(.x16)
        self.outerView.layer.borderWidth = 1
        self.outerView.round(radius: 10.0)
        self.outerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
}

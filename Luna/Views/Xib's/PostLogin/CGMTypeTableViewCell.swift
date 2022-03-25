//
//  CGMTypeTableViewCell.swift
//  Luna
//
//  Created by Admin on 06/07/21.
//

import UIKit

class CGMTypeTableViewCell: UITableViewCell {
    
    // MARK: -IBOutlets
    //===========================
    @IBOutlet weak var subTitlelbl: UILabel!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var nextBtn: UIButton!

    // MARK: -Life cycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subTitlelbl.font = AppFonts.SF_Pro_Display_Medium.withSize(.x16)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.outerView.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
        self.outerView.round(radius: 10.0)
        self.outerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
    
    func selected() {
        nextBtn.setImage(UIImage(named: "Radio_selected"), for: .normal)
        subTitlelbl.textColor = UIColor(named: "color2")
        outerView.layer.borderColor = AppColors.appGreenColor.cgColor
    }
    
    func unselected() {
        nextBtn.setImage(UIImage(named: "Radio_unselected"), for: .normal)
        subTitlelbl.textColor = AppColors.fontPrimaryColor
        outerView.layer.borderColor = AppColors.fontPrimaryColor.cgColor
    }
}

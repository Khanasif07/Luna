//
//  BottomSheetInsulinCell.swift
//  Luna
//
//  Created by Admin on 09/07/21.
//

import UIKit

class BottomSheetInsulinCell: UITableViewCell {
    
    @IBOutlet weak var insulinCountLbl: UILabel!
    @IBOutlet weak var activeInsulinLbl: UILabel!
    @IBOutlet weak var dataContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dataContainerView.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dataContainerView.round(radius: 10.0)
    }
    
}

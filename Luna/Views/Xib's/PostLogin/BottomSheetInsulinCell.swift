//
//  BottomSheetInsulinCell.swift
//  Luna
//
//  Created by Admin on 09/07/21.
//

import UIKit

class BottomSheetInsulinCell: UITableViewCell {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var insulinCountLbl: UILabel!
    @IBOutlet weak var activeInsulinLbl: UILabel!
    @IBOutlet weak var dataContainerView: UIView!
    
    // MARK: - Life cycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dataContainerView.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
        dataContainerView.round(radius: 10.0)
    }
    
    func populateCell(){
        self.insulinCountLbl.text =  "\(BleManager.sharedInstance.reservoirLevelData)".isEmpty ? "--" :  "\(BleManager.sharedInstance.reservoirLevelData)"
    }
}

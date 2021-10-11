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
    @IBOutlet weak var unitLbl: UILabel!
    @IBOutlet weak var insulinCountLbl: UILabel!
    @IBOutlet weak var activeInsulinLbl: UILabel!
    @IBOutlet weak var dataContainerView: UIView!
    
    // MARK: - Life cycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpFont()
        self.setUpAttributedString()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dataContainerView.setBorder(width: 1.0, color: AppColors.fontPrimaryColor)
        dataContainerView.round(radius: 10.0)
    }
    
    func populateCell(){
        self.setUpAttributedString()
//        self.insulinCountLbl.text =  "\(BleManager.sharedInstance.reservoirLevelData)".isEmpty ? "-- Units" :  "\(BleManager.sharedInstance.reservoirLevelData) Units"
    }
    
    public func setUpAttributedString(){
        let attributedString = NSMutableAttributedString(string: "\(BleManager.sharedInstance.reservoirLevelData)".isEmpty ? "--" :  "\(BleManager.sharedInstance.reservoirLevelData)" , attributes: [
            .font: AppFonts.SF_Pro_Display_Bold.withSize(.x20)
        ])
        let privactAttText = (NSAttributedString(string: " Units", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font: AppFonts.SF_Pro_Display_Medium.withSize(.x12)]))
        attributedString.append(privactAttText)
        insulinCountLbl.attributedText = attributedString
    }
    
    public func setUpFont(){
        self.insulinCountLbl.font = AppFonts.SF_Pro_Display_Bold.withSize(.x22)
        self.activeInsulinLbl.font = AppFonts.SF_Pro_Display_Regular.withSize(.x12)
        self.unitLbl.font = AppFonts.SF_Pro_Display_Medium.withSize(.x12)
    }
}

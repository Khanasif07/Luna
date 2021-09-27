//
//  SystemStep1TableCell.swift
//  Luna
//
//  Created by Admin on 01/07/21.
//

import UIKit

class SystemStep1TableCell: UITableViewCell {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var directionText: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var unitLbl: UILabel!
    @IBOutlet weak var cgmInsulinDataView: UIStackView!
    @IBOutlet weak var pairedDeviceImgView: UIImageView!
    @IBOutlet weak var startBtn: AppButton!
    @IBOutlet weak var timeDescView: UIStackView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var stepLbl: UILabel!
    @IBOutlet weak var timeToCompleteLabel: UILabel!
    
    // MARK: - Variables
    //===========================
    var startBtnTapped: TapAction = nil
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpFont()
        self.startBtn.isEnabled = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        startBtn.round(radius: 8.0)
        dataContainerView.setBorder(width: 1.0, color: #colorLiteral(red: 0.1098039216, green: 0.1176470588, blue: 0.3254901961, alpha: 1))
        dataContainerView.round(radius: 10.0)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func startBtnAction(_ sender: AppButton) {
        if let handle = startBtnTapped{
            handle()
        }
    }
    
    public func setUpFont(){
        self.stepLbl.font = AppFonts.SF_Pro_Display_Medium.withSize(.x14)
        self.titleLbl.font = AppFonts.SF_Pro_Display_Bold.withSize(.x22)
        self.timeToCompleteLabel.font = AppFonts.SF_Pro_Display_Regular.withSize(.x14)
        self.unitLbl.font = AppFonts.SF_Pro_Display_Medium.withSize(.x12)
        self.startBtn.titleLabel?.font = AppFonts.SF_Pro_Display_Semibold.withSize(.x16)
    }
}

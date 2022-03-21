//
//  InsulinStep2Cell.swift
//  Luna
//
//  Created by Admin on 07/07/21.
//


import UIKit

class InsulinStep2Cell: UITableViewCell {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var insulinSubType: UILabel!
    @IBOutlet weak var insulinType: UILabel!
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var radioBtn: UIButton!
    @IBOutlet weak var dataContainerView: UIView!
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.dataContainerView.setBorder(width: 1.0, color: #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1))
        self.dataContainerView.round(radius: 10.0)
    }
    
    public func initialSetup(){
        self.insulinType.font = AppFonts.SF_Pro_Display_Medium.withSize(.x16)
        self.insulinSubType.font = AppFonts.SF_Pro_Display_Regular.withSize(.x14)
        self.radioBtn.isUserInteractionEnabled = false
        self.radioBtn.setImage(#imageLiteral(resourceName: "radioSelected"), for: .selected)
        self.radioBtn.setImage(#imageLiteral(resourceName: "radioUnSelected"), for: .normal)
    }
    
    public func configureCell(model: (String,Bool,String,UIImage)){
        self.insulinType.text = model.0
        self.insulinSubType.text = model.2
        self.logoImgView.image = model.3
        self.dataContainerView.setBorder(width: 1.0, color: !model.1 ? AppColors.fontPrimaryColor : AppColors.appGreenColor)
        self.radioBtn.isSelected = model.1
    }
}

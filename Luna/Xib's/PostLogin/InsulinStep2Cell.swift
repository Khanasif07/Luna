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
    
    // MARK: - Variables
    //===========================
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        dataContainerView.setBorder(width: 1.0, color: #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dataContainerView.layer.cornerRadius = 10.0
    }
    
    // MARK: - IBActions
    //===========================
    
    
}

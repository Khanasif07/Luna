//
//  TypeTableCell.swift
//  Luna
//
//  Created by Admin on 19/06/21.
//

import UIKit

class TypeTableCell: UITableViewCell {
    
    //MARK:-IBOutlets
    //==========================================
    @IBOutlet weak var type2Btn: UIButton!
    @IBOutlet weak var type1Btn: UIButton!
    
    //MARK:-Variables
    //==========================================
    var type1BtnTapped: TapAction = nil
    var type2BtnTapped: TapAction = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        [type2Btn,type1Btn].forEach { (btn) in
            btn?.setBorder(width: 1.0, color: #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1))
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        [type1Btn,type2Btn].forEach { (btn) in
            btn?.round(radius: 12.0)
        }
    }
    
    func configureCell(){
        if type2Btn.isSelected {
            type2Btn.setBorder(width: 1.0, color: #colorLiteral(red: 0.1098039216, green: 0.6274509804, blue: 0.4745098039, alpha: 1))
            type2Btn.titleLabel?.textColor = #colorLiteral(red: 0.2745098039, green: 0.7607843137, blue: 0.5725490196, alpha: 1)
            type2Btn.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9803921569, blue: 0.9568627451, alpha: 1)
        }
        if type1Btn.isSelected {
            type1Btn.setBorder(width: 1.0, color: #colorLiteral(red: 0.1098039216, green: 0.6274509804, blue: 0.4745098039, alpha: 1))
            type1Btn.titleLabel?.textColor = #colorLiteral(red: 0.2745098039, green: 0.7607843137, blue: 0.5725490196, alpha: 1)
            type1Btn.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9803921569, blue: 0.9568627451, alpha: 1)
        }
    }
    
    //MARK:-IBActions
    //==========================================
    @IBAction func type2BtnAction(_ sender: UIButton) {
        if let handle = type2BtnTapped{
            handle()
        }
    }
    
    @IBAction func type1BtnAction(_ sender: UIButton) {
        if let handle = type1BtnTapped{
            handle()
        }
    }
}

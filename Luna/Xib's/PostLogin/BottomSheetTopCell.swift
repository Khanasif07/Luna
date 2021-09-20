//
//  BottomSheetTopCell.swift
//  Luna
//
//  Created by Admin on 08/07/21.
//

import UIKit

class BottomSheetTopCell: UITableViewCell {

    @IBOutlet weak var cgmArrowIcon: UIImageView!
    @IBOutlet weak var cgmValueLbl: UILabel!
    
    func populateCell(){
        self.cgmArrowIcon.isHidden = SystemInfoModel.shared.cgmUnit == -1 ? true :  false
        self.cgmValueLbl.text =  SystemInfoModel.shared.cgmUnit == -1 ? "--" :  "\(SystemInfoModel.shared.cgmUnit)"
    }
}

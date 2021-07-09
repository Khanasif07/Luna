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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

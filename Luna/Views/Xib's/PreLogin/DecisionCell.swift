//
//  DecisionCell.swift
//  Luna
//
//  Created by Admin on 19/06/21.
//

import UIKit

class DecisionCell: UITableViewCell {
    
    var yesBtnTapped: (()->())?
    var noBtnTapped: (()->())?
    
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var yesBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func noBtnAction(_ sender: UIButton) {
        if let handle = noBtnTapped{
            handle()
        }
    }
    
    @IBAction func yesBtnAction(_ sender: UIButton) {
        if let handle = yesBtnTapped{
            handle()
        }
    }
    
}

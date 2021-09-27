//
//  DecisionCell.swift
//  Luna
//
//  Created by Admin on 19/06/21.
//

import UIKit

class DecisionCell: UITableViewCell {
    
    //MARK:-IBOutlets
    //==========================================
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var yesBtn: UIButton!
    
    //MARK:-IBOutlets
    //==========================================
    var yesBtnTapped: TapAction = nil
    var noBtnTapped: TapAction = nil
    
    //MARK:-IBActions
    //==========================================
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

//
//  MessageSenderCell.swift
//  Luna
//
//  Created by Admin on 19/06/21.
//

import UIKit
class MessageSenderCell: UITableViewCell {
    
    //MARK:-IBOutlets
    //==========================================
    @IBOutlet weak var senderMsgLbl: UILabel!
    @IBOutlet weak var dataContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpFont()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dataContainerView.roundCorners([.topRight,.topLeft,.bottomLeft], radius: 15)
    }
    
    public func setUpFont(){
        self.senderMsgLbl.font = AppFonts.SF_Pro_Display_Medium.withSize(.x14)
    }
}


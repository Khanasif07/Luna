//
//  MessageReceiverCell.swift
//  Luna
//
//  Created by Admin on 19/06/21.
//

import UIKit
class MessageReceiverCell: UITableViewCell {
    
    //MARK:-IBOutlets
    //==========================================
    @IBOutlet weak var msgContainerView: UIView!
    @IBOutlet weak var msgLabel: UILabel!
    
    //MARK:-Life cycle
    //==========================================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpFont()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        msgContainerView.roundCorners([.topLeft, .topRight, .bottomRight], radius: 15)
    }
    
    public func setUpFont(){
        self.msgLabel.font = AppFonts.SF_Pro_Display_Medium.withSize(.x14)
    }
    
}

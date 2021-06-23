//
//  MessageReceiverCell.swift
//  Luna
//
//  Created by Admin on 19/06/21.
//

import UIKit
class MessageReceiverCell: UITableViewCell {
    
    //    MARK: VARIABLES
    //    ===============
    
    //    MARK: OUTLETS
    //    =============
    
    @IBOutlet weak var msgContainerView: UIView!
    @IBOutlet weak var msgLabel: UILabel!
    
    //    MARK: CELL LIFE CYCLE
    //    =====================
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        msgContainerView.roundCorners([.topLeft, .topRight, .bottomRight], radius: 15)
    }
    
}

//MARK: PRIVATE FUNCTIONS
//=======================
extension MessageReceiverCell {
    
    private func initialSetup() {
    }
    
}

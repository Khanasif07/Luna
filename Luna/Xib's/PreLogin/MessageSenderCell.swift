//
//  MessageSenderCell.swift
//  Luna
//
//  Created by Admin on 19/06/21.
//

import UIKit
class MessageSenderCell: UITableViewCell {
    
    @IBOutlet weak var senderMsgLbl: UILabel!
    @IBOutlet weak var dataContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dataContainerView.roundCorners([.topRight,.topLeft,.bottomLeft], radius: 15)
    }


}


//MARK: PRIVATE FUNCTIONS
//=======================
extension MessageSenderCell {
    
    private func initialSetup() {
       
    }
}

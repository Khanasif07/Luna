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
    
//    public func configureCellWith(model: Message) {
//        self.senderMsgLbl.text = model.messageText
//        self.senderImgView.setImage_kf(imageString: UserModel.main.image, placeHolderImage: #imageLiteral(resourceName: "placeHolder"), loader: false)
//        let date = model.messageTime.dateValue()
//        self.timeLbl.text = date.convertToTimeString()//"\(date.timeAgoSince)"
//        self.deliveredImgview.image = model.messageStatus < 2 ? #imageLiteral(resourceName: "icSingletick") : #imageLiteral(resourceName: "redTickOne")
//        self.readImageView.isHidden = model.messageStatus < 2
//        self.contentView.layoutIfNeeded()
//    }
}

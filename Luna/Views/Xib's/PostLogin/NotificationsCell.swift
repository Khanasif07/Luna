//
//  NotificationsCell.swift
//  Luna
//
//  Created by Admin on 10/01/22.
//

import UIKit

class NotificationsCell: UITableViewCell {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var timerLbl: UILabel!
    
    // MARK: - Variables
    //===========================
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpFont()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func setUpFont(){
        self.descLbl.font = AppFonts.SF_Pro_Display_Regular.withSize(.x14)
        self.timerLbl.font = AppFonts.SF_Pro_Display_Regular.withSize(.x12)
    }
    
    public func populateCell(model: NotificationModel){
        self.descLbl.text = model.description
        timerLbl.text = model.date?.getChatDateTimeFromTimeInterval(Date.DateFormat.hour12.rawValue)
    }
}

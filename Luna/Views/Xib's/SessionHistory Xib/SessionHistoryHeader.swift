//
//  ShopClosedHeader.swift
//  Excursity
//
//  Created by Atendra on 04/06/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import Foundation
import UIKit

class SessionHistoryHeader: UITableViewHeaderFooterView {
    
    // MARK: -IBOutlets
    //===========================
    @IBOutlet weak var haedingLbl: UILabel!
    
    // MARK: -Variables
    //===========================
    var month: String = ""  {
        didSet{
            switch month {
            case "1":
                haedingLbl.text = "January"
            case "2":
                haedingLbl.text = "Feb"
            case "3":
                haedingLbl.text = "March"
            case "4":
                haedingLbl.text = "April"
            case "5":
                haedingLbl.text = "May"
            case "6":
                haedingLbl.text = "June"
            case "7":
                haedingLbl.text = "July"
            case "8":
                haedingLbl.text = "August"
            case "9":
                haedingLbl.text = "September"
            case "10":
                haedingLbl.text = "October"
            case "11":
                haedingLbl.text = "November"
            case "12":
                haedingLbl.text = "December"
            default:
                haedingLbl.text = month
            }
        }
    }
    
    // MARK: -Life cycle
    //===========================
    override  func awakeFromNib() {
        super.awakeFromNib()
        self.setUpFont()
    }
    
    public func setUpFont(){
        self.haedingLbl.font = AppFonts.SF_Pro_Display_Medium.withSize(.x16)
    }

}

//
//  NotificationRowViewCell.swift
//  Luna
//
//  Created by Admin on 07/03/22.
//

import UIKit
import SwiftUI

class NotificationRowViewCell: UITableViewCell {
    
    init(model: NotificationModel) {
        super.init(style: .default, reuseIdentifier: "NotificationRowViewCell")
        let vc = UIHostingController(rootView: NotificationRowView(model: model))
        contentView.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        vc.view.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        vc.view.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        vc.view.backgroundColor = .clear
        
        accessoryType = .none
        selectionStyle = .none
    }
     
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

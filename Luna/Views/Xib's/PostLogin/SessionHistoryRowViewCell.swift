//
//  SessionHistoryRowViewCell.swift
//  Luna
//
//  Created by Admin on 09/03/22.
//

import Foundation
import SwiftUI

class SessionHistoryRowViewCell: UITableViewCell {
    
    init(model: SessionHistory) {
        super.init(style: .default, reuseIdentifier: "SessionHistoryRowViewCell")
        let vc = UIHostingController(rootView: SessionHistoryRowView(model: model))
        contentView.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        vc.view.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        vc.view.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        vc.view.backgroundColor = .clear
        
        accessoryType = .disclosureIndicator
        selectionStyle = .default
    }
     
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

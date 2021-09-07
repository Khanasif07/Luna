//
//  CoachMarkArrowView.swift
//  StaminaApp
//
//  Created by Aanchal on 17/04/20.
//  Copyright © 2020 Appinventiv. All rights reserved.
//

import UIKit

// Transparent coach mark (text without background, cool arrow)
internal class TransparentCoachMarkArrowView: UIImageView, CoachMarkArrowView {
    // MARK: - Initialization
    init(orientation: CoachMarkArrowOrientation) {
        if orientation == .top {
            super.init(image: UIImage(named: "rightImage"))
        } else {
            super.init(image: UIImage(named: "leftImage"))
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: 120).isActive = true
        heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.contentMode = .scaleAspectFit

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding.")
    }
}

//
//  LineDashedView.swift
//  Luna
//
//  Created by Admin on 09/07/21.
//

import UIKit
import Foundation

class LineDashedView: UIView {
    
    
    var dashBorder: CAShapeLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = AppColors.fontTertiaryColor.withAlphaComponent(0.5).cgColor
        shapeLayer.lineWidth = 2
        // passing an array with the values [2,3] sets a dash pattern that alternates between a 2-user-space-unit-long painted segment and a 3-user-space-unit-long unpainted segment
        shapeLayer.lineDashPattern = [2,3]
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: 0, y: self.frame.height)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
        self.dashBorder = shapeLayer
    }
}

//
//  UIScreen+Extension.swift
//  Luna
//
//  Created by Admin on 03/06/21.
//

import Foundation
import UIKit

extension UIScreen {
    static var width:CGFloat {
        return UIScreen.main.bounds.width
    }
    static var height:CGFloat {
        return UIScreen.main.bounds.height
    }
    static var size:CGSize {
        return UIScreen.main.bounds.size
    }
}

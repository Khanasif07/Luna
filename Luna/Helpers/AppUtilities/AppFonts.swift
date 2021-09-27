//
//  AppFonts.swift
//  Luna
//
//  Created by Admin on 03/06/21.
//

import Foundation
import UIKit


enum AppFonts : String {
    
    case SF_Pro_Display_Thin         = "SFProDisplay-Thin"
    case SF_Pro_Display_SemiboldItalic      = "SF-Pro-Display-SemiboldItalic"
    case SF_Pro_Display_RegularItalic               = "SF-Pro-Display-RegularItalic"
    case SF_Pro_Display_Light                    = "SFProDisplay-Light"
    case SF_Pro_Display_Regular  = "SFProDisplay-Regular"
    case SF_Pro_Display_Bold                   = "SFProDisplay-Bold"
    case SF_Pro_Display_Medium  = "SFProDisplay-Medium"
    case SF_Pro_Display_Semibold                = "SFProDisplay-Semibold"
    case SF_Pro_Display_Black                     = "SFProDisplay-Black"
}

//Custom font size
enum FontSize: CGFloat {
    case x8 = 8.0
    case x10 = 10.0
    case x12 = 12.0
    case x13 = 13.0
    case x15 = 15.0
    case x14 = 14.0
    case x16 = 16.0
    case x17 = 17.0
    case x18 = 18.0
    case x20 = 20.0
    case x22 = 22.0
    case x24 = 24.0
    case x26 = 26.0
    case x28 = 28.0
    case x30 = 30.0
    case x31 = 31.0
    case x32 = 32.0
    case x34 = 34.0
    case x44 = 44.0
    
}

extension AppFonts {
    
    func withSize(_ fontSize: FontSize) -> UIFont {
        let size = fontSize
        return UIFont(name: self.rawValue, size: size.rawValue) ?? UIFont.systemFont(ofSize: size.rawValue)
    }
    
    func withDefaultSize() -> UIFont {
        return UIFont(name: self.rawValue, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
    }
    
}

// USAGE : let font = AppFonts.Helvetica.withSize(13.0)
// USAGE : let font = AppFonts.Helvetica.withDefaultSize()
























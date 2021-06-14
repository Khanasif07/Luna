//
//  AppFonts.swift
//  Luna
//
//  Created by Admin on 03/06/21.
//

import Foundation
import UIKit


enum AppFonts : String {

    case MuliExtraLight              = "Muli-ExtraLight"
    case MuliExtraLightItalic        = "Muli-ExtraLightItalic"
    case MuliBoldItalic              = "Muli-BoldItalic"
    case MuliBlack                   = "Muli-Black"
    case MuliItalicVariableFontwght  = "Muli-Italic-VariableFont_wght"
    case MuliMedium                  = "Muli-Medium"
    case MuliMediumItalic            = "Muli-MediumItalic"
    case MuliExtraBold               = "Muli-ExtraBold"
    case MuliBold                    = "Muli-Bold"
    case MuliExtraBoldItalic         = "Muli-ExtraBoldItalic"
    case MuliItalic                  = "Muli-Italic"
    case MuliVariableFontwght        = "Muli-VariableFont_wght"
    case MuliSemiBold                = "Muli-SemiBold"
    case MuliSemiBoldItalic          = "Muli-SemiBoldItalic"
    case MuliBlackItalic             = "Muli-BlackItalic"
    case MuliLight                   = "Muli-Light"
    case MuliRegular                 = "Muli-Regular"
    case MuliLightItalic             = "Muli-LightItalic"
    
    case NunitoSansBold             = "NunitoSans-Bold"
    case NunitoSansRegular          = "NunitoSans-Regular"
    case NunitoSansLight            = "NunitoSans-Light"
    case NunitoSansItalic           = "NunitoSans-Italic"
    case NunitoSansSemiBold         = "NunitoSans-SemiBold"
    
    case NunitoSansBlack            = "NunitoSans-Black"
    case NunitoSansBlackItalic      = "NunitoSans-BlackItalic"
    case NunitoSansBoldItalic       = "NunitoSans-BoldItalic"
    case NunitoSansExtraBold        = "NunitoSans-ExtraBold"
    case NunitoSansExtraBoldItalic  = "NunitoSans-ExtraBoldItalic"

    
    
}

extension AppFonts {
    
    func withSize(_ fontSize: CGFloat) -> UIFont {
        var size = fontSize
        if UIScreen.width < 375{
            size = size - 2
        }
        return UIFont(name: self.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    func withDefaultSize() -> UIFont {
        return UIFont(name: self.rawValue, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
    }
    
}

// USAGE : let font = AppFonts.Helvetica.withSize(13.0)
// USAGE : let font = AppFonts.Helvetica.withDefaultSize()
























//
//  UILabelExtension.swift
//  Luna
//
//  Created by Admin on 03/06/21.
//
import Foundation
import UIKit
    
class InsetLabel: UILabel {
    
    var setTopInset = CGFloat(0)
    var setBottomInset = CGFloat(0)
    var setLeftInset = CGFloat(0)
    var setRightInset = CGFloat(0)
    
    override func drawText(in rect: CGRect) {
//        let insets: UIEdgeInsets = UIEdgeInsets(top: setTopInset, left: setLeftInset, bottom: setBottomInset, right: setRightInset)
//        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += setTopInset + setBottomInset
        intrinsicSuperViewContentSize.width += setLeftInset + setRightInset
        return intrinsicSuperViewContentSize
    }
    
    func edgeInsets(topInset: CGFloat, bottomInset: CGFloat, leftInset: CGFloat, rightInset: CGFloat) {
        
        setTopInset = topInset
        setBottomInset = bottomInset
        setLeftInset = leftInset
        setRightInset = rightInset
    }
    
//    func attributePolicyText(){
//        guard let text = self.text else { return }
//        let underlineAttriString = NSMutableAttributedString(string: text)
//        let range1 = (text as NSString).range(of: "Terms & Conditions")
//        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
//        let range2 = (text as NSString).range(of: "Privacy Policy")
//        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range2)
//        self.attributedText = underlineAttriString
//    }
    
}

extension UILabel {
    
    func applyGradientWith(startColor: UIColor, endColor: UIColor) -> Bool {
        
        var startColorRed:CGFloat = 0
        var startColorGreen:CGFloat = 0
        var startColorBlue:CGFloat = 0
        var startAlpha:CGFloat = 0
        
        if !startColor.getRed(&startColorRed, green: &startColorGreen, blue: &startColorBlue, alpha: &startAlpha) {
            return false
        }
        
        var endColorRed:CGFloat = 0
        var endColorGreen:CGFloat = 0
        var endColorBlue:CGFloat = 0
        var endAlpha:CGFloat = 0
        
        if !endColor.getRed(&endColorRed, green: &endColorGreen, blue: &endColorBlue, alpha: &endAlpha) {
            return false
        }
        
        let gradientText = self.text ?? ""
        
        let name:String = NSAttributedString.Key.font.rawValue
        let textSize: CGSize = gradientText.size(withAttributes: [NSAttributedString.Key(rawValue: name):self.font])
        let width:CGFloat = textSize.width
        let height:CGFloat = textSize.height
        
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return false
        }
        
        UIGraphicsPushContext(context)
        
        let glossGradient:CGGradient?
        let rgbColorspace:CGColorSpace?
        let num_locations:size_t = 2
        let locations:[CGFloat] = [ 0.0, 1.0 ]
        let components:[CGFloat] = [startColorRed, startColorGreen, startColorBlue, startAlpha, endColorRed, endColorGreen, endColorBlue, endAlpha]
        rgbColorspace = CGColorSpaceCreateDeviceRGB()
        glossGradient = CGGradient(colorSpace: rgbColorspace!, colorComponents: components, locations: locations, count: num_locations)
        let topCenter = CGPoint(x: 0, y: 0.5)
        let bottomCenter = CGPoint(x: 1, y: 0.5)
        context.drawLinearGradient(glossGradient!, start: topCenter, end: bottomCenter, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
        
        UIGraphicsPopContext()
        
        guard let gradientImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return false
        }
        
        UIGraphicsEndImageContext()
        
        self.textColor = UIColor(patternImage: gradientImage)
        
        return true
    }
    func calculateMaxLines(width:CGFloat? = nil) -> Int {
//        self.layoutIfNeeded()
        let maxSize = CGSize(width: width ?? frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: AppFonts.MuliRegular.withSize(13)], context: nil)
        let h = Float(textSize.height/charSize)
        let linesRoundedUp = Int(ceil(h))
        return linesRoundedUp
    }
}


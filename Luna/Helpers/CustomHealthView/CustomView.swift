//
//  CustomView.swift
//  Luna
//
//  Created by Admin on 12/10/21.
//
import UIKit
import Foundation

protocol CustomViewDelegate: class {
    func successBtnAction()
}



class CustomView: UIView {
    
    weak var delegate:CustomViewDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var messageText: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setUpColor()
        setUpAttributedString()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    private func setUpColor() {
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.addShadow(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
//       self.titleLabel.textColor = AppColors.themeTextColor
    }
    
    public func setUpAttributedString(){
        let attributedString = NSMutableAttributedString(string: "To modify which data Luna shares with Apple Health: " , attributes: [
            .font: AppFonts.SF_Pro_Display_Medium.withSize(.x14)
        ])
        let seriesText = (NSAttributedString(string: "\n1.", attributes: [NSAttributedString.Key.foregroundColor:  UIColor.black,NSAttributedString.Key.font: AppFonts.SF_Pro_Display_Medium.withSize(.x14)]))
        let openText = (NSAttributedString(string: " Open the Health App", attributes: [NSAttributedString.Key.foregroundColor: UIColor(r: 61, g: 201, b: 147, alpha: 1.0),NSAttributedString.Key.font: AppFonts.SF_Pro_Display_Bold.withSize(.x14)]))
        let decText = (NSAttributedString(string: "\n2. Select sources tab and select Luna App", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font: AppFonts.SF_Pro_Display_Medium.withSize(.x14)]))
        let decText1 = (NSAttributedString(string: "\n3. Set desired permissions", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font: AppFonts.SF_Pro_Display_Medium.withSize(.x14)]))
        attributedString.append(seriesText)
        attributedString.append(openText)
        attributedString.append(decText)
        attributedString.append(decText1)
        messageText.attributedText = attributedString
        messageText.isUserInteractionEnabled = true
        messageText.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.tapLabel(_:))))
        
    }
    
    @objc func tapLabel(_ gesture: UITapGestureRecognizer) {
        let string = "\(self.messageText.text ?? "")"
        if let range = string.range(of: "Open the Health App") {
            if gesture.didTapAttributedTextsInLabel(label: self.messageText, inRange: NSRange(range, in: string)) {
                self.delegate?.successBtnAction()
            }
        }
    }
    
}

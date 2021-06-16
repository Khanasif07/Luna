//
//  LoginSocialTableCell.swift
//  Luna
//
//  Created by Admin on 15/06/21.
//

import UIKit
import Foundation

class LoginSocialTableCell: UITableViewCell {

    //MARK:-IBOutlets

    @IBOutlet weak var appleBtnView: UIView!
    @IBOutlet weak var googleBtnView: UIView!
    @IBOutlet weak var appleBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var loginSocialLbl: UILabel!
    @IBOutlet weak var socialBtnStackView: UIStackView!

    //MARK:-Variables
    var appleBtnTapped: (()->())?
    var googleBtnTapped: (()->())?
    var loginBtnTapped: (()->())?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpAttributedString()
        self.setUpButtonInset()

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.googleBtnView.addShadow(cornerRadius: 4, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 4)
        self.appleBtnView.addShadow(cornerRadius: 4, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 4)
    }
    
    private func setUpAttributedString(){
        let attributedString = NSMutableAttributedString(string: LocalizedString.alreadyHaveAnAccount.localized, attributes: [
            .font: UIFont.systemFont(ofSize: 12.0),
            .foregroundColor: UIColor.black
        ])
        let privactAttText = (NSAttributedString(string: LocalizedString.login.localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor(r: 61, g: 201, b: 147, alpha: 1.0),NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13.0)]))
        attributedString.append(privactAttText)
        loginSocialLbl.attributedText = attributedString
        loginSocialLbl.isUserInteractionEnabled = true
        loginSocialLbl.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.tapLabel(_:))))
        
    }
    
    @objc func tapLabel(_ gesture: UITapGestureRecognizer) {
        let string = "\(self.loginSocialLbl.text ?? "")"
        let termsAndCondition = LocalizedString.login.localized
        if let range = string.range(of: termsAndCondition) {
            if gesture.didTapAttributedTextsInLabel(label: self.loginSocialLbl, inRange: NSRange(range, in: string)) {
                if let handle = loginBtnTapped{
                    handle()
                }
            }
        }
    }
    
    public func setUpButtonInset(){
        googleBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 0)
        appleBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 0)
    }
    
    @IBAction func googleBtnAction(_ sender: UIButton) {
        googleBtnTapped?()
    }
    
    @IBAction func appleBtnAction(_ sender: UIButton) {
        appleBtnTapped?()
    }
    
}
 

extension UITapGestureRecognizer {
    func didTapAttributedTextsInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * CGFloat(0.5) - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * CGFloat(0.5) - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

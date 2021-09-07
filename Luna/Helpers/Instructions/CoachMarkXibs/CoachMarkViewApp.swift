//
//  CoachMarkViewApp.swift
//  StaminaApp
//
//  Created by Aanchal Bansal on 17/04/20.
//  Copyright © 2020 Appinventiv. All rights reserved.
//

import UIKit

class CoachMarkViewApp: UIView , CoachMarkBodyView {
    
    // MARK: - Internal properties
    var nextControl: UIControl? {
        get {
            return self.nextButton
        }
    }
    
    var highlighted: Bool = false
    
    @IBOutlet weak var outerView : UIView!
    @IBOutlet weak var hintLabel: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    
    weak var highlightArrowDelegate: CoachMarkBodyHighlightArrowDelegate? = nil
    
    class var identifier: String {
        return String(describing: self)
    }
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    //MARK:- LIFE CYCLE
    //=================
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit(){
        self.setViewAppearence()
        
        self.hintLabel.isScrollEnabled = false
//        self.hintLabel.layoutManager.hyphenationFactor = 1.0
        self.hintLabel.isEditable = false
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.clear

        self.clipsToBounds = false
    }
    
    private func setViewAppearence() {
        Bundle.main.loadNibNamed(CoachMarkViewApp.identifier, owner: self, options: nil)
        addSubview(outerView)
        self.outerView.frame = self.bounds
        self.outerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

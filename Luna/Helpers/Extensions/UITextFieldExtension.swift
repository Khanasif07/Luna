//
//  UITextFieldExtension.swift
//  Luna
//
//  Created by Admin on 03/06/21.
//

import Foundation
import UIKit

private var rightViews = NSMapTable<UITextField, UIView>(keyOptions: NSPointerFunctions.Options.weakMemory, valueOptions: NSPointerFunctions.Options.strongMemory)
private var errorViews = NSMapTable<UITextField, UIView>(keyOptions: NSPointerFunctions.Options.weakMemory, valueOptions: NSPointerFunctions.Options.strongMemory)


extension UITextField{
    
    ///Sets and gets if the textfield has secure text entry
    var isSecureText:Bool{
        get{
            return self.isSecureTextEntry
        }
        set{
            let font = self.font
            self.isSecureTextEntry = newValue
            if let text = self.text{
                self.text = ""
                self.text = text
            }
            self.font = nil
            self.font = font
            self.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        }
    }
    
    ///Returns the text contained in textfield without unwrapping
    var textValue : String {
        return self.text ?? ""
    }
    
    // STOP SPECIAL CHARACTERS
    //===========================
    func stopSpecialCharacters() {
        let ACCEPTABLE_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.@"
        let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered: String = (text!.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
        
        if text != filtered {
            text?.removeLast()
        }
    }
    // SET IMAGE TO LEFT VIEW
    //=========================
    func setImageToLeftView(img : UIImage, size: CGSize?) {
        
        self.leftViewMode = .always
        let leftImage = UIImageView(image: img)
        self.leftView = leftImage
        
        leftImage.contentMode = UIView.ContentMode.center
        if let imgSize = size {
            self.leftView?.frame.size = imgSize
        } else {
            self.leftView?.frame.size = CGSize(width: 50, height: self.frame.height)
        }
        leftImage.frame = self.leftView!.frame
    }
    
    // SET IMAGE TO RIGHT VIEW
    //=========================
    func setImageToRightView(img : UIImage, size: CGSize?) {
        
        self.rightViewMode = .always
        let rightImage = UIImageView(image: img)
        self.rightView = rightImage
        
        rightImage.contentMode = UIView.ContentMode.center
        if let imgSize = size {
            self.rightView?.frame.size = imgSize
        } else {
            self.rightView?.frame.size = CGSize(width: 20, height: self.frame.height)
        }
        rightImage.frame = self.rightView!.frame
    }
    
    func setupPasswordTextField() {
        self.isSecureText = true
        self.keyboardType = .asciiCapable
        self.isSecureTextEntry = self.isSecureText
        
        let showButton = UIButton()
        showButton.addTarget(self, action: #selector(self.showButtonTapped(_:)), for: .touchUpInside)
        self.setButtonToRightView(btn: showButton, selectedImage:  #imageLiteral(resourceName: "icPasswordHide"), normalImage: #imageLiteral(resourceName: "icPasswordView"), size: CGSize(width: 20, height: 20))
    }
    
    /// Show Button Tapped
    @objc private func showButtonTapped(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        self.isSecureText = !self.isSecureText
    }
    
    // SET BUTTON TO RIGHT VIEW
    //=========================
    func setButtonToRightView(btn : UIButton, selectedImage : UIImage?, normalImage : UIImage?, size: CGSize?) {
        
        self.rightViewMode = .always
        self.rightView = btn
        
        btn.isSelected = false
        
        if let selectedImg = selectedImage { btn.setImage(selectedImg, for: .selected) }
        if let unselectedImg = normalImage { btn.setImage(unselectedImg, for: .normal) }
        if let btnSize = size {
            self.rightView?.frame.size = btnSize
        } else {
            self.rightView?.frame.size = CGSize(width: btn.intrinsicContentSize.width+10, height: self.frame.height)
        }
    }
    
    // SET PADDING IMAGEVIEW TO LEFT VIEW
    //===================================
    func setLeftPaddingView(size: CGSize) {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 2, width: size.width, height: size.height)
        self.leftViewMode = UITextField.ViewMode.always
        self.addSubview(imageView)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: self.frame.height))
        self.leftView = paddingView
    }
    
    // SET DROP DOWN IMAGEVIEW TO RIGHT VIEW
    //======================================
    func setDropDownView(image: UIImage?, imgSize: CGSize, containerSize: CGSize) {
        let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: imgSize.width, height: imgSize.height)) // set your Own size
        iconView.image = image
        iconView.contentMode = .center
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: imgSize.width, height: imgSize.height))
        iconContainerView.addSubview(iconView)
        self.setViewToRightView(view: iconContainerView, size: containerSize)
    }
    
    func setLeftImgView(image: UIImage?, imgSize: CGSize, containerSize: CGSize) {
        let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: imgSize.width, height: imgSize.height)) // set your Own size
        iconView.image = image
        iconView.contentMode = .center
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: imgSize.width, height: imgSize.height))
        iconContainerView.addSubview(iconView)
        self.setViewToLeftView(view: iconContainerView, size: containerSize)
    }
    
    // SET VIEW TO LEFT VIEW
    //=========================
    func setViewToLeftView(view : UIView, size: CGSize?) {
        
        self.leftViewMode = .always
        self.leftView = view
        
        if let btnSize = size {
            self.leftView?.frame.size = btnSize
        } else {
            self.leftView?.frame.size = CGSize(width: view.intrinsicContentSize.width+10, height: self.frame.height)
        }
    }
    
    // SET VIEW TO RIGHT VIEW
    //=========================
    func setViewToRightView(view : UIView, size: CGSize?) {
        
        self.rightViewMode = .always
        self.rightView = view
        
        if let btnSize = size {
            self.rightView?.frame.size = btnSize
        } else {
            self.rightView?.frame.size = CGSize(width: view.intrinsicContentSize.width+10, height: self.frame.height)
        }
    }
    
    /// CREATE DATE PICKER
    //=========================
    func createDatePicker(start: Date?, end: Date?, current: Date, didSelectDate: @escaping ((Date) -> Void)) {
        
        guard inputView == nil else { return }
        
        var datePicker = UIDatePicker()
        
        // DatePicker
        datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216))
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.minimumDate = start
        datePicker.maximumDate = end
        datePicker.setDate(current, animated: true)
        self.inputView = datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        //        let doneButton = UIBarButtonItem(title: "Done", style: .plain) { (_) in
        //
        ////            self.text = datePicker.date.convertToString()
        //            self.resignFirstResponder()
        //
        //            didSelectDate(datePicker.date)
        //        }
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain) { (_) in
        //            self.resignFirstResponder()
        //        }
        //        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.inputAccessoryView = toolBar
    }
    
    
    func togglePasswordVisibility() {
        isSecureTextEntry = !isSecureTextEntry
        
        if let existingText = text, isSecureTextEntry {
            deleteBackward()
            
            if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
                replace(textRange, withText: existingText)
            }
        }
        
        if let existingSelectedTextRange = selectedTextRange {
            selectedTextRange = nil
            selectedTextRange = existingSelectedTextRange
        }
    }
    
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}


//MARK: - SETTING AND DISPLAYING ERROR IN TEXTFIELD
//=================================================

extension UITextField {
    // Add/remove error message
    func setError(_ string: String? = nil, show: Bool = true) {
        
        var labelFontSize = 12
        
        if let rightView = rightView, rightView.tag != 999 {
            rightViews.setObject(rightView, forKey: self)
        }
        
        // Remove message
        guard string != nil else {
            if let rightView = rightViews.object(forKey: self) {
                self.rightView = rightView
                rightViews.removeObject(forKey: self)
            } else {
                self.rightView = nil
            }
            
            if let errorView = errorViews.object(forKey: self) {
                errorView.isHidden = true
                errorViews.removeObject(forKey: self)
            }
            
            return
        }
        
        // Create container
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        // Create triangle
        //        let triangle = TriangleTop()
        //        triangle.backgroundColor = .clear
        //        triangle.translatesAutoresizingMaskIntoConstraints = false
        //        container.addSubview(triangle)
        
        // Create red line
        let line = UIView()
        line.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        line.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(line)
        
        if UIScreen.main.bounds.height < 667 {
            labelFontSize = 12
        }
        
        // Create message
        let label = UILabel()
        label.text = string
        label.textColor = .white
        label.numberOfLines = 0
        label.font = self.font ?? AppFonts.SF_Pro_Display_Regular.withSize(.x12)
        label.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        label.backgroundColor = .clear
        label.textAlignment = .right
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 250), for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        
        // Set constraints for triangle
        //        triangle.heightAnchor.constraint(equalToConstant: 10).isActive = true
        //        triangle.widthAnchor.constraint(equalToConstant: 15).isActive = true
        //        triangle.topAnchor.constraint(equalTo: container.topAnchor, constant: -10).isActive = true
        //        triangle.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15).isActive = true
        
        // Set constraints for line
        line.heightAnchor.constraint(equalToConstant: 3).isActive = true
        line.topAnchor.constraint(equalTo: container.topAnchor, constant: 0).isActive = true
        line.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true
        line.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0).isActive = true
        
        // Set constraints for label
        label.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -7.0).isActive = true
        //        label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true
        label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0).isActive = true
        label.widthAnchor.constraint(equalToConstant: self.superview!.width).isActive = true
        
        if !show {
            container.isHidden = true
        }
        
        if let superview = self.superview {
            superview.addSubview(container)
        } else {
            self.addSubview(container)
        }
        
        //        self.addSubview(container)
        //        UIApplication.shared.keyWindow!.addSubview(container)
        
        // Set constraints for container
        container.widthAnchor.constraint(lessThanOrEqualTo: superview!.widthAnchor, multiplier: 1).isActive = true
        container.trailingAnchor.constraint(equalTo: superview!.trailingAnchor, constant: 0).isActive = true
        container.bottomAnchor.constraint(equalTo: superview!.topAnchor, constant: 0).isActive = true
        
        // Hide other error messages
        let enumerator = errorViews.objectEnumerator()
        while let view = enumerator!.nextObject() as! UIView? {
            view.isHidden = true
        }
        
        // Add right button to textField
//        let errorButton = UIButton(type: .custom)
//        errorButton.isHidden = true
//        errorButton.tag = 999
//        errorButton.setImage(nil, for: .normal)
//        errorButton.frame = CGRect(x: 0, y: 0, width: frame.size.height, height: frame.size.height)
//        errorButton.addTarget(self, action: #selector(errorAction), for: .touchUpInside)
//        rightView = errorButton
//        rightViewMode = .always

        // Save view with error message
        errorViews.setObject(container, forKey: self)
    }
    
    // Show error message
    
//    @objc func errorAction(_ sender: Any) {
//        let errorButton = sender as! UIButton
//        let textField = errorButton.superview as! UITextField
//
//        let errorView = errorViews.object(forKey: textField)
//        if let errorView = errorView {
//            errorView.isHidden.toggle()
//        }
//
//        let enumerator = errorViews.objectEnumerator()
//        while let view = enumerator!.nextObject() as! UIView? {
//            if view != errorView {
//                view.isHidden = true
//            }
//        }
//
//        //         Don't hide keyboard after click by icon
//        //        UIViewController.isCatchTappedAround = false
//        //        self.endEditing(false)
//    }
}

class TriangleTop: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.beginPath()
        context.move(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: (rect.minX / 2.0), y: rect.maxY))
        context.closePath()
        
        context.setFillColor(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1).cgColor)
        context.fillPath()
    }
}

//MARK:- OTP TEXTFIELD DELEGATE
//=============================
protocol OTPTextFieldDelegate: class {
    
    func deleteBackward(index: Int)
}

//MARK:- OTP TEXTFIELD DECALARATION
//=================================
class OTPTextField: UITextField {
    
    weak var otpDelegate: OTPTextFieldDelegate?
    
    override func deleteBackward() {
        super.deleteBackward()
        otpDelegate?.deleteBackward(index: self.tag)
    }
}


class AppTextField: UITextField{
    
    let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

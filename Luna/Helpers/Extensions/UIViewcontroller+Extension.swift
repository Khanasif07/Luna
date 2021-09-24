//
//  UIViewcontroller+Extension.swift
//  Luna
//
//  Created by Admin on 03/06/21.
//

import Foundation
import UIKit
import AssetsLibrary
import AVFoundation
import Photos
import NVActivityIndicatorView
import MobileCoreServices

protocol RemovePictureDelegate{
    func removepicture()
}

extension UIViewController {
    
    func topMostViewController() -> UIViewController {
           if self.presentedViewController == nil {
               return self
           }
           if let navigation = self.presentedViewController as? UINavigationController {
            return (navigation.visibleViewController?.topMostViewController())  ?? navigation
           }
           if let tab = self.presentedViewController as? UITabBarController {
               if let selectedTab = tab.selectedViewController {
                   return selectedTab.topMostViewController()
               }
               return tab.topMostViewController()
           }
           return self.presentedViewController!.topMostViewController()
       }
    
    typealias ImagePickerDelegateController = (UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate)
    
    func captureImage(delegate controller: ImagePickerDelegateController,docPickDelegate: UIDocumentPickerDelegate? = nil,
                      photoGallery: Bool = true,
                      camera: Bool = true,
                      removedImagePicture : Bool = false,
                      mediaType : [String] = [kUTTypeImage as String],
                      maxDuration: Double = 15,isDocumentPick: Bool = false) {
        
        let chooseOptionText =  LocalizedString.chooseOptions.localized
        let alertController = UIAlertController(title: chooseOptionText, message: nil, preferredStyle: .actionSheet)
        
        if photoGallery {
            
            let chooseFromGalleryText =  LocalizedString.chooseFromGallery.localized
            let alertActionGallery = UIAlertAction(title: chooseFromGalleryText, style: .default) { _ in
                self.checkAndOpenLibrary(delegate: controller, mediaType: mediaType, maxDuration: maxDuration)
            }
            alertController.addAction(alertActionGallery)
        }
        
        if camera {
            
            let takePhotoText = LocalizedString.takePhoto.localized
            let alertActionCamera = UIAlertAction(title: takePhotoText, style: .default) { action in
                self.checkAndOpenCamera(delegate: controller, mediaType: mediaType, maxDuration: maxDuration)
            }
            alertController.addAction(alertActionCamera)
        }
        if removedImagePicture{
            let removePic = LocalizedString.removePicture.localized
            let alertActionRemove = UIAlertAction(title: removePic, style: .default) { action in
                if let vc = controller as? RemovePictureDelegate{
                    vc.removepicture()
                }
            }
            alertController.addAction(alertActionRemove)
        }
        
        if isDocumentPick {
            let pickPdf = LocalizedString.choosePdf.localized
            let alertActionPdf = UIAlertAction(title: pickPdf, style: .default) { action in
                guard let docPickDelegate = docPickDelegate else {return}
                self.pickDoc(delegate: docPickDelegate)
                
            }
            alertController.addAction(alertActionPdf)
        }
        
        let cancelText =  LocalizedString.cancel.localized
        let alertActionCancel = UIAlertAction(title: cancelText, style: .cancel) { _ in
        }
        alertController.addAction(alertActionCancel)
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    func checkAndOpenCamera(delegate controller: ImagePickerDelegateController,mediaType : [String] = [kUTTypeImage as String],maxDuration: Double) {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
            
        case .authorized:
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = controller
            imagePicker.mediaTypes = mediaType
            imagePicker.videoMaximumDuration = maxDuration
            imagePicker.modalPresentationStyle = .overFullScreen
            let sourceType = UIImagePickerController.SourceType.camera
            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                
                imagePicker.sourceType = sourceType
                imagePicker.allowsEditing = true
                
                if imagePicker.sourceType == .camera {
                    imagePicker.showsCameraControls = true
                }
                controller.present(imagePicker, animated: true, completion: nil)
                
            } else {
                
                let cameraNotAvailableText = "Camera Not Available"
                self.showAlert(title: "Error", msg: cameraNotAvailableText)
            }
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { granted in
                
                if granted {
                    
                    DispatchQueue.main.async {
                        let imagePicker = UIImagePickerController()
                        imagePicker.delegate = controller
                        imagePicker.mediaTypes = mediaType
                        imagePicker.videoMaximumDuration = maxDuration
                        
                        let sourceType = UIImagePickerController.SourceType.camera
                        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                            
                            imagePicker.sourceType = sourceType
                            if imagePicker.sourceType == .camera {
                                imagePicker.allowsEditing = true
                                imagePicker.showsCameraControls = true
                            }
                            controller.present(imagePicker, animated: true, completion: nil)
                            
                        } else {
                            let cameraNotAvailableText = "Camera Not Available"
                            self.showAlert(title: "Error", msg: cameraNotAvailableText)
                        }
                    }
                }
            })
            
        case .restricted:
            alertPromptToAllowCameraAccessViaSetting("Restricted From Using Camera")
            
        case .denied:
            alertPromptToAllowCameraAccessViaSetting("Change Privacy Setting And Allow Access To Camera")
        @unknown default:
            break
        }
    }
    
    func checkAndOpenLibrary(delegate controller: ImagePickerDelegateController,mediaType : [String] = [kUTTypeImage as String],maxDuration: Double) {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
            
        case .notDetermined:
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = controller
            imagePicker.mediaTypes = mediaType
            let sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = true
            imagePicker.videoMaximumDuration = maxDuration
            imagePicker.modalPresentationStyle = .overFullScreen
            imagePicker.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            controller.present(imagePicker, animated: true, completion: nil)
            
        case .restricted:
            alertPromptToAllowCameraAccessViaSetting("Restricted From Using Library")
            
        case .denied:
            alertPromptToAllowCameraAccessViaSetting("Change Privacy Setting And Allow Access To Library")
        case .limited:
            break
        case .authorized:
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = controller
            let sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = true
            imagePicker.mediaTypes = mediaType
            imagePicker.videoMaximumDuration = maxDuration
            imagePicker.modalPresentationStyle = .overFullScreen
            imagePicker.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            controller.present(imagePicker, animated: true, completion: nil)
        @unknown default:
            break
        }
    }
    
    func pickDoc(delegate controller: UIDocumentPickerDelegate, mediaType : [String] = [kUTTypeImage as String]){
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = controller
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    private func alertPromptToAllowCameraAccessViaSetting(_ message: String) {
        
        let alertText = LocalizedString.alert.localized
        let cancelText = LocalizedString.cancel.localized
        let settingsText = LocalizedString.settings.localized
        
        let alert = UIAlertController(title: alertText, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: settingsText, style: .default, handler: { (action) in
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
            }
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: cancelText, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    ///Adds Child View Controller to Parent View Controller
    func add(childViewController:UIViewController){
        
        self.addChild(childViewController)
        childViewController.view.frame = self.view.bounds
        self.view.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
    }
    
    ///Removes Child View Controller From Parent View Controller
    var removeFromParent:Void{
        
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    ///Updates navigation bar according to given values
    func updateNavigationBar(withTitle title:String? = nil, leftButton:UIBarButtonItem? = nil, rightButton:UIBarButtonItem? = nil, tintColor:UIColor? = nil, barTintColor:UIColor? = nil, titleTextAttributes: [NSAttributedString.Key : Any]? = nil){
        
        self.navigationController?.isNavigationBarHidden = false
        if let tColor = barTintColor{
            self.navigationController?.navigationBar.barTintColor = tColor
        }
        if let tColor = tintColor{
            self.navigationController?.navigationBar.tintColor = tColor
        }
        if let button = leftButton{
            self.navigationItem.leftBarButtonItem = button;
        }
        if let button = rightButton{
            self.navigationItem.rightBarButtonItem = button;
        }
        if let ttle = title{
            self.navigationItem.title = ttle
        }
        if let ttleTextAttributes = titleTextAttributes{
            self.navigationController?.navigationBar.titleTextAttributes =   ttleTextAttributes
        }
    }
    
    ///Updates navigation bar according to given values
    func updateNavigationBar(withTitle title:String? = nil, leftButton:[UIBarButtonItem]? = nil, rightButtons:[UIBarButtonItem]? = nil, tintColor:UIColor? = nil, barTintColor:UIColor? = nil, titleTextAttributes: [NSAttributedString.Key : Any]? = nil){
        self.navigationController?.isNavigationBarHidden = false
        if let tColor = barTintColor {
            self.navigationController?.navigationBar.barTintColor = tColor
        }
        if let tColor = tintColor {
            self.navigationController?.navigationBar.tintColor = tColor
        }
        if let button = leftButton {
            self.navigationItem.leftBarButtonItems = button;
        }
        if let rightBtns = rightButtons {
            self.navigationItem.rightBarButtonItems = rightBtns
        }
        if let ttle = title {
            self.navigationItem.title = ttle
        }
        if let ttleTextAttributes = titleTextAttributes{
            self.navigationController?.navigationBar.titleTextAttributes =   ttleTextAttributes
        }
    }
    
    
    ///Not using static as it won't be possible to override to provide custom storyboardID then
    class var storyboardID : String {
        
        return "\(self)"
    }
    
    //function to pop the target from navigation Stack
    @objc func pop(animated:Bool = true) {
        _ = self.navigationController?.popViewController(animated: animated)
    }
    
    func popToSpecificViewController(atIndex index:Int, animated:Bool = true) {
        
        if let navVc = self.navigationController, navVc.viewControllers.count > index{
            
            _ = self.navigationController?.popToViewController(navVc.viewControllers[index], animated: animated)
        }
    }
    
    func showAlert( title : String = "", msg : String,_ completion : (()->())? = nil) {
        let titleFont = [NSAttributedString.Key.font: AppFonts.SF_Pro_Display_Regular.withSize(.x16)]
        let messageFont = [NSAttributedString.Key.font: AppFonts.SF_Pro_Display_Regular.withSize(.x14)]
        
        _ = NSMutableAttributedString(string: title, attributes: titleFont)
        _ = NSMutableAttributedString(string: msg, attributes: messageFont)
        DispatchQueue.main.async {
            let alertViewController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (action : UIAlertAction) -> Void in
                alertViewController.dismiss(animated: true, completion: nil)
                completion?()
            }
            alertViewController.addAction(okAction)
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    func showAlertWithAction( title : String = "",
                              msg : String,
                              cancelTitle : String = LocalizedString.cancel.localized,
                              actionTitle : String = LocalizedString.ok.localized,
                              actioncompletion : (()->())? = nil,
                              cancelcompletion : (()->())? = nil) {
        let titleFont = [NSAttributedString.Key.font: AppFonts.SF_Pro_Display_Regular.withSize(.x16)]
        let messageFont = [NSAttributedString.Key.font: AppFonts.SF_Pro_Display_Regular.withSize(.x14)]
        
        _ = NSMutableAttributedString(string: title, attributes: titleFont)
        _ = NSMutableAttributedString(string: msg, attributes: messageFont)
        DispatchQueue.main.async {
            let alertViewController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default) { (action : UIAlertAction) -> Void in
                
                alertViewController.dismiss(animated: true, completion: nil)
                actioncompletion?()
            }
            let cancelAction = UIAlertAction(title: cancelTitle, style: UIAlertAction.Style.cancel) { (action : UIAlertAction) -> Void in
                
                alertViewController.dismiss(animated: true, completion: nil)
                cancelcompletion?()
            }
            alertViewController.addAction(okAction)
            alertViewController.addAction(cancelAction)
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    func alertPromptToAllowAccessViaSetting(_ message: String) {
        
        let alertText = LocalizedString.alert.localized
        let cancelText = LocalizedString.cancel.localized
        let settingsText = LocalizedString.settings.localized
        
        let alert = UIAlertController(title: alertText, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: settingsText, style: .default, handler: { (action) in
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
            }
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: cancelText, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Start Loader
    func startNYLoader() {
        let view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.type = .ballSpinFadeLoader
        view.tag = 101
        view.color = AppColors.appGreenColor
        view.padding =  160
        view.startAnimating()
        self.view.addSubview(view)
    }
    
    func stopAnimating() {
        if let lastView = self.view.subviews.last {
            if lastView.tag == 101 {
            lastView.removeFromSuperview()
            }
        }
    }
    
    // Keyboard appearing notifications
    func registerForKeyboardWillShowNotification(_ scrollView: UIScrollView, usingBlock block: ((CGSize?) -> Void)? = nil) {
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil, using: { notification -> Void in
            let userInfo = notification.userInfo!
            let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
            let keyHt =  keyboardSize.height - (keyboardSize.height > 200 ? 70 : 50)
            let contentInsets = UIEdgeInsets(top: scrollView.contentInset.top, left: scrollView.contentInset.left, bottom: keyHt, right: scrollView.contentInset.right)
            
            scrollView.setContentInsetAndScrollIndicatorInsets(contentInsets)
            block?(keyboardSize)
        })
    }
    
    // Keyboard hising notifications
    func registerForKeyboardWillHideNotification(_ scrollView: UIScrollView, usingBlock block: ((CGSize?) -> Void)? = nil) {
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil, using: { notification -> Void in
            let userInfo = notification.userInfo!
            let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
            let contentInsets = UIEdgeInsets(top: scrollView.contentInset.top, left: scrollView.contentInset.left, bottom: 0, right: scrollView.contentInset.right)
            
            scrollView.setContentInsetAndScrollIndicatorInsets(contentInsets)
            block?(keyboardSize)
        })
    }
    
    func isEmailValid(string: String?) -> (Bool,String) {
        if let email = string, !email.isEmpty {
            if email.count < 3 {
                return (false, "Please enter a valid email address.")
            } else if email.checkIfInvalid(.email) {
                return (false, "Please enter a valid email address.")
            }
        } else {
            return (false, "Please enter a email address.")
        }
        return (true,"")
    }
    
    func isPassValid(string: String?) -> (Bool,String) {
        if let pass = string, !pass.isEmpty {
            if pass.count < 6 {
                return (false, "Password must contain at least 6 char.")
            }
        } else {
            return (false, "Please enter a password.")
        }
        return (true,"")
    }
    
}

extension UIScrollView {
    
    func setContentInsetAndScrollIndicatorInsets(_ edgeInsets: UIEdgeInsets) {
        self.contentInset = edgeInsets
        self.scrollIndicatorInsets = edgeInsets
    }
}

extension UINavigationController {

    func popToViewControllerOfType(classForCoder: AnyClass) {
        for controller in viewControllers {
            if controller.classForCoder == classForCoder {
                popToViewController(controller, animated: true)
                break
            }
        }
    }

    func popViewControllers(controllersToPop: Int, animated: Bool) {
        if viewControllers.count > controllersToPop {
            popToViewController(viewControllers[viewControllers.count - (controllersToPop + 1)], animated: animated)
        } else {
            print("Trying to pop \(controllersToPop) view controllers but navigation controller contains only \(viewControllers.count) controllers in stack")
        }
    }
    
}

extension UINavigationController: UIGestureRecognizerDelegate {

    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}


// MARK: - UInavigationViewController Extension
//======================================================
extension UINavigationController {
    public func hasViewController(ofKind kind: AnyClass) -> UIViewController? {
        return self.viewControllers.first(where: {$0.isKind(of: kind)})
    }
}

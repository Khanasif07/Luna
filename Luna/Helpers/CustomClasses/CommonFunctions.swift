//
//  CommonFunctions.swift
//  Luna
//
//  Created by Admin on 16/06/21.
//

import UIKit
import NVActivityIndicatorView
import MobileCoreServices
import AVFoundation
import Toaster
import AVKit

class CommonFunctions {

    /// Show Toast With Message
    static func showToastWithMessage(_ msg: String, completion: (() -> Swift.Void)? = nil) {
        DispatchQueue.mainQueueAsync {
            ToastView.appearance().font = UIFont.systemFont(ofSize: 14.0)
            ToastView.appearance().textColor = .white
            ToastView.appearance().backgroundColor = .black
            if msg.count > 60 {
                let toast = Toast(text: msg, delay: 0.3, duration: 2)
                toast.show()
            } else {
                let toast = Toast(text: msg, delay: 0.3, duration: 2)
                toast.show()
            }
        }
    }
    
    
    /// Delay Functions
    class func delay(delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when) {
            closure()
            
        }
    }
    
    /// Show Action Sheet With Actions Array
    class func showActionSheetWithActionArray(_ title: String?, message: String?,
                                              viewController: UIViewController,
                                              alertActionArray : [UIAlertAction],
                                              preferredStyle: UIAlertController.Style)  {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        alertActionArray.forEach{ alert.addAction($0) }
        
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    /// Show Activity Loader
    class func showActivityLoader() {
        DispatchQueue.mainQueueAsync {
//            if let nav = AppDelegate.shared.window?.rootViewController as? UINavigationController {
//                if let topVC = nav.viewControllers.last?.presentedViewController{
//                    topVC.startNYLoader()
//                    return
//                }
//            }
            if let vc = AppDelegate.shared.window?.rootViewController {
//                if let presentedVC = vc.presentingViewController{
//                    presentedVC.startNYLoader()
//                    return
//                }
                vc.startNYLoader()
            }
        }
    }
    
    /// Hide Activity Loader
    class func hideActivityLoader() {
        DispatchQueue.mainQueueAsync {
            if let vc = AppDelegate.shared.window?.rootViewController {
//                if let nav = AppDelegate.shared.window?.rootViewController as? UINavigationController {
//                    if let topVC = nav.viewControllers.last?.presentedViewController{
//                        topVC.stopAnimating()
//                        return
//                    }
//                }
//                if let presentedVC = vc.presentingViewController{
//                    presentedVC.stopAnimating()
//                    return
//                }
                vc.stopAnimating()
            }
        }
    }
    
    static func getAccessToken() -> String{
        let token = AppUserDefaults.value(forKey: .accesstoken).stringValue
        return token
    }
    
    //get country Code from Locale
//    class func getCountryCode() -> String {
//
//           let networkInfo = CTTelephonyNetworkInfo()
//
//           if let carrier = networkInfo.subscriberCellularProvider {
//            if let isoCountryCode = carrier.isoCountryCode {
//                for dict in countryData {
//                    guard let code = dict["code"] else {return "91"}
//                    if isoCountryCode.lowercased() == code.lowercased() {
//
//                        return dict["phoneCode"] ?? "91"
//                    }
//                }
//              }
//           }
//
//        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
//            for dict in countryData {
//                guard let code = dict["code"] else {return "91"}
//                if countryCode.lowercased() == code.lowercased() {
//
//                    return dict["phoneCode"] ?? "91"
//                }
//            }
//        }
//        return "+91"
//    }
    
    class func leftViewModeWithPadding(image:UIImage,height:CGFloat,width:CGFloat,leading:CGFloat,gap:CGFloat)->UIView{
              let outerView = UIView(frame: CGRect(x: 0, y: 0, width: Int(width+leading+gap), height: 16) )
              let iconView  = UIImageView(frame: CGRect(x: leading, y: 0, width: width, height: height))
              iconView.image = image
              outerView.addSubview(iconView)
           return outerView
    }
    class func rightViewModeWithPadding(image:UIImage,height:CGFloat,width:CGFloat,trailing:CGFloat)->UIView{
                 let outerView = UIView(frame: CGRect(x: 0, y: 0, width: Int(width+trailing), height: 16) )
                 let iconView  = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                 iconView.image = image
                 outerView.addSubview(iconView)
              return outerView
       }
    
    // to add the underline to the text
    class func addStringUnderLine(text:String,color:UIColor)->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: text)
              let attributes:[NSAttributedString.Key:Any]=[
                  .foregroundColor: color,.underlineStyle: 1,NSAttributedString.Key.underlineColor:color]
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
}

//
//  UIApplicationExtension.swift
//  Luna
//
//  Created by Admin on 03/06/21.
//

import Foundation
import UIKit

extension UIApplication {
    
    ///Opens Settings app
    @nonobjc class var openSettingsApp: Void {
        
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            } else {
                UIApplication.shared.openURL(settingsUrl)
            }
        }
    }
    
    ///Disables the ideal timer of the application
    @nonobjc class var disableApplicationIdleTimer: Void {
        self.shared.isIdleTimerDisabled = true
    }
    
    ///Enables the ideal timer of the application
    @nonobjc class var enableApplicationIdleTimer: Void {
        self.shared.isIdleTimerDisabled = false
    }
    
    ///Can get & set application icon badge number
    @nonobjc class var appIconBadgeNumber: Int {
        get {
            return UIApplication.shared.applicationIconBadgeNumber
        }
        set {
            UIApplication.shared.applicationIconBadgeNumber = newValue
        }
    }
    
    var visibleViewController: UIViewController? {
        guard let rootViewController = UIWindow.key?.rootViewController else {
            return nil
        }
        return getVisibleViewController(rootViewController)
    }
    
    private func getVisibleViewController(_ rootViewController: UIViewController) -> UIViewController? {
        
        if let presentedViewController = rootViewController.presentedViewController {
            return getVisibleViewController(presentedViewController)
        }
        
        if let navigationController = rootViewController as? UINavigationController {
            if let tabBarController = navigationController.visibleViewController as? UITabBarController {
                if let selectedTab = tabBarController.selectedViewController {
                    return getVisibleViewController(selectedTab)
                }
                return tabBarController.selectedViewController
            }
            return navigationController.visibleViewController
        }
        
        if let tabBarController = rootViewController as? UITabBarController {
            if let selectedTab = tabBarController.selectedViewController {
                return getVisibleViewController(selectedTab)
            }
            return tabBarController.selectedViewController
        }
        
        return rootViewController
    }
}

extension UIApplication {
    static func openAppSettings(completion: @escaping (_ isSuccess: Bool) -> ()) {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            completion(false)
            return
        }
        
        let app = UIApplication.shared
        
        app.open(url) { isSuccess in
            completion(isSuccess)
        }
    }
    
    static func openPhoneSettings(completion: @escaping (_ isSuccess: Bool) -> ()) {
        guard let url = URL(string: "App-Prefs:root=General") else {
            completion(false)
            return
        }
        
        let app = UIApplication.shared
        
        app.open(url) { isSuccess in
            completion(isSuccess)
        }
    }
}


// MARK:- UIDEVICE
//==================
extension UIDevice {
    
    static let size = UIScreen.main.bounds.size
    
    static let height = UIScreen.main.bounds.height
    
    static let width = UIScreen.main.bounds.width

    static func vibrate() {
        let feedback = UIImpactFeedbackGenerator.init(style: UIImpactFeedbackGenerator.FeedbackStyle.heavy)
        feedback.prepare()
        feedback.impactOccurred()
    }
}

extension UIApplication{
    var statusBarHeight: CGFloat {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .compactMap {
                $0.statusBarManager
            }
            .map {
                $0.statusBarFrame
            }
            .map(\.height)
            .max() ?? 0
    }
}

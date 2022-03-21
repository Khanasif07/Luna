//
//  AppRouter.swift
//  Luna
//
//  Created by Admin on 03/06/21.
//

import Foundation
import UIKit

enum AppRouter {
    
    // MARK: - General Method to set Root VC
    //=========================================
    static func setAsWindowRoot(_ viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.setNavigationBarHidden(true, animated: true)
        AppDelegate.shared.window?.rootViewController = navigationController
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
    // MARK: - General Method to set Root VC
    //=========================================
    static func defaultSetAsWindowRoot(_ navigationController: UINavigationController) {
        AppDelegate.shared.window?.rootViewController = navigationController
        AppDelegate.shared.window?.becomeKey()
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
    
    // MARK: - Show Landing Screen
    //===========================
    static func checkAppInitializationFlow() {
        if isUserLoggedin {
            if   AppUserDefaults.value(forKey: .isSystemSetupCompleted).boolValue{
                AppRouter.gotoHomeVC()
                return
            }else if AppUserDefaults.value(forKey: .isProfileStepCompleted).boolValue {
                AppRouter.gotoSystemSetupVC()
                return
            }else {
                AppRouter.goToProfileSetupVC()
                return
            }
        } else {
            if AppUserDefaults.value(forKey: .isSignupCompleted).boolValue {
                AppRouter.goToLoginVC()
            }else {
                if AppUserDefaults.value(forKey: .isTermsAndConditionSelected).boolValue {
                    AppRouter.goToSignUpVC()
                }else{
                    AppUserDefaults.removeAllValues()
                    self.goToTermsConditionVC()
                }
            }
        }
    }
    
    static func checkEmailVerificationFlow(email: String) {
        let signupVC = SignupViewController.instantiate(fromAppStoryboard: .PreLogin)
        let navigationController = UINavigationController(rootViewController: signupVC)
        navigationController.setNavigationBarHidden(true, animated: false)
        defaultSetAsWindowRoot(navigationController)
        let loginVC = LoginViewController.instantiate(fromAppStoryboard: .PreLogin)
        loginVC.emailTxt = email
        navigationController.pushViewController(loginVC, animated: true)
    }
    
    
    static func goToTestingVC() {
        let homeScene = HomeVC.instantiate(fromAppStoryboard: .PostLogin)
        setAsWindowRoot(homeScene)
    }
    
    static func goToProfileSetupVC() {
        let homeScene = ProfileSetupVC.instantiate(fromAppStoryboard: .PreLogin)
        setAsWindowRoot(homeScene)
    }
    
    // Redirect  to   ONETOONECHATVC
    static func goToNotificationVC() {
        guard let nav: UINavigationController = AppDelegate.shared.window?.rootViewController as? UINavigationController else { return }
        if let homeScene = nav.hasViewController(ofKind: HomeVC.self) as? HomeVC {
            let navigationController = UINavigationController(rootViewController: homeScene)
            navigationController.setNavigationBarHidden(true, animated: false)
            defaultSetAsWindowRoot(navigationController)
            let notificationScene = NotificationsVC.instantiate(fromAppStoryboard: .PostLogin)
            navigationController.pushViewController(notificationScene, animated: true)
        } else {
            AppUserDefaults.removeAllValues()
            self.goToTermsConditionVC()
        }
    }
    
    static func goToSignUpVC() {
        let signupVC = SignupViewController.instantiate(fromAppStoryboard: .PreLogin)
        setAsWindowRoot(signupVC)
    }
    
    static func goToTermsConditionVC() {
        let termsVC = TermsConditionVC.instantiate(fromAppStoryboard: .PreLogin)
        setAsWindowRoot(termsVC)
    }
    
    static func goToLoginVC(){
        let signupVC = SignupViewController.instantiate(fromAppStoryboard: .PreLogin)
        let navigationController = UINavigationController(rootViewController: signupVC)
        navigationController.setNavigationBarHidden(true, animated: false)
        defaultSetAsWindowRoot(navigationController)
        let loginVC = LoginViewController.instantiate(fromAppStoryboard: .PreLogin)
        navigationController.pushViewController(loginVC, animated: true)
    }
    
    static func gotoSystemSetupVC(){
        let vc = SystemSetupStep1VC.instantiate(fromAppStoryboard: .SystemSetup)
        setAsWindowRoot(vc)
    }
    
    static func gotoHomeVC(){
        let vc = HomeVC.instantiate(fromAppStoryboard: .PostLogin)
        setAsWindowRoot(vc)
    }
}

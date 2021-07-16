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
                        AppRouter.goToTestingVC()
                return
        if isUserLoggedin {
            if   AppUserDefaults.value(forKey: .isProfileStepCompleted).boolValue{
                AppRouter.gotoHomeVC()
            }else{
                AppRouter.goToProfileSetupVC()
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
//        guard let nav: UINavigationController = AppDelegate.shared.window?.rootViewController as? UINavigationController else { return }
//        if let homeScene = nav.hasViewController(ofKind: LoginViewController.self) as? LoginViewController {
//            homeScene.emailTxt = email
//            homeScene.isComeFromMail = true
//            let navigationController = UINavigationController(rootViewController: homeScene)
//            navigationController.setNavigationBarHidden(true, animated: true)
//            defaultSetAsWindowRoot(navigationController)
//        } else {
//            let loginVC = LoginViewController.instantiate(fromAppStoryboard: .PreLogin)
//            loginVC.emailTxt = email
//            loginVC.isComeFromMail = true
//            setAsWindowRoot(loginVC)
//        }
        let signupVC = SignupViewController.instantiate(fromAppStoryboard: .PreLogin)
        let navigationController = UINavigationController(rootViewController: signupVC)
        navigationController.setNavigationBarHidden(true, animated: false)
        defaultSetAsWindowRoot(navigationController)
        let loginVC = LoginViewController.instantiate(fromAppStoryboard: .PreLogin)
        loginVC.emailTxt = email
//        loginVC.isComeFromMail = true
        navigationController.pushViewController(loginVC, animated: true)
    }
    
    
    static func goToTestingVC() {
        let homeScene = SystemSetupStep1VC.instantiate(fromAppStoryboard: .SystemSetup)
        setAsWindowRoot(homeScene)
    }
    
    static func goToProfileSetupVC() {
        let homeScene = ProfileSetupVC.instantiate(fromAppStoryboard: .PreLogin)
        setAsWindowRoot(homeScene)
    }
    
    static func goToSignUpVC() {
        //        let loginVC = LoginViewController.instantiate(fromAppStoryboard: .PreLogin)
        //        let navigationController = UINavigationController(rootViewController: loginVC)
        //        navigationController.setNavigationBarHidden(true, animated: false)
        //        defaultSetAsWindowRoot(navigationController)
        //        let signupVC = SignupViewController.instantiate(fromAppStoryboard: .PreLogin)
        //        navigationController.pushViewController(signupVC, animated: true)
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
        //        let loginVC = LoginViewController.instantiate(fromAppStoryboard: .PreLogin)
        //        setAsWindowRoot(loginVC)
    }
    
    static func gotoHomeVC(){
        let vc = HomeVC.instantiate(fromAppStoryboard: .PostLogin)
        setAsWindowRoot(vc)
    }
}

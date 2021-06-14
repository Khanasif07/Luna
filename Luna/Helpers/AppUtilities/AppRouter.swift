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
            AppRouter.goToUserHome()
        } else {
            AppUserDefaults.removeAllValues()
            self.goToUserHome()
        }
    }
    
    static func goToUserHome() {
          let homeScene = HomeViewController.instantiate(fromAppStoryboard: .Main)
          setAsWindowRoot(homeScene)
      }
      
    
}

//
//  AppDelegate.swift
//  Luna
//
//  Created by Admin on 03/06/21.
//

import UIKit
import Firebase
import FirebaseMessaging
import IQKeyboardManagerSwift
import UserNotifications
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate,GIDSignInDelegate{
   
    
    public var window: UIWindow?
    public  var unreadNotificationCount = 0
    static var shared: AppDelegate {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate
        }
        fatalError("invalid access of AppDelegate")
    }
  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        sleep(2)
        getGoogleInfoPlist()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        registerPushNotification()
        removeAllNotifications()
        AppRouter.checkAppInitializationFlow()
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print(fcmToken ?? "")
        // Used for saving device token
        if let deviceToken = fcmToken{
            AppUserDefaults.save(value: deviceToken , forKey: .fcmToken)
        }
    }
    
    // Setup IQKeyboard Manager (Third party for handling keyboard in app)
    private func setUpKeyboardSetup() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.layoutIfNeededOnUpdate = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    private func setUpTextField(){
        UITextField.appearance().tintColor = AppColors.fontPrimaryColor
        UISearchBar.appearance().tintColor = AppColors.fontPrimaryColor
        UIToolbar.appearance().tintColor = AppColors.fontPrimaryColor
        UIButton.appearance().tintColor = AppColors.fontPrimaryColor
        UIBarButtonItem.appearance().tintColor = AppColors.fontPrimaryColor
        
        UITabBar.appearance().isTranslucent = false
        //        UITabBar.appearance().barTintColor = AppColors.primaryBlueColor
        UITabBar.appearance().tintColor = UIColor.white
        UITextField.appearance().semanticContentAttribute = AppUserDefaults.value(forKey: .language) == 1 ? .forceRightToLeft : .forceLeftToRight
        UITextField.appearance().textAlignment = AppUserDefaults.value(forKey: .language) == 1 ? .right : .left
    }
    
    func setUpAppearance(){
        UITextField.appearance().tintColor = AppColors.fontPrimaryColor
        UISearchBar.appearance().tintColor = AppColors.fontPrimaryColor
        UIToolbar.appearance().tintColor = AppColors.fontPrimaryColor
        UIButton.appearance().tintColor = AppColors.fontPrimaryColor
    }
    
    func setUpKeyboard(){
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    
    func registerPushNotification() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            // 1. Check if permission granted
            guard granted else { return }
            // 2. Attempt registration for remote notifications on the main thread
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
     private func removeAllNotifications() {
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        }
}

//MARK:- Extension AppDelegate
//=========================
extension AppDelegate {
    // To fetch different google infoplist according to different servers
    func getGoogleInfoPlist() {
        var filePath = ""
//        #if ENV_DEV
//        filePath = Bundle.main.path(forResource: "GoogleService-Info-Prod", ofType: "plist")!
        filePath = Bundle.main.path(forResource: "GoogleService-Info-1", ofType: "plist")!
//        #elseif ENV_STAG
//        filePath = Bundle.main.path(forResource: "GoogleService-Info-Prod", ofType: "plist")!
//        #elseif ENV_QA
//        filePath = Bundle.main.path(forResource: "GoogleService-Info-QA", ofType: "plist")!
//        #elseif ENV_PROD
//        filePath = Bundle.main.path(forResource: "GoogleService-Info-Prod", ofType: "plist")!
//        #else
//        filePath = Bundle.main.path(forResource: "GoogleService-Info-Prod", ofType: "plist")!
//        #endif
        if let options = FirebaseOptions(contentsOfFile: filePath) {
            FirebaseApp.configure(options: options)
        } else {
            FirebaseApp.configure()
        }
    }
}

//MARK:- Push Notification
//=========================
extension AppDelegate{
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
//        AppUserDefaults.save(value: deviceTokenString, forKey: .token)
        print("APNs device token: \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.alert, .badge, .sound])
    }
    
    func application(_ application: UIApplication,didReceiveRemoteNotification userInfo: [AnyHashable: Any],fetchCompletionHandler completionHandler:@escaping (UIBackgroundFetchResult) -> Void) {
        
        let state : UIApplication.State = application.applicationState
        if (state == .inactive || state == .background) {
            print("background")
            print("Did receive remote notification \(userInfo)")
        } else {
            print("foreground")
            print("Did receive remote notification \(userInfo)")
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let userInfo = response.notification.request.content.userInfo as? [String: Any] else { return }
//        PushNotificationRedirection.redirectionOnNotification(userInfo)
        print("tap on on forground app", userInfo)
        completionHandler()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            return
        }
        print("User Email: \(user.profile.email ?? "No EMail")")
        print("User Email: \(user.profile.name ?? "No Name")")
        print("User Email: \(user.profile.familyName ?? "No Name")")
        print("User Email: \(user.userID ?? "No Name")")
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        print("User credential: \(credential)")
    }
    
    
}

//MARK:- Deep Linking
//=========================
extension AppDelegate {
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        if let scheme = url.scheme,
//            scheme.localizedCaseInsensitiveCompare("com.tara") == .orderedSame,
//            let view = url.host {
//            var parameters: [String: String] = [:]
//            URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
//                parameters[$0.name] = $0.value
//            }
//        }
//        return true
//    }
    return GIDSignIn.sharedInstance().handle(url)
    }
}

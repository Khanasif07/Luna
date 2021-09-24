//
//  AppGlobals.swift
//  Luna
//
//  Created by Admin on 03/06/21.
//

import Foundation
import UIKit

var isUserLoggedin: Bool {
    let token = AppUserDefaults.value(forKey: .uid).stringValue
    if !token.isEmpty {
        return true
    } else {
        return false
    }
}
var hasTopNotch: Bool {
    if #available(iOS 13.0,  *) {
        return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0 > 20
    }else{
     return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
    }
}
var loginType: LoginType = .email_password

enum LoginType {
    case email_password
    case google
    case apple
    
    var title : String {
        switch self {
        case .google:
            return "google.com"
        case .apple:
            return "apple.com"
        default:
            return "password"
        }
    }
}

var userInterfaceStyle: UIUserInterfaceStyle{
    return UIScreen.main.traitCollection.userInterfaceStyle
}


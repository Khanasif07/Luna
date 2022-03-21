//
//  AppleLoginManager.swift
//  Luna
//
//  Created by Admin on 08/06/21.
//

import Foundation
import AuthenticationServices
import UIKit

protocol AppleSignInProtocal: AnyObject {
    func getAppleLoginData(loginData: [String:Any])
}

class AppleLoginController: NSObject{
    
    weak var delegate : AppleSignInProtocal?
    static let shared = AppleLoginController()
    //============================Apple_Login=========================================

    func apploginButton(stackAppleLogin: UIStackView, vc: UIViewController){
        if #available(iOS 13.0, *) {
            let authorizationButton = ASAuthorizationAppleIDButton(type: .continue, style: .black)
//            stackAppleLogin.addArrangedSubview(authorizationButton)
            stackAppleLogin.insertArrangedSubview(authorizationButton, at: 2)
            authorizationButton.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)
            AppleLoginController.shared.delegate = vc as? AppleSignInProtocal
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func appleSignInTapped(vc: UIViewController) {
        if #available(iOS 13.0, *) {
//            AppleLoginController.shared.delegate = vc as? AppleSignInProtocal
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]
             let authController = ASAuthorizationController(authorizationRequests: [request])
             authController.presentationContextProvider = self
             authController.delegate = self
             authController.performRequests()
        } else {
            // Fallback on earlier versions
        }
    }
}
extension AppleLoginController : ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        if let window = AppDelegate.shared.window{
            return window
        }else{
            return UIWindow()
        }
    }
}


@available(iOS 13.0, *)
extension AppleLoginController : ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("authorization error")
        guard let error = error as? ASAuthorizationError else {
            return
        }
        
        switch error.code {
        case .canceled:
            // user press "cancel" during the login prompt
            print("Canceled")
        case .unknown:
            // user didn't login their Apple ID on the device
            print("Unknown")
        case .invalidResponse:
            // invalid response received from the login
            print("Invalid Respone")
        case .notHandled:
            // authorization request not handled, maybe internet failure during login
            print("Not handled")
        case .failed:
            // authorization failed
            print("Failed")
        @unknown default:
            print("Default")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let loginData =  AppleLoginModel(data: appleIDCredential)
            self.delegate?.getAppleLoginData(loginData: loginData.param)
            
        }else if authorization.credential is ASPasswordCredential {
            
            guard let appleIdCredentials = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
            let loginData =  AppleLoginModel(data: appleIdCredentials)
            self.delegate?.getAppleLoginData(loginData: loginData.param)
            
        }
    }
}

@available(iOS 13.0, *)
class AppleLoginModel{
    
    let email : String
    let socialId : String
    let givenName : String
    let identityToken :String
    let authorizationCode: String
    
    var param : [String:Any]{
        var paramData = [String:Any]()
        paramData["name"]                = "\(givenName)"
        paramData["email"]               = email
        paramData["socialId"]           = socialId
        return paramData
    }
    
    init(data: ASAuthorizationAppleIDCredential) {
       
        socialId = data.user
        email = data.email ?? ""
        givenName = data.fullName?.givenName ?? ""
        if let token = data.identityToken {
            identityToken = String(bytes: token, encoding: .utf8) ?? ""
        }else{
            identityToken = ""
        }
        if let code = data.authorizationCode {
            authorizationCode = String(bytes: code, encoding: .utf8) ?? ""
        }else{
            authorizationCode = ""
        }
    }
}

//
//  AppConstants.swift
//  Luna
//
//  Created by Admin on 03/06/21.
//

import Foundation

enum AppConstants {
    static var googlePlaceApiKey = "AIzaSyAmeRcKb4_NVo6ROBq9dwcqJfTydaGitdY"
    static var appName              = "LUNA"
    static var format               = "SELF MATCHES %@"
    static let emailRegex           = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    static var mobileRegex          = "^[0-9]{7,15}$"
    static var passwordRegex        = "^[a-zA-Z0-9!@#$%&*]{6,16}"
    static var defaultDate          = "0000-00-00"
    static var emptyString          = ""
    static var whiteSpace           = " "
    static let facebookAppId = "331106654612712"//dev
    static let AppPassword = "Luna@123"
    static let googleId = "945865667688-17hgjjn4tgqikhmcq7ufigggcqta2t75.apps.googleusercontent.com"//testing
    static var awss3PoolId          =  "us-east-1:b1f250f2-66a7-4d07-96e9-01817149a439"
    
    static var adminId = ""
}

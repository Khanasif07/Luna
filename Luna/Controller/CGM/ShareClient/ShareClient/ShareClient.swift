//
//  ShareClient.h
//  ShareClient
//
//  Created by Mark Wilson on 5/7/16.
//  Copyright © 2016 Mark Wilson. All rights reserved.
//

//import Foundation
//
//public struct ShareGlucose {
//    public let glucose: UInt16
//    public let trend: UInt8
//    public let timestamp: Date
//}
//
//public enum ShareError: Error {
//    case httpError(Error)
//    // some possible values of errorCode:
//    // SSO_AuthenticateAccountNotFound
//    // SSO_AuthenticatePasswordInvalid
//    // SSO_AuthenticateMaxAttemptsExceeed
//    case loginError(errorCode: String)
//    case fetchError
//    case dataError(reason: String)
//    case dateError
//}
//
//
//public enum KnownShareServers: String {
//    case US="https://share2.dexcom.com"
//    case NON_US="https://shareous1.dexcom.com"
//    /*
//         To enable Loop to use a custom share server:
//            - remove the comment marker on line 44 and change the value of CUSTOM
//            - remove the comment markers on lines 34 and 35 in ShareClientUI/ShareService+UI.swift
//
//         Note: The URL in CUSTOM must start with 'https://' (NOT 'http://')
//
//         You can find installation instructions for one such custom share server at
//         https://github.com/dabear/NightscoutShareServer
//    */
//
//    // case CUSTOM="https://yourusernameshareserver.herokuapp.com"
//}
//
//// From the Dexcom Share iOS app, via @bewest and @shanselman:
//// https://github.com/bewest/share2nightscout-bridge
//private let dexcomUserAgent = "Dexcom Share/3.0.2.11 CFNetwork/711.2.23 Darwin/14.0.0"
//private let dexcomApplicationId = "d89443d2-327c-4a6f-89e5-496bbb0317db"
//private let dexcomLoginPath = "/ShareWebServices/Services/General/LoginPublisherAccountByName"
//private let dexcomLatestGlucosePath = "/ShareWebServices/Services/Publisher/ReadPublisherLatestGlucoseValues"
//private let maxReauthAttempts = 2
//
//// TODO use an HTTP library which supports JSON and futures instead of callbacks.
//// using cocoapods in a playground appears complicated
//// ¯\_(ツ)_/¯
//private func dexcomPOST(_ url: URL, JSONData: [String: AnyObject]? = nil, callback: @escaping (Error?, String?) -> Void) {
//    var data: Data?
//
//    if let JSONData = JSONData {
//        guard let encoded = try? JSONSerialization.data(withJSONObject: JSONData, options:[]) else {
//            return callback(ShareError.dataError(reason: "Failed to encode JSON for POST to " + url.absoluteString), nil)
//        }
//
//        data = encoded
//    }
//
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.addValue("application/json", forHTTPHeaderField: "Accept")
//    request.addValue(dexcomUserAgent, forHTTPHeaderField: "User-Agent")
//    request.httpBody = data
//
//    URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
//        if error != nil {
//            callback(error, nil)
//        } else {
//            callback(nil, String(data: data!, encoding: .utf8))
//        }
//    }).resume()
//}
//
//public class ShareClient {
//    public let username: String
//    public let password: String
//
//    private let shareServer:String
//    private var token: String?
//
//    public init(username: String, password: String, shareServer:String=KnownShareServers.US.rawValue) {
//        self.username = username
//        self.password = password
//        self.shareServer = shareServer
//    }
//
//    public convenience init(username: String, password: String, shareServer:KnownShareServers=KnownShareServers.US) {
//
//        self.init(username: username, password: password, shareServer:shareServer.rawValue)
//
//    }
//
//    public func fetchLast(_ n: Int, callback: @escaping (Error?, [ShareGlucose]?) -> Void) {
//        fetchLastWithRetries(n, remaining: maxReauthAttempts, callback: callback)
//    }
//
//    private func ensureToken(_ callback: @escaping (Error?) -> Void) {
//        if token != nil {
//            callback(nil)
//        } else {
//            fetchToken() { (error, token) in
//                if error != nil {
//                    callback(error)
//                } else {
//                    self.token = token
//                    callback(nil)
//                }
//            }
//        }
//    }
//
//    private func fetchToken(_ callback: @escaping (Error?, String?) -> Void) {
//        let data = [
//            "accountName": username,
//            "password": password,
//            "applicationId": dexcomApplicationId
//        ]
//
//        guard let url = URL(string: shareServer + dexcomLoginPath) else {
//            return callback(ShareError.fetchError, nil)
//        }
//
//        dexcomPOST(url, JSONData: data as [String : AnyObject]?) { (error, response) in
//            if let error = error {
////                return callback(.httpError(error), nil)
//                return callback(error, nil)
//            }
//
//            guard let   response = response,
//                let data = response.data(using: .utf8),
//                let decoded = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                else {
////                    return callback(.loginError(errorCode: "unknown"), nil)
//                      return callback(error, nil)
//            }
//
//            if let token = decoded as? String {
//                // success is a JSON-encoded string containing the token
//                callback(nil, token)
//            } else {
//                // failure is a JSON object containing the error reason
//                _ = (decoded as? [String: String])?["Code"] ?? "unknown"
////                callback(.loginError(errorCode: errorCode), nil)
//                callback(error, nil)
//            }
//        }
//    }
//
//    private func fetchLastWithRetries(_ n: Int, remaining: Int, callback: @escaping (Error?, [ShareGlucose]?) -> Void) {
//        ensureToken() { (error) in
//            guard error == nil else {
//                return callback(error, nil)
//            }
//
//            guard var components = URLComponents(string: self.shareServer + dexcomLatestGlucosePath) else {
////                return callback(.fetchError, nil)
//                return callback(error, nil)
//            }
//
//            components.queryItems = [
//                URLQueryItem(name: "sessionId", value: self.token),
//                URLQueryItem(name: "minutes", value: String(1440)),
//                URLQueryItem(name: "maxCount", value: String(n))
//            ]
//
//            guard let url = components.url else {
////                return callback(.fetchError, nil)
//                return callback(error, nil)
//            }
//
//            dexcomPOST(url) { (error, response) in
//                if let error = error {
////                    return callback(.httpError(error), nil)
//                    return callback(error, nil)
//                }
//
//                do {
//                    guard let response = response else {
//                        throw ShareError.fetchError
//                    }
//
//                    let decoded = try? JSONSerialization.jsonObject(with: response.data(using: .utf8)!, options: [])
//                    guard let sgvs = decoded as? Array<AnyObject> else {
//                        if remaining > 0 {
//                            self.token = nil
//                            return self.fetchLastWithRetries(n, remaining: remaining - 1, callback: callback)
//                        } else {
//                            throw ShareError.dataError(reason: "Failed to decode SGVs as array after trying to reauth: " + response)
//                        }
//                    }
//
//                    var transformed: Array<ShareGlucose> = []
//                    for sgv in sgvs {
//                        if let glucose = sgv["Value"] as? Int, let trend = sgv["Trend"] as? Int, let wt = sgv["WT"] as? String {
//                            transformed.append(ShareGlucose(
//                                glucose: UInt16(glucose),
//                                trend: UInt8(trend),
//                                timestamp: try self.parseDate(wt)
//                            ))
//                        } else {
//                            throw ShareError.dataError(reason: "Failed to decode an SGV record: " + response)
//                        }
//                    }
//                    callback(nil, transformed)
//                } catch let error as ShareError {
//                    callback(error, nil)
//                } catch {
////                    callback(.fetchError, nil)
//                    callback(error, nil)
//                }
//            }
//        }
//    }
//
//    private func parseDate(_ wt: String) throws -> Date {
//        // wt looks like "/Date(1462404576000)/"
//        let re = try NSRegularExpression(pattern: "\\((.*)\\)")
//        if let match = re.firstMatch(in: wt, range: NSMakeRange(0, wt.count)) {
//            #if swift(>=4)
//                let matchRange = match.range(at: 1)
//            #else
//                let matchRange = match.rangeAt(1)
//            #endif
//            let epoch = Double((wt as NSString).substring(with: matchRange))! / 1000
//            return Date(timeIntervalSince1970: epoch)
//        } else {
//            throw ShareError.dateError
//        }
//    }
//}


import Foundation

public struct ShareGlucose {
    public let glucose: UInt16
    public let trend: String
    public let timestamp: Date
}

public enum ShareError: Error {
    case httpError(Error)
    // some possible values of errorCode:
    // SSO_AuthenticateAccountNotFound
    // SSO_AuthenticatePasswordInvalid
    // SSO_AuthenticateMaxAttemptsExceeed
    case loginError(errorCode: String)
    case fetchError
    case dataError(reason: String)
    case dateError
}


public enum KnownShareServers: String {
    case US="https://share2.dexcom.com"
    case NON_US="https://shareous1.dexcom.com"
    /*
         To enable Loop to use a custom share server:
            - remove the comment marker on line 44 and change the value of CUSTOM
            - remove the comment markers on lines 34 and 35 in ShareClientUI/ShareService+UI.swift

         Note: The URL in CUSTOM must start with 'https://' (NOT 'http://')

         You can find installation instructions for one such custom share server at
         https://github.com/dabear/NightscoutShareServer
    */

    // case CUSTOM="https://yourusernameshareserver.herokuapp.com"
}

// From the Dexcom Share iOS app, via @bewest and @shanselman:
// https://github.com/bewest/share2nightscout-bridge
private let dexcomUserAgent = "Dexcom Share/3.0.2.11 CFNetwork/711.2.23 Darwin/14.0.0"
private let dexcomApplicationId = "d89443d2-327c-4a6f-89e5-496bbb0317db"
private let dexcomLoginPath = "/ShareWebServices/Services/General/LoginPublisherAccountByName"
private let dexcomLatestGlucosePath = "/ShareWebServices/Services/Publisher/ReadPublisherLatestGlucoseValues"
private let maxReauthAttempts = 2

// TODO use an HTTP library which supports JSON and futures instead of callbacks.
// using cocoapods in a playground appears complicated
// ¯\_(ツ)_/¯
private func dexcomPOST(_ url: URL, JSONData: [String: AnyObject]? = nil, callback: @escaping (Error?, String?) -> Void) {
    var data: Data?

    if let JSONData = JSONData {
        guard let encoded = try? JSONSerialization.data(withJSONObject: JSONData, options:[]) else {
            return callback(ShareError.dataError(reason: "Failed to encode JSON for POST to " + url.absoluteString), nil)
        }

        data = encoded
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue(dexcomUserAgent, forHTTPHeaderField: "User-Agent")
    request.httpBody = data

    URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
        if error != nil {
            callback(error, nil)
        } else {
            callback(nil, String(data: data!, encoding: .utf8))
        }
    }).resume()
}

public class ShareClient {
    public let username: String
    public let password: String

    private let shareServer:String
    private var token: String?

    public init(username: String, password: String, shareServer:String=KnownShareServers.US.rawValue) {
        self.username = username
        self.password = password
        self.shareServer = shareServer
    }
    public convenience init(username: String, password: String, shareServer:KnownShareServers=KnownShareServers.US) {

        self.init(username: username, password: password, shareServer:shareServer.rawValue)

    }

    public func fetchLast(_ n: Int, callback: @escaping (Error?, [ShareGlucose]?) -> Void) {
        fetchLastWithRetries(n, remaining: maxReauthAttempts, callback: callback)
    }

    private func ensureToken(_ callback: @escaping (Error?) -> Void) {
        if token != nil {
            callback(nil)
        } else {
            fetchToken() { (error, token) in
                if error != nil {
                    callback(error)
                } else {
                    self.token = token
                    callback(nil)
                }
            }
        }
    }

    private func fetchToken(_ callback: @escaping (Error?, String?) -> Void) {
        let data = [
            "accountName": username,
            "password": password,
            "applicationId": dexcomApplicationId
        ]

        guard let url = URL(string: shareServer + dexcomLoginPath) else {
            return callback(ShareError.fetchError, nil)
        }

        dexcomPOST(url, JSONData: data as [String : AnyObject]?) { (error, response) in
            if let error = error {
//                return callback(.httpError(error), nil)
                return callback(error,nil)
            }

            guard let   response = response,
                let data = response.data(using: .utf8),
                let decoded = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                else {
//                    return callback(.loginError(errorCode: "unknown"), nil)
                return callback(error,nil)
            }

            if let token = decoded as? String {
                // success is a JSON-encoded string containing the token
                callback(nil, token)
            } else {
                // failure is a JSON object containing the error reason
//                let errorCode = (decoded as? [String: String])?["Code"] ?? "unknown"
//                callback(.loginError(errorCode: errorCode), nil)
                return callback(error,nil)
            }
        }
    }

    private func fetchLastWithRetries(_ n: Int, remaining: Int, callback: @escaping (Error?, [ShareGlucose]?) -> Void) {
        ensureToken() { (error) in
            guard error == nil else {
                return callback(error, nil)
            }

            guard var components = URLComponents(string: self.shareServer + dexcomLatestGlucosePath) else {
//                return callback(.fetchError, nil)
                  return callback(error,nil)
            }

            // Dexcom Share only returns up to 24 hrs of data today
            // Requesting more just in case this changes in the future
            let minutes = max(1440, n * 5)
            components.queryItems = [
                URLQueryItem(name: "sessionId", value: self.token),
                URLQueryItem(name: "minutes", value: String(minutes)),
                URLQueryItem(name: "maxCount", value: String(n))
            ]

            guard let url = components.url else {
//                return callback(.fetchError, nil)
                return callback(error,nil)
            }

            dexcomPOST(url) { (error, response) in
                if let error = error {
//                    return callback(.httpError(error), nil)
                    return callback(error,nil)
                }

                do {
                    guard let response = response else {
                        throw ShareError.fetchError
                    }

                    let decoded = try? JSONSerialization.jsonObject(with: response.data(using: .utf8)!, options: [])
                    guard let sgvs = decoded as? Array<AnyObject> else {
                        if remaining > 0 {
                            self.token = nil
                            return self.fetchLastWithRetries(n, remaining: remaining - 1, callback: callback)
                        } else {
                            throw ShareError.dataError(reason: "Failed to decode SGVs as array after trying to reauth: " + response)
                        }
                    }

                    var transformed: Array<ShareGlucose> = []
                    for sgv in sgvs {
                        if let glucose = sgv["Value"] as? Int, let trend = sgv["Trend"] as? String, let wt = sgv["WT"] as? String {
                            transformed.append(ShareGlucose(
                                glucose: UInt16(glucose),
                                trend: String(trend),
                                timestamp: try self.parseDate(wt)
                            ))
                        } else {
                            throw ShareError.dataError(reason: "Failed to decode an SGV record: " + response)
                        }
                    }
                    callback(nil, transformed)
                } catch let error as ShareError {
                    callback(error, nil)
                } catch {
//                    callback(.fetchError, nil)
                    callback(error,nil)
                }
            }
        }
    }

    private func parseDate(_ wt: String) throws -> Date {
        // wt looks like "/Date(1462404576000)/"
        let re = try NSRegularExpression(pattern: "\\((.*)\\)")
        if let match = re.firstMatch(in: wt, range: NSMakeRange(0, wt.count)) {
            #if swift(>=4)
                let matchRange = match.range(at: 1)
            #else
                let matchRange = match.rangeAt(1)
            #endif
            let epoch = Double((wt as NSString).substring(with: matchRange))! / 1000
            return Date(timeIntervalSince1970: epoch)
        } else {
            throw ShareError.dateError
        }
    }
}

//
//  String+Extension.swift
//  Luna
//
//  Created by Admin on 03/06/21.
//

import Foundation
import UIKit

extension String {
    
    ///Removes all spaces from the string
    var removeSpaces:String{
        return self.replacingOccurrences(of: " ", with: "")
    }

    ///Removes all HTML Tags from the string
    var removeHTMLTags: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }

    ///Returns a localized string
    var localized:String {
        
        //        switch AppUserDefaults.value(forKey: .currentLanguage).stringValue{
        //        case SelectedLangauage.esponal.rawValue:
        //            return self.localizedString(lang: "es")
        //        default:
        //            return self.localizedString(lang: "en")
        //        }
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    ///Removes leading and trailing white spaces from the string
    var byRemovingLeadingTrailingWhiteSpaces:String {
        
        let spaceSet = CharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: spaceSet)
    }
    
    var byRemovingLeadingSpaces:String {
        
        let spaceSet = CharacterSet.whitespaces
        return self.trimmingCharacters(in: spaceSet)
    }
    //Returns bool value after it checks if string is a digit
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    var isPhoneNumber: Bool {
        if self.count < 9 { return false }
        else if "\(self[self.startIndex])" == 0.stringValue { return false }
        return true
    }
    
    public func trimTrailingWhitespace() -> String {
        if let trailingWs = self.range(of: "\\s+$", options: .regularExpression) {
            return self.replacingCharacters(in: trailingWs, with: "")
        } else {
            return self
        }
    }
    ///Returns 'true' if the string is any (file, directory or remote etc) url otherwise returns 'false'
    var isAnyUrl:Bool{
        return (URL(string:self) != nil)
    }
    
    ///Returns the json object if the string can be converted into it, otherwise returns 'nil'
    var jsonObject:Any? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [])
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        return nil
    }
    
    ///Returns the base64Encoded string
    var base64Encoded:String {
        
        return Data(self.utf8).base64EncodedString()
    }
    
    ///Returns the string decoded from base64Encoded string
    var base64Decoded:String? {
        
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    func heightOfText(_ width: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
    //MARK: sizeCount
    func sizeCount(withFont font: UIFont, boundingSize size: CGSize) -> CGSize {
        let mutableParagraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        mutableParagraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: mutableParagraphStyle]
        let tempStr = NSString(string: self)
        
        let rect: CGRect = tempStr.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        let height = ceilf(Float(rect.size.height))
        let width = ceilf(Float(rect.size.width))
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    
    
    func widthOfText(_ height: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.width
    }

    func localizedString(lang:String) ->String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    
    func breakCompletDate(outPutFormat: String,inputFormat: String) -> String {
        return self.toDate(dateFormat: inputFormat)?.toString(dateFormat: outPutFormat) ?? ""
        
    }
    
    func breakCompletTime() -> String {
        if self == AppConstants.defaultDate{
            return AppConstants.emptyString
        }else{
            return self.toDate(dateFormat: Date.DateFormat.yyyyMMddTHHmmsssssz.rawValue)?.toString(dateFormat: Date.DateFormat.hhmma.rawValue) ?? AppConstants.emptyString
        }
    }
    
    ///Returns 'true' if string contains the substring, otherwise returns 'false'
    func contains(s: String) -> Bool
    {
        return self.range(of: s) != nil ? true : false
    }
    
    ///Replaces occurances of a string with the given another string
    func replace(string: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: string, with: withString, options: String.CompareOptions.literal, range: nil)
    }
    
    ///Converts the string into 'Date' if possible, based on the given date format and timezone. otherwise returns nil
    func toDate(dateFormat:String,timeZone:TimeZone = TimeZone.current)->Date?{
        
        let frmtr = DateFormatter()
//        frmtr.locale = Locale(identifier: "en_US_POSIX")
        frmtr.dateFormat = dateFormat
        frmtr.timeZone = timeZone
        return frmtr.date(from: self)
    }


    func checkIfValid(_ validityExression : ValidityExression) -> Bool {
        
        let regEx = validityExression.rawValue
        
        let test = NSPredicate(format:"SELF MATCHES %@", regEx)
        
        return test.evaluate(with: self)
    }
    
    func checkIfInvalid(_ validityExression : ValidityExression) -> Bool {
        
        return !self.checkIfValid(validityExression)
    }
    
    func checkIfValidCharaters(_ validityExression : ValidCharaters) -> Bool {
        
        let regEx = validityExression.rawValue
        
        let test = NSPredicate(format:"SELF MATCHES %@", regEx)
        
        return test.evaluate(with: self)
    }
    
    ///Capitalize the very first letter of the sentence.
    var capitalizedFirst: String {
        guard !isEmpty else { return self }
        var result = self
        let substr1 = String(self[startIndex]).uppercased()
        result.replaceSubrange(...startIndex, with: substr1)
        return result
    }
    
    var sentenceCase: String {
        guard !isEmpty else { return self }
        var result = self.lowercased()
        let substr1 = String(self[startIndex]).uppercased()
        result.replaceSubrange(...startIndex, with: substr1)
        return result
    }
    
    var displaySecureText : String {
        let firstTwo = self.prefix(2)
        let lastFour = self.suffix(4)
        let remainingDigits = self.count - 6
        let hideText = String(repeating: "*", count: remainingDigits)
        return firstTwo + hideText + lastFour
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    
    func convertDateToString() -> String{
        
        if self == AppConstants.defaultDate{
            return AppConstants.emptyString
        }else{
            return self.toDate(dateFormat: Date.DateFormat.yyyy_MM_dd.rawValue)?.toString(dateFormat: Date.DateFormat.dd_MM_yyyy.rawValue) ?? AppConstants.emptyString
            
        }
    }
    func convertTimeToString() -> String{
        
        if self == AppConstants.defaultDate{
            return AppConstants.emptyString
        }else{
            return self.toDate(dateFormat: Date.DateFormat.HHmmss.rawValue)?.toString(dateFormat: Date.DateFormat.hhmma.rawValue) ?? AppConstants.emptyString
        }
    }
    
    func convertCheckinTimeToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.DateFormat.hhmma.rawValue
        let date = dateFormatter.date(from: self) ?? Date()
        return date
    }
    
    func convertShiftTimeToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.DateFormat.HHmmss.rawValue
        let date = dateFormatter.date(from: self) ?? Date()
        return date
    }
    
    func convertToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.DateFormat.yyyy_MM_dd.rawValue
        let yearDate = dateFormatter.date(from: self) ?? Date()
        return yearDate
    }
    
    func convertToNormalDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.DateFormat.dd_MM_yyyy.rawValue
        let yearDate = dateFormatter.date(from: self) ?? Date()
        return yearDate
    }
    
    func convertToNormalStringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.DateFormat.yyyy_MM_dd.rawValue
        let yearDate = dateFormatter.date(from: self) ?? Date()
        dateFormatter.dateFormat = Date.DateFormat.dd_MM_yyyy.rawValue
        let local = dateFormatter.string(from: yearDate)
        return local
    }
    
    func convertToNormalDateTime() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.DateFormat.yyyyMMddHHmmss.rawValue
        let reverseDateTime = dateFormatter.date(from: self) ?? Date()
        let local = Date(millis: reverseDateTime.toMillis())
        return local
    }
    
    func convertDateTimetoDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.DateFormat.yyyyMMddHHmmss.rawValue
        let yearDate = dateFormatter.date(from: self) ?? Date()
        dateFormatter.dateFormat = Date.DateFormat.dd_MM_yyyy.rawValue
        let local = dateFormatter.string(from: yearDate)
        return local
    }
    
    func convertDateTimeToDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.DateFormat.yyyyMMddHHmmss.rawValue
        let yearDate = dateFormatter.date(from: self) ?? Date()
        dateFormatter.dateFormat = Date.DateFormat.dd_MM_yyyy.rawValue
        let local = dateFormatter.string(from: yearDate)
        return local
    }
    
    func convertToHours() -> String {
        let yearDate = self.toDate(dateFormat: Date.DateFormat.HHmmss.rawValue, timeZone: TimeZone.current) ?? Date()
        //String(format: "%02d:%02d", yearDate.hour % 12, yearDate.minute)
        return "\(yearDate.hour % 12):\(yearDate.minute)"
    }
    
    func convertToReverseDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.DateFormat.dd_MM_yyyy.rawValue
        let yearDate = dateFormatter.date(from: self) ?? Date()
        dateFormatter.dateFormat = Date.DateFormat.yyyy_MM_dd.rawValue
        let local = dateFormatter.string(from: yearDate)
        return local
    }
    
    func convertMillisecondsToTime() -> String {
        let timeStamp = self.int64Value / 1000
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.DateFormat.hhmma.rawValue
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    func convertTimestampToTime() -> String {
        let unixTimestamp = Double(self) ?? 0.0
        let date = Date(timeIntervalSince1970: unixTimestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.DateFormat.hhmma.rawValue
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    func convertTimestampToDateTime() -> Date {
        let unixTimestamp = Double(self) ?? 0.0
        let date = Date(timeIntervalSince1970: unixTimestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.DateFormat.yyyyMMddTHHmmssssZZZZZ.rawValue
        let strDate = dateFormatter.string(from: date)
        let timeDate = dateFormatter.date(from: strDate) ?? Date()
        return timeDate
    }
    
    func convertDateStringToTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.DateFormat.yyyyMMddHHmmss.rawValue
        let dateTime = dateFormatter.date(from: self) ?? Date()
        dateFormatter.dateFormat = Date.DateFormat.hhmma.rawValue
        let local = dateFormatter.string(from: dateTime)
        return local
    }
    
    func convertTimeStringToTime() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.DateFormat.hhmma.rawValue
        let local = dateFormatter.date(from: self)
        return local
    }
    
    func convertHHmmToTime() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.DateFormat.HHmmss.rawValue
        let local = dateFormatter.date(from: self)
        return local
    }
    
    var int64Value : Int64 {
        return Int64(self) ?? Int64(0000000000000)
    }
    
    var intValue : Int {
        return Int(self) ?? 0
    }
    
}

extension String {
    func formated(parameters: CVarArg) -> String {
        return String(format: self, parameters)
        
        //        return String(format: self, arguments: parameters)
    }
    
}

extension Optional where Wrapped == String {
    var value: String {
        guard let unwrapped = self else {
            return ""
        }
        return unwrapped
    }
}

enum ValidityExression : String {
    
    case userName = "^[a-zA-z]{1,}+[a-zA-z0-9!@#$%&*]{2,15}"
    case email =  "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,50}"
    case mobileNumber = "^[0-9]{8,14}$"
    case hardPassword = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[!\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~])(?=.*\\d)[A-Za-z0-9 !\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~]{8,16}"
    case nickName = "^[a-zA-Z0-9\\s]{3,40}"
    case name = "^[a-zA-Z0-9!@#._$%&*\\s]{3,40}"
    case webUrl = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
    case password = "^(?=.*[A-Z])(?=.*\\d)[A-Za-z0-9 !\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~]{8,20}$"
}

enum ValidCharaters: String{
    case userName = "^[a-zA-z]{1,}+[a-zA-z0-9!@#$%&*]{0,15}"
    case email =  "^[a-zA-Z0-9!@#$%&*._-]{0,100}"
    case mobileNumber = "^[0-9]{0,16}$"
    case password = "^[a-zA-Z0-9!@#._$%&*]{0,30}"//"^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,32}$"
    case name = "^[a-zA-Z0-9!@#._$%&*\\s]{0,40}"
    case nickName = "^[a-zA-Z0-9\\s]{0,40}"
    case webUrl = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
    case simplePassword = "^[a-zA-Z0-9!@#._$%&*]{0,32}"
}

enum ValidLength: Int{
    case userName = 40
    case email = 50
    case password = 16
    case mobileNumber = 20
}

extension String {
    var numbers: String {
        return filter { "0"..."9"  ~= $0 }
    }
    var hasVideoFileExtension: Bool {
        
        let arr = self.components(separatedBy: ".")
        if arr.count > 1{
            
            switch arr.last! {
            case "mp4","m4a","m4v","mov","wav","mp3":
                return true
            default:
                return false
            }
        }
        return false
    }
    
    func appendingPathComponent(_ component:String?) -> String{
        
        if let compnent = component{
            return (self as NSString).appendingPathComponent(compnent)
        }
        return self
    }
    var toUrl: URL? {
        
        if self.isEmpty { return nil }
        
        if self.hasPrefix("https://") || self.hasPrefix("http://") {
            return URL(string: self)
        } else {
            return URL(fileURLWithPath: self)
        }
    }
    var isBlank: Bool {
        let trimmed = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmed.isEmpty
    }
}

extension Array {
    
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}


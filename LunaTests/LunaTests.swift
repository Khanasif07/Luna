//
//  LunaTests.swift
//  LunaTests
//
//  Created by Admin on 29/09/21.
//

import XCTest

class LunaTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func isEmailValid(string: String?) -> (Bool,String) {
        if let email = string, !email.isEmpty {
            if email.count < 3 {
                return (false, "Please enter a valid email address.")
            } else if email.isValidEmail == false {
                return (false, "Please enter a valid email address.")
            }             } else {
            return (false, "Please enter a email address.")
        }
        return (true,"")
    }
    
    func isPassValid(string: String?) -> (Bool,String) {
        if let pass = string, !pass.isEmpty {
            if pass.count < 6 {
                return (false, "Password must contain at least 6 char.")
            }
        } else {
            return (false, "Please enter a password.")
        }
        return (true,"")
    }

    func test_SignupValidation_With_EmptyStrings_Returns_ValidationFailure() throws {
        XCTAssertEqual(isEmailValid(string: "").0, false)
        XCTAssertEqual(isPassValid(string: "").0, false)
    }
    
    func test_SignUpValidation_With_InvalidEmail_Returns_ValidationFailure() {
        XCTAssertEqual(isEmailValid(string: "amit12gmail.com").0, false)
        XCTAssertEqual(isPassValid(string: "1234567").0, true)
    }
    
    func test_SignUpValidation_With_InvalidPassword_Returns_ValidationFailure() {
        XCTAssertEqual(isEmailValid(string: "amit@gmail.com").0, true)
        XCTAssertEqual(isPassValid(string: "1234").0, false)
    }
    
    func test_SignUpValidation_With_ValidRequest_Returns_ValidationSuccess() {
        XCTAssertEqual(isEmailValid(string: "amit@gmail.com").0, true)
        XCTAssertEqual(isPassValid(string: "1234567").0, true)
    }
    
    func testPerformanceExample() throws {
        measure {
        }
    }

}

extension String {
    var isValidEmail : Bool {
        let regEx = "[A-Z0-9a-z\\u0080-\\uFFFF.-_]+@[A-Za-z\\u0080-\\uFFFF0-9.-]+\\.[A-Za-z\\u0080-\\uFFFFß]{1,50}"
        let test = NSPredicate(format:"SELF MATCHES %@", regEx)
        return test.evaluate(with: self)
    }
}

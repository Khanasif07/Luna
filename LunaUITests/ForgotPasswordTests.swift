//
//  ForgotPasswordTests.swift
//  LunaUITests
//
//  Created by Admin on 04/10/21.
//

import XCTest

class ForgotPasswordTests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false

        XCUIApplication().launch()

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_ForgotPassword_With_VaildEmail_Returns_Success() throws {
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Forgot Password?"]/*[[".cells",".buttons[\"Forgot Password?\"].staticTexts[\"Forgot Password?\"]",".staticTexts[\"Forgot Password?\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let emailTextField = app.textFields["Email"]
        emailTextField.typeText("somaygarg182@gmail.com")
        emailTextField.tap()
        
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).tap()
        
        app/*@START_MENU_TOKEN@*/.staticTexts["Confirm"]/*[[".buttons[\"Confirm\"].staticTexts[\"Confirm\"]",".staticTexts[\"Confirm\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

    }
    
    func test_ForgotPassword_with_InvalidEmail_Returns_Failure() throws {
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Forgot Password?"]/*[[".cells",".buttons[\"Forgot Password?\"].staticTexts[\"Forgot Password?\"]",".staticTexts[\"Forgot Password?\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let emailTextField = app.textFields["Email"]
        emailTextField.typeText("somay@gmail.com")
        emailTextField.tap()
        
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).tap()
    }
}

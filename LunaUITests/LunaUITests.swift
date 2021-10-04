//
//  LunaUITests.swift
//  LunaUITests
//
//  Created by Admin on 04/10/21.
//

import XCTest

class LunaUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {

    }

    func test_LoginValidation_With_VaildCredintials_Return_Success() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
 
        let tablesQuery = XCUIApplication().tables
                
        let emailTextField = tablesQuery/*@START_MENU_TOKEN@*/.textFields["Email"]/*[[".cells.textFields[\"Email\"]",".textFields[\"Email\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        emailTextField.typeText("somaygarg182@gmail.com")
        emailTextField.tap()
  
        let passwordSecureTextField = tablesQuery/*@START_MENU_TOKEN@*/.secureTextFields["Password"]/*[[".cells.secureTextFields[\"Password\"]",".secureTextFields[\"Password\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        passwordSecureTextField.typeText("123456")
        passwordSecureTextField.tap()

        let loginButton = tablesQuery/*@START_MENU_TOKEN@*/.buttons["Login"]/*[[".cells.buttons[\"Login\"]",".buttons[\"Login\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        loginButton.tap()
    }
    
    func test_LoginValidation_With_InvaildCredintials_Return_Success() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
 
        let tablesQuery = XCUIApplication().tables
        
                                
        let emailTextField = tablesQuery/*@START_MENU_TOKEN@*/.textFields["Email"]/*[[".cells.textFields[\"Email\"]",".textFields[\"Email\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        emailTextField.typeText("somay182@gmail.com")
        emailTextField.tap()
  
        
        let passwordSecureTextField = tablesQuery/*@START_MENU_TOKEN@*/.secureTextFields["Password"]/*[[".cells.secureTextFields[\"Password\"]",".secureTextFields[\"Password\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        passwordSecureTextField.typeText("123456789")
        passwordSecureTextField.tap()

    }
    

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

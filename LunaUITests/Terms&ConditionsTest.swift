//
//  Terms&ConditionsTest.swift
//  LunaUITests
//
//  Created by Admin on 04/10/21.
//

import XCTest

class Terms_ConditionsTest: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIApplication().launch()

    }

    override func tearDownWithError() throws {

    }

    func test_Terms_And_Conditions_During_App_Launch() throws {
        
        let app = XCUIApplication()
        
        XCTAssertTrue(app.staticTexts["Terms & Conditions"].exists)
        XCTAssertTrue(app.staticTexts["Accept"].exists)
                
    }
}


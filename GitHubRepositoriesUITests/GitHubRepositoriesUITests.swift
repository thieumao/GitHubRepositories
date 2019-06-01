//
//  GitHubRepositoriesUITests.swift
//  GitHubRepositoriesUITests
//
//  Created by Thieu Nguyen on 27/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import XCTest

class GitHubRepositoriesUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testOpenDetailRepoFlow() {
        let app = XCUIApplication()
        app.screenshot()

        if app.otherElements["LoginScreen"].exists {
            // login with username = "thieumao" & password = "123456"
            let usernameTextField = app.textFields["username"]
            usernameTextField.tap()
            usernameTextField.typeText("thieumao")

            let passwordTextField = app.secureTextFields["password"]
            passwordTextField.tap()
            passwordTextField.typeText("123456")

            let loginButton = app.buttons["Login"]

            // wait 1s for validate username & password
            // sleep(1)

            // wait for loginButton.isEnabled == true
            let isEnabledPredicate = NSPredicate(format: "isEnabled == true")
            expectation(for: isEnabledPredicate, evaluatedWith: loginButton, handler: nil)
            waitForExpectations(timeout: 5, handler: nil)

            loginButton.tap()
            app.screenshot()
        }

        // search with text ="thieumao"
        let searchTextField = app.textFields["Search"]
        searchTextField.tap()
        searchTextField.typeText("thieumao")


        // wait 3s for searching
        // sleep(3)

        // wait for "thieumao/thieumao.github.io" label to appear
        let label = app.staticTexts["thieumao/thieumao.github.io"]
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        // open DetailRepository Screen
        app.screenshot()
        let tableView = app.tables.element(boundBy: 0)
        let cell = tableView.cells.element(boundBy: 0)
        cell.tap()

        // check DetailRepository Screen did appear
        app.screenshot()
        let isShown = app.otherElements["DetailRepositoryScreen"].exists
        XCTAssertTrue(isShown)
    }
}

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

        // login with username = "thieumao" & password = "123456"
        app.screenshot()
        let username = app.textFields["username"]
        username.tap()
        username.typeText("thieumao")

        let password = app.secureTextFields["password"]
        password.tap()
        password.typeText("123456")

        sleep(1)
        app.buttons["Login"].tap()

        // search with text ="thieumao"
        app.screenshot()
        let search = app.textFields["Search"]
        search.tap()
        search.typeText("thieumao")
        sleep(3)

        // open Detail Repository Screen
        app.screenshot()
        let tableView = app.tables.element(boundBy: 0)
        let cell = tableView.cells.element(boundBy: 0)
        cell.tap()

        app.screenshot()
        let isShown = app.otherElements["DetailRepository"].exists

        XCTAssertTrue(isShown)
    }
}

//
//  LoginViewModelTests.swift
//  GitHubRepositoriesTests
//
//  Created by Thieu Nguyen on 1/6/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import XCTest
@testable import GitHubRepositories

class LoginViewModelTests: XCTestCase {
    var viewModel: LoginViewModel?

    override func setUp() {
        viewModel = LoginViewModel()
        super.setUp()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testValidatePassword() {
        guard let viewModel = viewModel else { return }

        XCTAssertTrue(viewModel.validatePassword("123456"))
        XCTAssertTrue(viewModel.validatePassword("111116"))

        XCTAssertFalse(viewModel.validatePassword("12345"))
        XCTAssertFalse(viewModel.validatePassword("1234567"))
        XCTAssertFalse(viewModel.validatePassword("111111"))
        XCTAssertFalse(viewModel.validatePassword("a11111"))
    }

    func testIs6DigitNumber() {
        guard let viewModel = viewModel else { return }

        XCTAssertTrue(viewModel.is6DigitNumber(text: "123456"))

        XCTAssertFalse(viewModel.is6DigitNumber(text: "12345"))
        XCTAssertFalse(viewModel.is6DigitNumber(text: "1234567"))
    }

    func testIsAllSameDigit() {
        guard let viewModel = viewModel else { return }

        XCTAssertTrue(viewModel.isAllSameDigit(text: "111111"))
        XCTAssertTrue(viewModel.isAllSameDigit(text: "2222"))

        XCTAssertFalse(viewModel.isAllSameDigit(text: "12345"))
        XCTAssertFalse(viewModel.isAllSameDigit(text: "123456"))
        XCTAssertFalse(viewModel.isAllSameDigit(text: "1234567"))
    }
}

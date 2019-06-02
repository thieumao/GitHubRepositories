//
//  SearchUsersServiceTests.swift
//  GitHubRepositoriesTests
//
//  Created by Thieu Nguyen on 1/6/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import XCTest
@testable import GitHubRepositories

class SearchUsersServiceTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSearchUsers() {
        let expectation = XCTestExpectation(description: "Search Users")
        SearchUsersServiceMock().searchUsers(keyword: "thieumao", success: { usernames in
            XCTAssertNotNil(usernames)
            expectation.fulfill()
        }, failure: { _ in
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 5.0)
    }
}

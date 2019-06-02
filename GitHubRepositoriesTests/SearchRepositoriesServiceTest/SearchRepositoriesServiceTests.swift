//
//  SearchRepositoriesServiceTests.swift
//  GitHubRepositoriesTests
//
//  Created by Thieu Nguyen on 1/6/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import XCTest
@testable import GitHubRepositories

class SearchRepositoriesServiceTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSearchRepositories() {
        let expectation = XCTestExpectation(description: "Search Repositories")
        SearchRepositoriesServiceMock().searchRepositories(keyword: "thieumao", success: { repos in
            XCTAssertFalse(repos.isEmpty)
            expectation.fulfill()
        }, failure: {
            XCTFail("Search repositories failed")
        })

        wait(for: [expectation], timeout: 5.0)
    }
}

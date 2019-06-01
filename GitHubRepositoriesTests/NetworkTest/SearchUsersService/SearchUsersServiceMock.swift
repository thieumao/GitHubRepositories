//
//  SearchUsersServiceMock.swift
//  GitHubRepositoriesTests
//
//  Created by Thieu Nguyen on 1/6/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import Foundation
@testable import GitHubRepositories

class SearchUsersServiceMock: SearchUsersFetch {
    func searchUsers(keyword: String, success: @escaping ([String]) -> Void, failure: @escaping (SearchUsersFetchError) -> Void) {
        var rawData = [String: Any]()
        let bundle = Bundle(for: SearchUsersServiceMock.self)
        if let path = bundle.path(forResource: "UserResponse", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [String: Any] {
                    // do stuff
                    rawData = jsonResult
                }
            } catch {
                // handle error
                failure(.notFound)
            }
        }

        guard let totalCount = rawData[APIConstants.Common.TOTAL_COUNT] as? Int,
            let items = rawData[APIConstants.Common.ITEMS] as? [[String: Any]]
            else {
                failure(.notFound)
                return
        }
        guard totalCount > 0 else {
            failure(.invalidData)
            return
        }
        var validUsernames: [String] =  []
        for item in items {
            if let username = item[APIConstants.Common.LOGIN] as? String {
                validUsernames.append(username)
            }
        }
        if validUsernames.isEmpty {
            failure(.invalidData)
        } else {
            success(validUsernames)
        }
    }
}

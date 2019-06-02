//
//  SearchRepositoriesServiceMock.swift
//  GitHubRepositoriesTests
//
//  Created by Thieu Nguyen on 1/6/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import Foundation
@testable import GitHubRepositories

class SearchRepositoriesServiceMock: SearchRepositoriesFetch {
    func searchRepositories(keyword: String, success: @escaping ([Repository]) -> Void, failure: @escaping () -> Void) {
        var rawData = [String: Any]()
        let bundle = Bundle(for: SearchRepositoriesServiceMock.self)
        if let path = bundle.path(forResource: "RepoResponse", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [String: Any] {
                    // do stuff
                    rawData = jsonResult
                }
            } catch {
                // handle error
                failure()
            }
        }

        guard let totalCount = rawData[APIConstants.Common.TOTAL_COUNT] as? Int,
            totalCount > 0,
            let items = rawData[APIConstants.Common.ITEMS] as?  [[String: Any]],
            items.count > 0
            else {
                failure()
                return
        }
        var repos: [Repository] = []
        for item in items {
            if let repo = Repository(JSON: item) {
                repos.append(repo)
            }
        }
        success(repos)
    }
}


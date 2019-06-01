//
//  SearchUsersService.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 28/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import Alamofire

enum SearchUsersFetchError {
    case invalidData
    case notFound
    case noConnection
}

protocol SearchUsersFetch {
    func searchUsers(keyword: String, success: @escaping ([String]) -> Void, failure: @escaping (SearchUsersFetchError) -> Void)
}

class SearchUsersService: SearchUsersFetch {
    func searchUsers(keyword: String, success: @escaping ([String]) -> Void, failure: @escaping (SearchUsersFetchError) -> Void) {
        APIClient.cancelAllRequests()
        APIClient.loadData(request: APIRouter.searchUsers(keyword: keyword), didFinishWithSuccess: { rawData in
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
        }, didFinishWithError: { _, _ in
            failure(.noConnection)
        })
    }
}

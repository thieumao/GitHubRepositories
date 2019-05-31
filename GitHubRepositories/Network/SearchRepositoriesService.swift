//
//  SearchRepositoriesService.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 28/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import Alamofire

protocol SearchRepositoriesFetch {
    func searchRepositories(keyword: String, success: @escaping ([Repository]) -> Void, failure: @escaping () -> Void)
}

class SearchRepositoriesService: SearchRepositoriesFetch {
    func searchRepositories(keyword: String, success: @escaping ([Repository]) -> Void, failure: @escaping () -> Void) {
        APIClient.cancelAllRequests()
        APIClient.loadData(request: APIRouter.searchRepositories(keyword: keyword), didFinishWithSuccess: { rawData in
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
            UserData.sharedInstance().favoriteRepositories = repos
            success(repos)
        }, didFinishWithError: { _, _ in
            failure()
        })
    }
}

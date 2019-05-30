//
//  SearchRepositoriesService.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 28/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import Alamofire

protocol SearchRepositoriesFetch {
    func searchRepositories(keyword: String, success: @escaping () -> Void, failure: @escaping () -> Void)
}

class SearchRepositoriesService: SearchRepositoriesFetch {
    func searchRepositories(keyword: String, success: @escaping () -> Void, failure: @escaping () -> Void) {
        APIClient.loadData(request: APIRouter.searchRepositories(keyword: keyword), didFinishWithSuccess: { _ in
            success()
        }, didFinishWithError: { _, _ in
            failure()
        })
    }
}

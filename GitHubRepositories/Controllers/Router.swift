//
//  Router.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 1/6/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import UIKit

class Router: NSObject {
    class func getLoginVC() -> LoginVC {
        let loginVC = LoginVC()
        let viewModel = LoginViewModel()
        loginVC.injectViewModel(with: viewModel)
        return loginVC
    }

    class func getMainVC() -> MainVC {
        let mainVC = MainVC()
        let viewModel = MainViewModel()
        mainVC.injectViewModel(with: viewModel)
        return mainVC
    }

    class func getDetailRepository(repository: Repository) -> DetailRepositoryVC {
        let detailRepoVC = DetailRepositoryVC()
        let viewModel = DetailRepositoryViewModel(repository: repository)
        detailRepoVC.injectViewModel(with: viewModel)
        return detailRepoVC
    }
}

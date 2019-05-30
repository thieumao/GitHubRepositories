//
//  MainViewModel.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 27/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import RxSwift

class MainViewModel {
    var isSearching = Variable(false)
    let disposeBag = DisposeBag()

    // Mark: Search repositories
    func searchRepositories(_ text: String) {
        SearchRepositoriesService().searchRepositories(keyword: text, success: {_ in 

        }, failure: {

        })
    }

    // Mark: Others
    func removeUserInfo() {
        UserData.sharedInstance().isLogin = false
        UserData.sharedInstance().username = ""
        UserData.sharedInstance().password = ""
    }
}

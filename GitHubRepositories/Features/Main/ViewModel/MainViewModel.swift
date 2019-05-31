//
//  MainViewModel.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 27/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import RxSwift

class MainViewModel: NSObject {
    let disposeBag = DisposeBag()
    var isSearching = Variable(false)
    var searchInput = Variable<String>("")
    var searchResult = Variable<[Repository]>([])
    var normalResult = Variable<[Repository]>([])

    override init() {
        super.init()
        bindingData()
    }

    func bindingData() {
        searchInput.asObservable().subscribe(onNext: { text in
            self.searchRepositories(text)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        normalResult.value = UserData.sharedInstance().favoriteRepositories
    }

    // Mark: Search repositories
    func searchRepositories(_ text: String) {
        guard !text.isEmpty else {
            searchResult.value = []
            return
        }
        SearchRepositoriesService().searchRepositories(keyword: text, success: { repos in
            self.searchResult.value = repos
            
        }, failure: {
            self.searchResult.value = []
        })
    }

    // Mark: Others
    func removeUserInfo() {
        UserData.sharedInstance().isLogin = false
        UserData.sharedInstance().username = ""
        UserData.sharedInstance().password = ""
    }
}

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
        showFavoristList()
    }

    func bindingData() {
        searchInput.asObservable().subscribe(onNext: { text in
            self.searchRepositories(text)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }

    func showFavoristList() {
        isSearching.value = false
        normalResult.value = RepoData.sharedInstance().favoriteRepositories
    }

    func showSearchingList() {
        isSearching.value = true
    }

    func addToFavoriteList(_ index: Int) {
        guard index >= 0, index < searchResult.value.count else { return }
        let isTicked = searchResult.value[index].isTicked
        searchResult.value[index].isTicked = !isTicked
        var favoriteList = RepoData.sharedInstance().favoriteRepositories
        let isExist = favoriteList.contains { (repo) -> Bool in
            repo.id == searchResult.value[index].id
        }
        if !isExist {
            favoriteList.append(searchResult.value[index])
            RepoData.sharedInstance().favoriteRepositories = favoriteList
        }
    }

    func removeToFavoriteList(_ index: Int) {
        guard index >= 0, index < searchResult.value.count else { return }
        let isTicked = searchResult.value[index].isTicked
        searchResult.value[index].isTicked = !isTicked
        var favoriteList = RepoData.sharedInstance().favoriteRepositories
        let firstIndex = favoriteList.firstIndex { (repo) -> Bool in
            repo.id == searchResult.value[index].id
        }
        if let removeIndex = firstIndex {
            favoriteList.remove(at: removeIndex)
            RepoData.sharedInstance().favoriteRepositories = favoriteList
        }
    }

    // Mark: Search repositories
    func searchRepositories(_ text: String) {
        guard !text.isEmpty else {
            searchResult.value = []
            return
        }
        SearchRepositoriesService().searchRepositories(keyword: text, success: { repos in
            var newRepos: [Repository] = []
            let favoriteList = RepoData.sharedInstance().favoriteRepositories
            for eachRepo in repos {
                for eachFavorite in favoriteList {
                    if eachRepo.id == eachFavorite.id {
                        eachRepo.isTicked = true
                        break
                    }
                }
                newRepos.append(eachRepo)
            }
            self.searchResult.value = newRepos
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

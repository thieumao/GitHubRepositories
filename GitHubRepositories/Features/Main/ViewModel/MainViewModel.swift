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
        updateSearchResult(searchResult.value)
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

    func removeFromFavoriteList(_ index: Int) {
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

    func sortByStarCount() {
        let currentRepos = searchResult.value
        searchResult.value = currentRepos.sorted(by: { $0.starCount > $1.starCount })
    }

    func sortByTimeUpdate() {
        let currentRepos = searchResult.value
        searchResult.value = currentRepos.sorted(by: { $0.updatedTime > $1.updatedTime })
    }

    // Mark: Search repositories
    func searchRepositories(_ text: String) {
        guard !text.isEmpty else {
            searchResult.value = []
            return
        }
        SearchRepositoriesService().searchRepositories(keyword: text, success: { repos in
            self.updateSearchResult(repos)
        }, failure: {
            self.searchResult.value = []
        })
    }

    private func updateSearchResult(_ repos: [Repository]) {
        var newRepos: [Repository] = []
        let favoriteList = RepoData.sharedInstance().favoriteRepositories
        for eachRepo in repos {
            let isContained = favoriteList.contains { (eachFavoriteList) -> Bool in
                eachFavoriteList.id == eachRepo.id
            }
            eachRepo.isTicked = isContained
            newRepos.append(eachRepo)
        }
        self.searchResult.value = newRepos
    }

    // Mark: Others
    func removeUserInfo() {
        UserData.sharedInstance().isLogin = false
        UserData.sharedInstance().username = ""
        UserData.sharedInstance().password = ""
    }
}

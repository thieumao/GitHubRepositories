//
//  MainViewModel.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 27/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import RxSwift
import RxCocoa

class MainViewModel {
    let disposeBag = DisposeBag()
    let isSearching = BehaviorRelay<Bool>(value: false)
    let searchInput = BehaviorRelay<String>(value: "")
    let searchResult = BehaviorRelay<[Repository]>(value: [])
    let normalResult = BehaviorRelay<[Repository]>(value: [])

    init() {
        bindingData()
    }

    private func bindingData() {
        searchInput.asObservable().subscribe(onNext: { [weak self] text in
            self?.searchRepositories(text)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }

    func showFavoristList() {
        isSearching.accept(false)
        let favoriteList = RepoData.sharedInstance().favoriteRepositories
        normalResult.accept(favoriteList)
        searchResult.accept([])
    }

    func showSearchingList() {
        isSearching.accept(true)
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
        let newRepos = currentRepos.sorted(by: { $0.starCount > $1.starCount })
        searchResult.accept(newRepos)
    }

    func sortByTimeUpdate() {
        let currentRepos = searchResult.value
        let newRepos = currentRepos.sorted(by: { $0.updatedTime > $1.updatedTime })
        searchResult.accept(newRepos)
    }

    // MARK: Search repositories
    func searchRepositories(_ text: String) {
        guard !text.isEmpty else {
            searchResult.accept([])
            return
        }
        guard !checkExistKeywordInCache(text) else {
            let repos = getReposInCache(text)
            searchResult.accept(repos)
            return
        }
        SearchRepositoriesService().searchRepositories(keyword: text, success: { [weak self] repos in
            guard let self = self else { return }
            self.updateSearchResult(repos)
            self.cacheRecentSearches(keyword: text, repos: repos)
        }, failure: { [weak self] in
            self?.searchResult.accept([])
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
        searchResult.accept(newRepos)
    }

    // MARK: Local Data
    func removeUserInfo() {
        UserData.sharedInstance().isLogin = false
        UserData.sharedInstance().username = ""
        UserData.sharedInstance().password = ""
    }

    func cacheRecentSearches(keyword: String, repos: [Repository]) {
        var currentRecentSearches = RepoData.sharedInstance().recentSearches
        var dicts: [[String: Any]] = []
        for repo in repos {
            let dict = repo.getDictionary()
            dicts.append(dict)
        }
        currentRecentSearches[keyword] = dicts
        RepoData.sharedInstance().recentSearches = currentRecentSearches
    }

    func checkExistKeywordInCache(_ keyword: String) -> Bool {
        let recentSearches = RepoData.sharedInstance().recentSearches
        return recentSearches[keyword] != nil
    }

    func getReposInCache(_ keyword: String) -> [Repository] {
        var repos: [Repository] = []
        let recentSearches = RepoData.sharedInstance().recentSearches
        guard let dicts = recentSearches[keyword] as? [[String: Any]]
            else { return repos }
        for dict in dicts {
            if let repo = Repository(JSON: dict) {
                repos.append(repo)
            }
        }
        return repos
    }
}

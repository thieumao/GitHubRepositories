//
//  DetailRepositoryViewModel.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 31/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import RxSwift
import RxCocoa

class DetailRepositoryViewModel {
    let fullname = BehaviorRelay<String>(value: "")
    let description = BehaviorRelay<String>(value: "")
    let starCount = BehaviorRelay<String>(value: "0")
    let forkCount = BehaviorRelay<String>(value: "0")
    let language = BehaviorRelay<String>(value: "")

    private var repository: Repository

    init(repository: Repository) {
        self.repository = repository
        bindingData()
    }

    private func bindingData() {
        fullname.accept(repository.fullname)
        description.accept(repository.description)
        starCount.accept(String(repository.starCount))
        forkCount.accept(String(repository.forkCount))
        language.accept(repository.language)
    }

    func removeFromFavoriteList() {
        var favoriteList = RepoData.sharedInstance().favoriteRepositories
        let firstIndex = favoriteList.firstIndex { (repo) -> Bool in
            repo.id == repository.id
        }
        if let removeIndex = firstIndex {
            favoriteList.remove(at: removeIndex)
            RepoData.sharedInstance().favoriteRepositories = favoriteList
        }
    }

    func checkShowDeleteButton() -> Bool {
        let favoriteList = RepoData.sharedInstance().favoriteRepositories
        let isContained = favoriteList.contains { (repo) -> Bool in
            repo.id == repository.id
        }
        return isContained
    }
}

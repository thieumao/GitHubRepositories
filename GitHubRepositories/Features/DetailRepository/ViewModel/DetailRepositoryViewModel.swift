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
    var fullname = BehaviorRelay<String>(value: "")
    var description = BehaviorRelay<String>(value: "")
    var starCount = BehaviorRelay<String>(value: "0")
    var forkCount = BehaviorRelay<String>(value: "0")
    var language = BehaviorRelay<String>(value: "")
    var isShowedDeleteButton = BehaviorRelay<Bool>(value: false)

    var repository: Repository

    init(repository: Repository) {
        self.repository = repository
        bindingData()
        handleShowDeleteButton()
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

    private func bindingData() {
        fullname.accept(repository.fullname)
        description.accept(repository.description)
        starCount.accept(String(repository.starCount))
        forkCount.accept(String(repository.forkCount))
        language.accept(repository.language)
    }

    private func handleShowDeleteButton() {
        let favoriteList = RepoData.sharedInstance().favoriteRepositories
        let isContained = favoriteList.contains { (repo) -> Bool in
            repo.id == repository.id
        }
        isShowedDeleteButton.accept(isContained)
    }
}

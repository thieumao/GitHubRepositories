//
//  DetailRepositoryViewModel.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 31/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import RxSwift

class DetailRepositoryViewModel {
    var fullname = Variable<String>("")
    var description = Variable<String>("")
    var stars = Variable<String>("0")
    var forks = Variable<String>("0")
    var language = Variable<String>("")
    var isShowedDeleteButton = Variable(false)

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
        fullname.value = repository.fullname ?? ""
        description.value = repository.description ?? ""
        stars.value = String(repository.stars ?? 0)
        forks.value = String(repository.forks ?? 0)
        language.value = repository.language ?? ""
    }

    private func handleShowDeleteButton() {
        let favoriteList = RepoData.sharedInstance().favoriteRepositories
        let isContained = favoriteList.contains { (repo) -> Bool in
            repo.id == repository.id
        }
        isShowedDeleteButton.value = isContained
    }
}

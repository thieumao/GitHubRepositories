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

    var repository: Repository

    init(repository: Repository) {
        self.repository = repository
        bindingData()
    }

    private func bindingData() {
        fullname.value = repository.fullname ?? ""
        description.value = repository.description ?? ""
        stars.value = String(repository.stars ?? 0)
        forks.value = String(repository.forks ?? 0)
        language.value = repository.language ?? ""
    }
}

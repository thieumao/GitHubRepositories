//
//  RepoData.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 31/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

class RepoData: TMUserDefaults {
    private static var sharedInstanceVar = RepoData()

    override static func sharedInstance() -> RepoData {
        return sharedInstanceVar
    }

    struct ClassConstant {
        static let FAVORITE_REPOSITORIES = "favoriteRepositories"
    }

    var favoriteRepositories: [Repository] {
        get {
            let list = getObject(ClassConstant.FAVORITE_REPOSITORIES) as? [[String : Any]] ?? []
            var repos: [Repository] = []
            for item in list {
                if let repo = Repository(JSON: item) {
                    repos.append(repo)
                }
            }
            return repos
        }
        set {
            var list: [[String: Any]] = []
            for repo in newValue {
                list.append(repo.getDictionary())
            }
            set(list, forKey: ClassConstant.FAVORITE_REPOSITORIES)
        }
    }
}

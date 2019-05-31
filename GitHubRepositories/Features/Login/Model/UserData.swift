//
//  UserData.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 29/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import KeychainSwift

class UserData: TMUserDefaults {
    private static var sharedInstanceVar = UserData()
    private var keychain = KeychainSwift()

    override static func sharedInstance() -> UserData {
        return sharedInstanceVar
    }

    struct ClassConstant {
        static let IS_LOGIN = "isLogin"
        static let USERNAME = "username"
        static let PASSWORD = "password"
        static let VALID_USERNAMES = "validUsernames"
        static let FAVORITE_REPOSITORIES = "favoriteRepositories"
    }

    var isLogin: Bool {
        get {
            return getObject(ClassConstant.IS_LOGIN) as? Bool ?? false
        }
        set {
            set(newValue, forKey: ClassConstant.IS_LOGIN)
        }
    }

    var username: String {
        get {
            return getObject(ClassConstant.USERNAME) as? String ?? ""
        }
        set {
            set(newValue, forKey: ClassConstant.USERNAME)
        }
    }

    var password: String {
        get {
            return keychain.get(ClassConstant.PASSWORD) ?? ""
        }
        set {
            keychain.set(newValue, forKey: ClassConstant.PASSWORD)
        }
    }

    var validUsernames: [String] {
        get {
            return getObject(ClassConstant.VALID_USERNAMES) as? [String] ?? []
        }
        set {
            set(newValue, forKey: ClassConstant.VALID_USERNAMES)
        }
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
                let dictionary: [String : Any] = [
                    "full_name" : repo.fullname ?? "",
                    "description" : repo.description ?? "",
                    "stargazers_count" : repo.stars ?? "0",
                    "forks_count" : repo.forks ?? "0",
                    "language" : repo.language ?? ""
                ]
                list.append(dictionary)
            }
            set(list, forKey: ClassConstant.FAVORITE_REPOSITORIES)
        }
    }
}

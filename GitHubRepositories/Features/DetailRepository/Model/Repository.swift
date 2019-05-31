//
//  Repository.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 31/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import ObjectMapper

class Repository: Mappable {
    var fullname: String?
    var description: String?
    var stars: Int?
    var forks: Int?
    var language: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        fullname <- map["full_name"]
        description <- map["description"]
        stars <- map["stargazers_count"]
        forks <- map["forks_count"]
        language <- map["language"]
    }

}

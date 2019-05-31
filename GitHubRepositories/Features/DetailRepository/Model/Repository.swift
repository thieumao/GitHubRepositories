//
//  Repository.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 31/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import ObjectMapper

class Repository: Mappable {
    var id: Int = 0
    var fullname: String?
    var description: String?
    var stars: Int?
    var forks: Int?
    var language: String?
    var isTicked = false

    required init?(map: Map) {}

    func mapping(map: Map) {
        id <- map["id"]
        fullname <- map["full_name"]
        description <- map["description"]
        stars <- map["stargazers_count"]
        forks <- map["forks_count"]
        language <- map["language"]
    }

    func getDictionary() -> [String : Any] {
        let dictionary: [String : Any] = [
            "id": id ?? "0",
            "full_name" : fullname ?? "",
            "description" : description ?? "",
            "stargazers_count" : stars ?? "0",
            "forks_count" : forks ?? "0",
            "language" : language ?? ""
        ]
        return dictionary
    }
}

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
    var fullname: String = ""
    var description: String = ""
    var starCount: Int = 0
    var forkCount: Int = 0
    var language: String = ""
    var updatedTime: String = ""
    var isTicked = false

    required init?(map: Map) {}

    func mapping(map: Map) {
        id <- map["id"]
        fullname <- map["full_name"]
        description <- map["description"]
        starCount <- map["stargazers_count"]
        language <- map["forks_count"]
        language <- map["language"]
        updatedTime <- map["updated_at"]
    }

    func getDictionary() -> [String : Any] {
        let dictionary: [String : Any] = [
            "id": id,
            "full_name" : fullname,
            "description" : description,
            "stargazers_count" : starCount,
            "forks_count" : forkCount,
            "language" : language,
            "updated_at" : updatedTime
        ]
        return dictionary
    }
}

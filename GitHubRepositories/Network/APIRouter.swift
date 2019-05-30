//
//  APIRouter.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 28/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import Alamofire
import Foundation

public enum APIRouter: URLRequestConvertible {

    case searchUsers(keyword: String)
    case searchRepositories(keyword: String)

    var baseURL: String {
        return "https://api.github.com"
    }

    var path: String {
        switch self {
        case .searchUsers:
            return "/search/users"
        case .searchRepositories:
            return "/search/repositories"
        }
    }

    var bodyParameters: [String: Any] {
        switch self {
        case let .searchUsers(keyword):
            return ["q": keyword]
        case let .searchRepositories(keyword):
            return ["q": keyword]
        }
    }

    var queryParameters: [String: Any] {
        return [:]
    }

    var method: HTTPMethod {
        return .get
    }

    var headers: [String: Any] {
        return APIClient.getGuestHeaders()
    }

    var encoding: ParameterEncoding {
        return URLEncoding.default
    }

    public func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()

        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue

        for headerField in headers.keys {
            request.setValue(headers[headerField] as? String, forHTTPHeaderField: headerField)
        }

        request.timeoutInterval = TimeInterval(10)

        if queryParameters.isEmpty {
            return try encoding.encode(request, with: bodyParameters)
        } else {
            let queryRequest = try URLEncoding(destination: .queryString).encode(request, with: queryParameters)
            var bodyRequest = try encoding.encode(request, with: bodyParameters)
            bodyRequest.url = queryRequest.url
            return bodyRequest
        }
    }
}

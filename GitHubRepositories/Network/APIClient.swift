//
//  APIClient.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 28/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import Alamofire

struct RequestConstants {
    static let USERNAME = "q"
}

class APIClient: NSObject {
    static func loadData(request: URLRequestConvertible,
                         didFinishWithSuccess: @escaping (([String: Any]) -> Void),
                         didFinishWithError: @escaping ((Int, String) -> Void)) {
        Alamofire.request(request).responseJSON { response in
            if let errorResponse = response.result.error {
                let errorCode = (errorResponse as NSError).code
                didFinishWithError(errorCode, errorResponse.localizedDescription)
            } else {
                guard let data = response.data else { return }
                let dataObject = CommonHelper.getObject(FromJSONData: data)
                let jsonData = dataObject as? [String: Any] ?? [:]
                didFinishWithSuccess(jsonData)
            }
        }
    }

    static func cancelAllRequests() {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }

    static func getGuestHeaders() -> HTTPHeaders {
        var httpHeaders: [String: String] = [:]
        httpHeaders["Content-Type"] = "application/json"
        return httpHeaders
    }
}

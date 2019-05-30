//
//  CommonHelper.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 28/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import Foundation

class CommonHelper {
    class func getDictionary(FromJSONString JSONString: String?) -> [String: Any]? {
        return getObject(FromJSONString: JSONString) as? [String: Any]
    }

    class func getArray(FromJSONString JSONString: String?) -> [Any]? {
        return getObject(FromJSONString: JSONString) as? [Any]
    }

    class func getObject(FromJSONString JSONString: String?) -> Any? {
        var object: Any?

        guard
            let JSONString = JSONString,
            let data = JSONString.data(using: String.Encoding.utf8)
            else { return object }
        object = getObject(FromJSONData: data)

        return object
    }

    class func getObject(FromJSONData data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        } catch {
            // #TODO Handle This
        }
        return nil
    }

    class func getData(FromJSONObject object: Any) -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: object, options: .init(rawValue: 0))
        } catch {}
        return nil
    }

    class func getJSONString(FromJSONObject object: Any) -> String {
        guard
            let data = getData(FromJSONObject: object),
            let JSONString = String(data: data, encoding: String.Encoding.utf8)
            else { return "" }
        return JSONString
    }
}

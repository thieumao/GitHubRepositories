//
//  TMUserDefaults.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 29/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import UIKit

class TMUserDefaults: UserDefaults {
    private static let sharedInstanceVar = TMUserDefaults()

    class func sharedInstance() -> TMUserDefaults {
        return sharedInstanceVar
    }

    override func set(_ value: Any?, forKey key: String) {
        var data: Data?
        if let value = value {
            data = NSKeyedArchiver.archivedData(withRootObject: value)
        }
        standardUserDefaults().set(data, forKey: getKey(ForString: key))
    }

    func getKey(ForString originalKey: String) -> String {
        return className + originalKey
    }

    func standardUserDefaults() -> UserDefaults {
        return UserDefaults.standard
    }

    func getObject(_ key: String) -> Any? {
        let value = standardUserDefaults().object(forKey: getKey(ForString: key))
        if let data = value as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: data)
        } else {
            return value
        }
    }

    func getArray(_ key: String) -> [Any]? {
        guard let data = standardUserDefaults().object(forKey: getKey(ForString: key)) as? Data else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? [Any]
    }
}

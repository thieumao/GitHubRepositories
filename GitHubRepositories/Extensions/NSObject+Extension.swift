//
//  NSObject+Extension.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 29/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import UIKit

extension NSObject {
    public var className: String {
        return String(describing: type(of: self))
    }

    public class var className: String {
        return String(describing: self)
    }
}

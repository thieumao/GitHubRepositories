//
//  LoginViewModel.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 27/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import Foundation

class LoginViewModel {

    func saveUserInfo() {
        // todo: save local data
    }

    // MarK: Validate Username
    func validateUsername(text: String) -> Bool{
        return true
    }

    // MarK: Validate Password
    func validatePassword(text: String) -> Bool{
        return is6DigitNumber(text: text) && !isAllSameDigit(text: text)
    }

    private func is6DigitNumber(text: String) -> Bool {
        return validatePattern(text: text, regex: "[0-9]{6}")
    }

    private func isAllSameDigit(text: String) -> Bool {
        return validatePattern(text: text, regex: "^(.)\\1*$")
    }

    private func validatePattern(text: String, regex: String) -> Bool{
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", regex)
        return passwordTest.evaluate(with: text)
    }
}

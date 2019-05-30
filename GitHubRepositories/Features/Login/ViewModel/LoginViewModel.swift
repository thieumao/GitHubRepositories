//
//  LoginViewModel.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 27/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import Foundation
import RxSwift

class LoginViewModel: NSObject {

    var username = Variable("")
    var password = Variable("")
    var isValidUsername = Variable(false)
    var isValidPassword = Variable(false)
    var isValid = Variable(false)
    let disposeBag = DisposeBag()

    func bindingData() {
        password.asObservable().subscribe(onNext: { (text) in
            self.isValidPassword.value = self.validatePassword(text)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        username.asObservable().subscribe(onNext: { (text) in
            self.validateUsername(text)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        isValidPassword.asObservable().subscribe(onNext: { (value) in
            self.validateUsername(self.username.value)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        isValidUsername.asObservable().subscribe(onNext: { (value) in
            self.isValid.value = value && self.isValidPassword.value
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }

    // Mark: Validate Username
    private func validateUsername(_ text: String) {
        if text.isEmpty {
            isValidUsername.value = false
            return
        }
        if checkValidUsernameInCache(text) {
            isValidUsername.value = true
            return
        }
        SearchUsersService().searchUsers(keyword: text, success: { usernames in
            self.cacheValidUsernames(usernames)
            self.isValidUsername.value = true
        }, failure: {
            self.isValidUsername.value = false
        })
    }

    // Mark: Validate Password
    private func validatePassword(_ text: String) -> Bool {
        if text.isEmpty {
            return false
        }
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

    // Mark: Others
    func saveUserInfo() {
        UserData.sharedInstance().isLogin = true
        UserData.sharedInstance().username = username.value
        UserData.sharedInstance().password = password.value
    }

    func cacheValidUsernames(_ usernames: [String]) {
        var currentValidUsernames = UserData.sharedInstance().validUsernames
        for eachUsername in usernames {
            if !currentValidUsernames.contains(eachUsername) {
                currentValidUsernames.append(eachUsername)
            }
        }
        UserData.sharedInstance().validUsernames = currentValidUsernames
    }

    func checkValidUsernameInCache(_ text: String) -> Bool {
        return UserData.sharedInstance().validUsernames.contains(text)
    }
}

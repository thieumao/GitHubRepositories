//
//  LoginViewModel.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 27/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import RxSwift
import RxCocoa

class LoginViewModel: NSObject {
    var username = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    var isValidUsername = BehaviorRelay<Bool>(value: false)
    var isValidPassword = BehaviorRelay<Bool>(value: false)
    var isValid = BehaviorRelay<Bool>(value: false)
    let disposeBag = DisposeBag()

    func bindingData() {
        password.asObservable().subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.isValidPassword.accept(self.validatePassword(text))
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        username.asObservable().subscribe(onNext: { [weak self] text in
            self?.validateUsername(text)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        isValidPassword.asObservable().subscribe(onNext: { [weak self] value in
            guard let self = self else { return }
            self.validateUsername(self.username.value)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        isValidUsername.asObservable().subscribe(onNext: { [weak self] value in
            guard let self = self else { return }
            self.isValid.accept(value && self.isValidPassword.value)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }

    // Mark: Validate Username
    private func validateUsername(_ text: String) {
        if text.isEmpty {
            isValidUsername.accept(false)
            return
        }
        if checkValidUsernameInCache(text) {
            isValidUsername.accept(true)
            return
        }
        SearchUsersService().searchUsers(keyword: text, success: { [weak self] usernames in
            guard let self = self else { return }
            self.cacheValidUsernames(usernames)
            self.isValidUsername.accept(true)
        }, failure: { [weak self] in
            self?.isValidUsername.accept(false)
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

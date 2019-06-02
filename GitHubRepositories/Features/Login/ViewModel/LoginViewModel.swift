//
//  LoginViewModel.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 27/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import RxSwift
import RxCocoa

class LoginViewModel {
    let username = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let isValidUsername = BehaviorRelay<Bool>(value: false)
    let isValidPassword = BehaviorRelay<Bool>(value: false)
    let isValid = BehaviorRelay<Bool>(value: false)
    let disposeBag = DisposeBag()

    init() {
        bindingData()
    }

    private func bindingData() {
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

    func resetData() {
        username.accept("")
        password.accept("")
        isValid.accept(false)
    }

    // MARK: Validate Username
    private func validateUsername(_ text: String) {
        if text.isEmpty || checkInvalidUsernameInCache(text) {
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
        }, failure: { [weak self] error in
            guard let self = self else { return }
            if error == .invalidData {
                self.cacheInvalidUsernames(with: text)
            }
            self.isValidUsername.accept(false)
        })
    }

    // MARK: Validate Password
    func validatePassword(_ text: String) -> Bool {
        if text.isEmpty {
            return false
        }
        return is6DigitNumber(text: text) && !isAllSameDigit(text: text)
    }

    func is6DigitNumber(text: String) -> Bool {
        return validatePattern(text: text, regex: "[0-9]{6}")
    }

    func isAllSameDigit(text: String) -> Bool {
        return validatePattern(text: text, regex: "^(.)\\1*$")
    }

    private func validatePattern(text: String, regex: String) -> Bool{
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", regex)
        return passwordTest.evaluate(with: text)
    }

    // MARK: Local Data
    func saveUserInfo() {
        UserData.sharedInstance().isLogin = true
        UserData.sharedInstance().username = username.value
        UserData.sharedInstance().password = password.value
    }

    func cacheInvalidUsernames(with keyword: String) {
        var currentInvalidUsernames = UserData.sharedInstance().invalidUsernames
        if !currentInvalidUsernames.contains(keyword) {
            currentInvalidUsernames.append(keyword)
        }
        UserData.sharedInstance().invalidUsernames = currentInvalidUsernames
    }

    func checkInvalidUsernameInCache(_ text: String) -> Bool {
        return UserData.sharedInstance().invalidUsernames.contains(text)
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

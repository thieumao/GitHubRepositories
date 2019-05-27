//
//  LoginVC.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 27/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    let viewModel = LoginViewModel()

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        usernameTextField.delegate = self
        usernameTextField.addTarget(self, action: #selector(usernameTextFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)

        loginButton.isEnabled = viewModel.validatePassword(text: passwordTextField.text ?? "")
    }

    @objc func usernameTextFieldDidChange(_ textField: UITextField) {
        updateLoginButtonStatus()
    }

    @objc func passwordTextFieldDidChange(_ textField: UITextField) {
        updateLoginButtonStatus()
    }

    // MARK: Action Methods
    @IBAction func loginButtonAction(_ sender: Any) {
        closeKeyboard()
        viewModel.saveUserInfo()
        openMainScreen()
    }

    @IBAction func closeKeyboardAction(_ sender: Any) {
        closeKeyboard()
    }

    // MARK: Private Methods
    private func openMainScreen() {
        // open Main Screen
    }

    private func closeKeyboard() {
        view.endEditing(true)
    }

    private func updateLoginButtonStatus() {
        loginButton.isEnabled = validateCredentials()
    }

    private func validateCredentials() -> Bool{
        return viewModel.validateUsername(text: usernameTextField.text ?? "")
            && viewModel.validatePassword(text: passwordTextField.text ?? "")
    }
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordTextField.becomeFirstResponder()
        return true
    }
}

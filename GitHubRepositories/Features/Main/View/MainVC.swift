//
//  MainVC.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 27/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum MainState {
    case normal
    case searching
}

class MainVC: UIViewController {

    let viewModel = MainViewModel()
    let disposeBag = DisposeBag()

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchingTableView: UITableView!
    @IBOutlet weak var normalTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        blindUI()
    }

    private func blindUI() {
        viewModel.isSearching.asObservable().subscribe(onNext: { (isSearching) in
            let state: MainState = isSearching ? .searching : .normal
            self.updateUI(state)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        cancelButton.rx.tap.do(onNext:  {
            self.searchTextField.resignFirstResponder()
        }).subscribe(onNext: {
            self.viewModel.isSearching.value = false
        }).disposed(by: disposeBag)
    }

    private func updateUI(_ state: MainState) {
        switch state {
        case .normal:
            title = Constants.Titles.NORMAL
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.Buttons.LOGOUT,
                                                                style: .done, target: self,
                                                                action: #selector(logoutButtonTapped))
            cancelButton.isHidden = true
            searchingTableView.isHidden = true
            normalTableView.isHidden = false
        case .searching:
            title = Constants.Titles.SEARCHING
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: Constants.Buttons.POPULAR,
                                                               style: .done, target: self,
                                                               action: #selector(mostPopularButtonTapped))
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.Buttons.RECENT,
                                                                style: .done, target: self,
                                                                action: #selector(mostRecentButtonTapped))
            cancelButton.isHidden = false
            searchingTableView.isHidden = false
            normalTableView.isHidden = true
        }
    }

    @objc public func logoutButtonTapped() {
        viewModel.removeUserInfo()
        dismiss(animated: true, completion: nil)
    }

    @objc public func mostPopularButtonTapped() {
    }

    @objc public func mostRecentButtonTapped() {
    }
}

extension MainVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // show keyboard
        viewModel.isSearching.value = true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // todo: search
        return true
    }
}

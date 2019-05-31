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
    var state: MainState = .normal

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchingTableView: UITableView!
    @IBOutlet weak var normalTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        normalTableView.register(UINib(nibName: "NormalCell", bundle: nil), forCellReuseIdentifier: "NormalCell")
        searchingTableView.register(UINib(nibName: "SearchingCell", bundle: nil), forCellReuseIdentifier: "SearchingCell")
        normalTableView.keyboardDismissMode = .onDrag
        searchingTableView.keyboardDismissMode = .onDrag
        blindUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch state {
        case .normal:
            viewModel.showFavoristList()
        case .searching:
            viewModel.showSearchingList()
        }
    }

    private func blindUI() {
        viewModel.isSearching.asObservable().subscribe(onNext: { (isSearching) in
            self.state = isSearching ? .searching : .normal
            self.updateUI()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        cancelButton.rx.tap.do(onNext:  {
            self.closeKeyboard()
        }).subscribe(onNext: {
            self.viewModel.showFavoristList()
        }).disposed(by: disposeBag)

        searchTextField.rx.text.orEmpty
            .throttle(2, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .asObservable().bind(to: viewModel.searchInput).disposed(by: disposeBag)

        viewModel.normalResult.asObservable().bind(to: normalTableView.rx.items(cellIdentifier: "NormalCell", cellType: NormalCell.self)){ (index, repo, cell) in
            cell.repository = repo
        }.disposed(by: disposeBag)

        viewModel.searchResult.asObservable().bind(to: searchingTableView.rx.items(cellIdentifier: "SearchingCell", cellType: SearchingCell.self)){ (index, repo, cell) in
            cell.didTapTick = {
                if repo.isTicked {
                    self.viewModel.removeFromFavoriteList(index)
                } else {
                    self.viewModel.addToFavoriteList(index)
                }
                cell.repository = repo
            }
            cell.repository = repo
        }.disposed(by: disposeBag)

        normalTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.normalTableView.deselectRow(at: indexPath, animated: true)
                if let cell = self?.normalTableView.cellForRow(at: indexPath) as? NormalCell,
                    let repo = cell.repository {
                    self?.closeKeyboard()
                    self?.openDetailRepositoryVC(repo)
                }
            }).disposed(by: disposeBag)

        searchingTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.searchingTableView.deselectRow(at: indexPath, animated: true)
                if let cell = self?.searchingTableView.cellForRow(at: indexPath) as? SearchingCell,
                    let repo = cell.repository {
                    self?.closeKeyboard()
                    self?.openDetailRepositoryVC(repo)
                }
            }).disposed(by: disposeBag)
    }

    private func openDetailRepositoryVC(_ repo: Repository) {
        let detailRepositoryVC = DetailRepositoryVC()
        let viewModel = DetailRepositoryViewModel(repository: repo)
        detailRepositoryVC.injectViewModel(with: viewModel)
        navigationController?.pushViewController(detailRepositoryVC, animated: true)
    }

    private func closeKeyboard() {
        view.endEditing(true)
    }

    private func updateUI() {
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
            searchTextField.text = ""
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
        viewModel.showSearchingList()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let keyword = textField.text, state == .searching {
            viewModel.searchRepositories(keyword)
        }
        return true
    }
}

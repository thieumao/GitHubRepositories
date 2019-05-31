//
//  DetailRepositoryVC.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 27/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DetailRepositoryVC: UIViewController {

    var viewModel: DetailRepositoryViewModel?

    func injectViewModel(with detailRepositoryViewModel: DetailRepositoryViewModel) {
        viewModel = detailRepositoryViewModel
    }

    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var startCountLabel: UILabel!
    @IBOutlet weak var forkCountLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!

     let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.Titles.REPOSITORY_DETAIL
        let deleteButton = UIBarButtonItem(title: Constants.Buttons.DELETE,
                                           style: .done, target: self,
                                           action: #selector(deleteButtonTapped))
        let isShowedDeleteButton = viewModel?.isShowedDeleteButton.value ?? false
        navigationItem.rightBarButtonItem = isShowedDeleteButton ? deleteButton : nil
        blindUI()
    }

    private func blindUI() {
        viewModel?.fullname.asObservable().bind(to: fullnameLabel.rx.text).disposed(by: disposeBag)
        viewModel?.description.asObservable().bind(to: descriptionLabel.rx.text).disposed(by: disposeBag)
        viewModel?.starCount.asObservable().bind(to: startCountLabel.rx.text).disposed(by: disposeBag)
        viewModel?.forkCount.asObservable().bind(to: forkCountLabel.rx.text).disposed(by: disposeBag)
        viewModel?.language.asObservable().bind(to: languageLabel.rx.text).disposed(by: disposeBag)
    }

    @objc public func deleteButtonTapped() {
        navigationItem.rightBarButtonItem = nil
        viewModel?.removeFromFavoriteList()
    }
}

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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.Buttons.DELETE,
                                                            style: .done, target: self,
                                                            action: #selector(deleteButtonTapped))
        blindUI()
    }

    private func blindUI() {
        viewModel?.fullname.asObservable().bind(to: fullnameLabel.rx.text).disposed(by: disposeBag)
        viewModel?.description.asObservable().bind(to: descriptionLabel.rx.text).disposed(by: disposeBag)
        viewModel?.stars.asObservable().bind(to: startCountLabel.rx.text).disposed(by: disposeBag)
        viewModel?.forks.asObservable().bind(to: forkCountLabel.rx.text).disposed(by: disposeBag)
        viewModel?.language.asObservable().bind(to: languageLabel.rx.text).disposed(by: disposeBag)
    }

    @objc public func deleteButtonTapped() {
        let count = RepoData.sharedInstance().favoriteRepositories.count
        print("count = \(count)")
    }
}

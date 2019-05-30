//
//  RepositoryDetailVC.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 27/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import UIKit

class RepositoryDetailVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.Titles.REPOSITORY_DETAIL
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.Buttons.DELETE,
                                                            style: .done, target: self,
                                                            action: #selector(deleteButtonTapped))
    }

    @objc public func deleteButtonTapped() {
    }
}

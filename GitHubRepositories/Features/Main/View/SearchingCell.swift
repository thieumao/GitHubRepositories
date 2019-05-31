//
//  SearchingCell.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 31/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import UIKit

class SearchingCell: UITableViewCell {
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var tickButton: UIButton!

    var didTapTick: (() -> Void)?

    var repository: Repository? {
        didSet {
            repoNameLabel.text = repository?.fullname
            if repository?.isTicked ?? false {
                tickButton.setImage(UIImage(named: "tick"), for: .normal)
            } else {
                tickButton.setImage(UIImage(named: "untick"), for: .normal)
            }
        }
    }

    @IBAction func tickButtonAction(_ sender: Any) {
        didTapTick?()
    }
}

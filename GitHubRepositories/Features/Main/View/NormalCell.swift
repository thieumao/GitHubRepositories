//
//  NormalCell.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 31/5/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import UIKit

class NormalCell: UITableViewCell {
    @IBOutlet weak var repoNameLabel: UILabel!

    var repository: Repository? {
        didSet {
            repoNameLabel.text = repository?.fullname
        }
    }
}

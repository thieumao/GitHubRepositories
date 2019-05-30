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

    var repository: Repository? {
        didSet {
            repoNameLabel.text = repository?.fullname
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

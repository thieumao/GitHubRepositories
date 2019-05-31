//
//  UIViewController+Extension.swift
//  GitHubRepositories
//
//  Created by Thieu Nguyen on 1/6/19.
//  Copyright © 2019 Mao. All rights reserved.
//

import UIKit

extension UIViewController {
    func popViewController(_ animated: Bool) {
        _ = navigationController?.popViewController(animated: animated)
    }

    func popToRoot(_ animated: Bool) {
        _ = navigationController?.popToRootViewController(animated: animated)
    }

    func pushViewControllerAnimated(_ viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

    func dismissViewController(Animated animated: Bool) {
        if navigationController != nil {
            popViewController(animated)
        } else {
            dismiss(animated: animated, completion: nil)
        }
    }
}

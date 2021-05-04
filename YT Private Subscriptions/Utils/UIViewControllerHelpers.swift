//
//  UIViewControllerHelpers.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 03/05/21.
//

import UIKit

extension UIViewController {
    func showSimpleAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alertVC, animated: true)
    }
}

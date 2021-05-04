//
//  UIViewControllerHelpers.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 03/05/21.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    func showSimpleAlert(title: String, message: String) {
        guard Thread.current.isMainThread else {
            DispatchQueue.main.async { self.showSimpleAlert(title: title, message: message) }
            return
        }

        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alertVC, animated: true)
    }

    func showProgressHUD(title: String, message: String) {
        guard Thread.current.isMainThread else {
            DispatchQueue.main.async { self.showProgressHUD(title: title, message: message) }
            return
        }

        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .indeterminate
        hud.label.text = title
        hud.detailsLabel.text = message
    }

    func hideProgressHUD() {
        guard Thread.current.isMainThread else {
            DispatchQueue.main.async { self.hideProgressHUD() }
            return
        }

        MBProgressHUD.hide(for: self.view, animated: true)
    }

    func showNetworkProgressHUD() {
        showProgressHUD(title: "Please Wait", message: "A network operation is in progress")
    }
}

//
//  HomeTabViewController.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 24/04/21.
//

import UIKit
import RxSwift

class HomeTabViewController: UITabBarController, UITabBarControllerDelegate {
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self

        NetworkMonitor.shared.isConnected
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isConnected in
                if !isConnected {
                    self?.showSimpleAlert(title: "No Network", message:
                            """
                            This app requires interet connection to function properly.
                            Certain features will be disabled until internet connection is available again.
                            """.replacingOccurrences(of: "\n", with: " "))
                }
            })
            .disposed(by: disposeBag)
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view,
              let toView = viewController.view
        else {
            return false
        }
        
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionCrossDissolve], completion: nil)
        }
        
        return true
    }
}

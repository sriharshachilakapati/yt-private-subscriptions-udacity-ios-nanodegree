//
//  SubscriptionsViewController.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 24/04/21.
//

import UIKit

class SubscriptionsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subscribeLabel: UILabel!

    override func viewDidLoad() {
        tableView.register(UINib(nibName: YoutubeVideoTableViewCell.nibName, bundle: nil),
                           forCellReuseIdentifier: YoutubeVideoTableViewCell.reuseIdentifier)

        tableView.delegate = self
    }
}

extension SubscriptionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

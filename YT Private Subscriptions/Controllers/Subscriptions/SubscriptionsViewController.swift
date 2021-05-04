//
//  SubscriptionsViewController.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 24/04/21.
//

import UIKit
import RxSwift

class SubscriptionsViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let dataSource = SubscriptionVideosDataSource()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subscribeLabel: UILabel!

    //MARK: - View Life Cycle

    override func viewDidLoad() {
        tableView.register(UINib(nibName: YoutubeVideoTableViewCell.nibName, bundle: nil),
                           forCellReuseIdentifier: YoutubeVideoTableViewCell.reuseIdentifier)

        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshData), for: .valueChanged)

        SubscriptionsDao.getVideosFromSubscriptions()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] videos in
                self?.dataSource.videos = videos
                self?.subscribeLabel.isHidden = videos.count > 1
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        SubscriptionsDao.isNetworkCallInProgress
            .subscribe(onNext: { inProgress in
                if inProgress {
                    self.showNetworkProgressHUD()
                } else {
                    self.hideProgressHUD()
                }
            })
            .disposed(by: disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        SubscriptionsDao.refreshSubscriptions()
    }

    //MARK: - Routing logic

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toVideoPlayerScreen" else { return }

        guard let sender = sender as? VideoPlayerInput,
              let destVC = segue.destination as? VideoPlayerViewController
        else { return }

        destVC.input = sender
    }

    //MARK: - Handler functions

    @objc private func handleRefreshData() {
        SubscriptionsDao.refreshSubscriptions()
        self.tableView.refreshControl?.endRefreshing()
    }
}

//MARK: - UITableView Delegate

extension SubscriptionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let video = dataSource.videos[indexPath.row]
        let input = VideoPlayerInput(
            videoId: video.id ?? "",
            videoTitle: video.title ?? "",
            videoDescription: video.descriptionSnippet ?? "",
            channelId: video.channel?.id ?? "",
            channelName: video.channel?.name ?? "")

        performSegue(withIdentifier: "toVideoPlayerScreen", sender: input)
    }
}

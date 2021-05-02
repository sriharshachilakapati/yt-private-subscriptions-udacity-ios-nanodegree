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

    override func viewDidLoad() {
        tableView.register(UINib(nibName: YoutubeVideoTableViewCell.nibName, bundle: nil),
                           forCellReuseIdentifier: YoutubeVideoTableViewCell.reuseIdentifier)

        tableView.delegate = self
        tableView.dataSource = dataSource

        SubscriptionsDao.getVideosFromSubscriptions()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] videos in
                self?.dataSource.videos = videos
                self?.subscribeLabel.isHidden = videos.count > 1
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toVideoPlayerScreen" else { return }

        guard let sender = sender as? VideoPlayerInput,
              let destVC = segue.destination as? VideoPlayerViewController
        else { return }

        destVC.input = sender
    }
}

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

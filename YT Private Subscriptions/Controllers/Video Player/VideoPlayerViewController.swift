//
//  VideoPlayerViewController.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 30/04/21.
//

import UIKit
import RxSwift
import youtube_ios_player_helper

class VideoPlayerViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var videoPlayerView: YTPlayerView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var videoDescriptionLabel: UILabel!
    @IBOutlet weak var subscribeButton: UIButton!

    public var input: VideoPlayerInput!
    private var isSubscribed: Bool = false

    override func viewDidLoad() {
        videoPlayerView.load(withVideoId: input.videoId, playerVars: [
            "playsinline": 1,
            "autoplay": 1
        ])

        videoTitleLabel.text = input.videoTitle.htmlUnescaped
        channelNameLabel.text = input.channelName.htmlUnescaped
        videoDescriptionLabel.text = input.videoDescription.htmlUnescaped

        SubscriptionsDao.isNetworkCallInProgress
            .subscribe(onNext: { inProgress in
                if inProgress {
                    self.showNetworkProgressHUD()
                } else {
                    self.hideProgressHUD()
                }
            })
            .disposed(by: disposeBag)

        setupSubscribeButton()
    }

    @IBAction func onSubscribeButtonClicked() {
        if isSubscribed {
            SubscriptionsDao.unsubscribeChannel(id: input.channelId)
        } else {
            SubscriptionsDao.subscribeChannel(id: input.channelId) { _ in
                self.showSimpleAlert(title: "Network Failure", message: "Failed to fetch channel information to subscribe.")
            }
        }
    }

    private func setupSubscribeButton() {
        let originalColor = subscribeButton.backgroundColor

        subscribeButton.isEnabled = false

        SubscriptionsDao.isChannelSubscribed(id: input.channelId)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { isSubscribed in
                self.configureSubscribeButton(isSubscribed, originalColor)
                self.subscribeButton.isEnabled = true
            })
            .disposed(by: disposeBag)
    }

    private func configureSubscribeButton(_ isSubscribed: Bool, _ originalColor: UIColor?) {
        self.isSubscribed = isSubscribed

        let buttonText = isSubscribed ? "Unsubscribe" : "Subscribe"
        let buttonColor = isSubscribed ? UIColor.darkGray : originalColor

        subscribeButton.setTitle(buttonText, for: .normal)
        subscribeButton.backgroundColor = buttonColor
    }
}

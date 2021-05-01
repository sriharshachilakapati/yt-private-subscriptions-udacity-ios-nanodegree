//
//  VideoPlayerViewController.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 30/04/21.
//

import UIKit
import youtube_ios_player_helper

class VideoPlayerViewController: UIViewController {
    
    @IBOutlet weak var videoPlayerView: YTPlayerView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var videoDescriptionLabel: UILabel!

    var input: VideoPlayerInput!

    override func viewDidLoad() {
        videoPlayerView.load(withVideoId: input.videoId, playerVars: [
            "playsinline": 1,
            "autoplay": 1
        ])
        videoTitleLabel.text = input.videoTitle.htmlUnescaped
        channelNameLabel.text = input.channelName.htmlUnescaped
        videoDescriptionLabel.text = input.videoDescription.htmlUnescaped
    }

    @IBAction func onSubscribeButtonClicked() {
        // TODO: Implement later
    }
}

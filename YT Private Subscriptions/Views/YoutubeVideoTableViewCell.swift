//
//  YoutubeVideoTableViewCell.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 01/05/21.
//

import UIKit
import SDWebImage

class YoutubeVideoTableViewCell: UITableViewCell {
    static let reuseIdentifier = "youtube#video"
    static let nibName = String(describing: YoutubeVideoTableViewCell.self)

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var channelNameLabel: UILabel!

    func bind(data: SearchResult) {
        guard let url = URL(string: data.snippet.thumbnails.low.url) else { return }

        thumbnailImageView.sd_setImage(with: url, completed: nil)
        videoTitleLabel.text = data.snippet.title.htmlUnescaped
        channelNameLabel.text = data.snippet.channelTitle.htmlUnescaped
    }

    func bind(data: Video) {
        guard let url = URL(string: data.thumbnailUrl ?? "") else { return }

        thumbnailImageView.sd_setImage(with: url, completed: nil)
        videoTitleLabel.text = data.title?.htmlUnescaped
        channelNameLabel.text = data.channel?.name?.htmlUnescaped
    }
}

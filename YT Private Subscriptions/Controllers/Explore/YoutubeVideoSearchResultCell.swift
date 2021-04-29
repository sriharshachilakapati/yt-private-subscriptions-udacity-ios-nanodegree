//
//  YoutubeVideoSearchResultCell.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 29/04/21.
//

import UIKit
import SDWebImage

class YoutubeVideoSearchResultCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var channelNameLabel: UILabel!

    func bind(data: SearchResult) {
        guard let url = URL(string: data.snippet.thumbnails.low.url) else { return }

        thumbnailImageView.sd_setImage(with: url, completed: nil)
        videoTitleLabel.text = data.snippet.title
        channelNameLabel.text = data.snippet.channelTitle
    }
}

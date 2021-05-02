//
//  SubscriptionVideosDataSource.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 02/05/21.
//

import UIKit

class SubscriptionVideosDataSource: NSObject, UITableViewDataSource {
    var videos = [Video]()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = videos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: YoutubeVideoTableViewCell.reuseIdentifier, for: indexPath) as! YoutubeVideoTableViewCell
        cell.bind(data: result)
        return cell
    }
}

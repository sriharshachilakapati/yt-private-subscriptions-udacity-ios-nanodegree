//
//  ExploreSearchResultDataSource.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 29/04/21.
//

import UIKit

class ExploreSearchResultDataSource: NSObject, UITableViewDataSource {
    var searchResults = [SearchResult]()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = searchResults[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: result.id.kind, for: indexPath) as! YoutubeVideoSearchResultCell
        cell.bind(data: result)
        return cell
    }
}

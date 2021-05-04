//
//  SearchModel.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 28/04/21.
//

import Foundation

struct SearchRequest: Encodable {
    let key = YOUTUBE_API_KEY
    let part = "snippet"
    let maxResults = 50
    let type = "video"
    let q: String
}

struct SearchResponse: Decodable {
    let items: [SearchResult]
}

struct SearchResult: Decodable {
    let id: VideoResourceId
    var snippet: SearchResultSnippet
}

struct VideoResourceId: Decodable {
    let kind: String
    let videoId: String
}

struct SearchResultSnippet: Decodable {
    let channelId: String
    var title: String
    var description: String
    var channelTitle: String
    let thumbnails: VideoThumbnails
}

struct VideoThumbnails: Decodable {
    let low: VideoThumbnailInfo
    let medium: VideoThumbnailInfo
    let high: VideoThumbnailInfo

    enum CodingKeys: String, CodingKey {
        case low = "default"
        case medium
        case high
    }
}

struct VideoThumbnailInfo: Decodable {
    let url: String
    let width: Int
    let height: Int
}

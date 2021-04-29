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
    let id: SearchResultId
    let snippet: SearchResultSnippet
}

struct SearchResultId: Decodable {
    let kind: String
    let videoId: String
}

struct SearchResultSnippet: Decodable {
    let channelId: String
    let title: String
    let description: String
    let channelTitle: String
    let thumbnails: SearchResultThumbnails
}

struct SearchResultThumbnails: Decodable {
    let low: SearchResultThumbnailInfo
    let medium: SearchResultThumbnailInfo
    let high: SearchResultThumbnailInfo

    enum CodingKeys: String, CodingKey {
        case low = "default"
        case medium
        case high
    }
}

struct SearchResultThumbnailInfo: Decodable {
    let url: String
    let width: Int
    let height: Int
}

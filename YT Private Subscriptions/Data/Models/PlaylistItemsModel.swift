//
//  PlaylistItemsModel.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 01/05/21.
//

import Foundation

struct PlaylistItemsRequest: Encodable {
    let key = YOUTUBE_API_KEY
    let part = "snippet"
    let maxResults = 50
    let playlistId: String
}

struct PlaylistItemsResponse: Decodable {
    let items: [PlaylistItem]
}

struct PlaylistItem: Decodable {
    let kind: String
    let id: String
    let snippet: PlaylistItemSnippet
}

struct PlaylistItemSnippet: Decodable {
    let publishedAt: Date
    let channelId: String
    let title: String
    let description: String
    let thumbnails: VideoThumbnails
    let channelTitle: String
    let resourceId: VideoResourceId
}

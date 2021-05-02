//
//  ChannelInfoModel.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 01/05/21.
//

import Foundation

struct ChannelInfoRequest: Encodable {
    let key = YOUTUBE_API_KEY
    let part = "snippet,contentDetails"
    let maxResults = 50
    let id: String
}

struct ChannelInfoResponse: Decodable {
    let items: [ChannelInfo]
}

struct ChannelInfo: Decodable {
    let kind: String
    let id: String
    let contentDetails: ChannelContentDetails
    let snippet: ChannelSnippet
}

struct ChannelContentDetails: Decodable {
    let relatedPlaylists: RelatedPlaylists
}

struct ChannelSnippet: Decodable {
    let title: String
}

struct RelatedPlaylists: Decodable {
    let uploads: String
}

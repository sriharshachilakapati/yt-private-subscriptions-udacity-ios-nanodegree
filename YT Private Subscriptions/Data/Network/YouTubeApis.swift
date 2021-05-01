//
//  YouTubeApis.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 26/04/21.
//

import Foundation

let YOUTUBE_API_KEY = "<INSERT-YOUR-API-KEY-HERE>"
let BASE_URL = "https://www.googleapis.com/youtube/v3"

let searchSuggestionsApi = ApiDefinition<SearchSuggestionsRequest, SearchSuggestionsResponse>(
    url: "https://suggestqueries.google.com/complete/search",
    method: .get,
    getDecodableResponseRange: { (data: Data) in 19 ..< data.count - 1 }
)

let searchVideosApi = ApiDefinition<SearchRequest, SearchResponse>(
    url: BASE_URL + "/search",
    method: .get
)

let channelInfoApi = ApiDefinition<ChannelInfoRequest, ChannelInfoResponse>(
    url: BASE_URL + "/channels",
    method: .get
)

let playlistItemsApi = ApiDefinition<PlaylistItemsRequest, PlaylistItemsResponse>(
    url: BASE_URL + "/playlistItems",
    method: .get
)

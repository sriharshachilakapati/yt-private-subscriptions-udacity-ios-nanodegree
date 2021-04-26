//
//  YouTubeApis.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 26/04/21.
//

import Foundation

let YOUTUBE_API_KEY = "<INSERT-YOUR-API-KEY-HERE>"

let searchSuggestionsApi = ApiDefinition<SearchSuggestionsRequest, SearchSuggestionsResponse>(
    url: "https://suggestqueries.google.com/complete/search",
    method: .get,
    getDecodableResponseRange: { (data: Data) in 19 ..< data.count - 1 }
)

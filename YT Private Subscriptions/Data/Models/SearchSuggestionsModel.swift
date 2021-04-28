//
//  SearchSuggestionsModel.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 26/04/21.
//

import Foundation

struct SearchSuggestionsRequest: Encodable {
    let ds = "yt"
    let client = "youtube"
    let query: String

    enum CodingKeys: String, CodingKey {
        case ds
        case client
        case query = "q"
    }
}

enum SearchSuggestionsResponseContent: Decodable {
    case searchSuggestions([[SearchSuggestionsContent]])
    case unusedContent

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode([[SearchSuggestionsContent]].self) {
            self = .searchSuggestions(value)
            return
        }

        self = .unusedContent
    }
}

enum SearchSuggestionsContent: Decodable {
    case suggestionText(String)
    case unusedContent

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(String.self) {
            self = .suggestionText(value)
            return
        }

        self = .unusedContent
    }
}

typealias SearchSuggestionsResponse = [SearchSuggestionsResponseContent]

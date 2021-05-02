//
//  SearchSuggestionsViewModel.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 26/04/21.
//

import Foundation
import RxSwift
import RxCocoa

class SearchSuggestionsViewModel {
    var searchText: String = "" {
        didSet {
            _searchText.onNext(searchText)
        }
    }

    private let _searchText = PublishSubject<String>()
    private let disposeBag = DisposeBag()

    let searchSuggestions = PublishSubject<[String]>()

    init() {
        _searchText
            .debounce(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .flatMap { text -> Observable<SearchSuggestionsResponse> in
                let request = SearchSuggestionsRequest(query: text)
                return searchSuggestionsApi.call(withPayload: request)
                    .catch { error in
                        print(error)
                        return Observable.empty()
                    }
            }
            .subscribe(onNext: handleSearchResults(response:))
            .disposed(by: disposeBag)
    }

    private func handleSearchResults(response: SearchSuggestionsResponse) {
        let suggestionEntries = response.compactMap { item -> [[SearchSuggestionsContent]]? in
            guard case let .searchSuggestions(suggestions) = item else { return nil }
            return suggestions
        }

        let suggestions = suggestionEntries
            .flatMap { entries in entries }
            .flatMap { entries in entries }
            .compactMap { item -> String? in
                guard case let .suggestionText(text) = item else { return nil }
                return text
            }

        searchSuggestions.onNext(suggestions)
    }
}

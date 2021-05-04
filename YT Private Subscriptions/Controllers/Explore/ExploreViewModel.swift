//
//  ExploreViewModel.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 29/04/21.
//

import Foundation
import RxSwift

class ExploreViewModel {
    private let disposeBag = DisposeBag()

    let searchResults = PublishSubject<[SearchResult]>()
    let isNetworkCallInProgress = BehaviorSubject<Bool>(value: false)

    var searchText: String = "" {
        didSet {
            isNetworkCallInProgress.onNext(true)

            searchVideosApi.call(withPayload: SearchRequest(q: searchText))
                .observe(on: MainScheduler.asyncInstance)
                .catch({ error -> Observable<SearchResponse> in
                    print(error)
                    self.isNetworkCallInProgress.onNext(false)
                    return Observable.empty()
                })
                .subscribe(onNext: { response in
                    self.searchResults.onNext(response.items.map(self.unescapeHtmlEntities))
                    self.isNetworkCallInProgress.onNext(false)
                })
                .disposed(by: disposeBag)
        }
    }

    private func unescapeHtmlEntities(_ result: SearchResult) -> SearchResult {
        var newResult = result

        newResult.snippet.title = result.snippet.title.htmlUnescaped
        newResult.snippet.channelTitle = result.snippet.channelTitle.htmlUnescaped

        return newResult
    }
}

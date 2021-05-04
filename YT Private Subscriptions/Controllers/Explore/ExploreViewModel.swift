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
                    self.isNetworkCallInProgress.onNext(false)
                    self.searchResults.onNext(response.items)
                })
                .disposed(by: disposeBag)
        }
    }
}

//
//  SubscriptionsDao.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 01/05/21.
//

import Foundation
import RxSwift
import CoreData

final class SubscriptionsDao {
    private init() {}

    static let isNetworkCallInProgress = BehaviorSubject(value: false)

    //MARK: - Subscription Queries

    static func getVideosFromSubscriptions() -> Observable<[Video]> {
        let fetchRequest: NSFetchRequest<Video> = Video.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let context = DataController.shared.backgroundContext

        fetchRequest.sortDescriptors = [ sortDescriptor ]
        return ObservableFetchRequest(fetchRequest: fetchRequest, context: context).asObservable()
    }

    static func isChannelSubscribed(id: String) -> Observable<Bool> {
        let fetchRequest: NSFetchRequest<Channel> = Channel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.propertiesToFetch = []
        let context = DataController.shared.backgroundContext

        return ObservableFetchRequest(fetchRequest: fetchRequest, context: context)
            .asObservable()
            .flatMap { Observable.just($0.count == 1) }
    }

    //MARK: - Manage Subscriptions

    static func subscribeChannel(id: String, onFailure: ((Error) -> Void)? = nil) {
        var disposeBag: DisposeBag? = DisposeBag()

        isNetworkCallInProgress.onNext(true)
        channelInfoApi.call(withPayload: ChannelInfoRequest(id: id))
            .catch { error in
                print(error)
                disposeBag = nil
                self.isNetworkCallInProgress.onNext(false)

                onFailure?(error)
                return Observable.empty()
            }
            .subscribe(onNext: { response in
                self.isNetworkCallInProgress.onNext(false)

                guard response.items.count == 1 else {
                    disposeBag = nil
                    return
                }

                let context = DataController.shared.backgroundContext

                context.perform {
                    let channel = Channel(context: context)
                    channel.id = response.items[0].id
                    channel.name = response.items[0].snippet.title
                    channel.uploadsPlaylistId = response.items[0].contentDetails.relatedPlaylists.uploads

                    guard let _ = try? context.save() else {
                        disposeBag = nil
                        return
                    }

                    disposeBag = nil
                }
            })
            .disposed(by: disposeBag!)
    }

    static func unsubscribeChannel(id: String) {
        let context = DataController.shared.backgroundContext
        let fetchRequest: NSFetchRequest<Channel> = Channel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        context.perform {
            guard let channels = try? fetchRequest.execute() else { return }

            if channels.count == 1 {
                context.delete(channels[0])
            }

            guard let _ = try? context.save() else { return }
        }
    }

    //MARK: - Update Subscriptions from Network

    static func refreshSubscriptions() {
        var disposeBag: DisposeBag? = DisposeBag()

        func getAllChannels() -> [Channel] {
            let fetchRequest: NSFetchRequest<Channel> = Channel.fetchRequest()
            fetchRequest.propertiesToFetch = [ "id", "uploadsPlaylistId" ]
            return ((try? fetchRequest.execute()) ?? [])!
        }

        let context = DataController.shared.backgroundContext

        context.perform {
            var collectibles = [Observable<(Channel, PlaylistItemsResponse)>]()
            self.isNetworkCallInProgress.onNext(true)

            for channel in getAllChannels() {
                let request = PlaylistItemsRequest(playlistId: channel.uploadsPlaylistId!)
                let apiCall = playlistItemsApi
                    .call(withPayload: request)
                    .flatMap { Observable.just((channel, $0)) }

                collectibles.append(apiCall)
            }

            Observable.zip(collectibles)
                .catch { error in
                    print(error)
                    self.isNetworkCallInProgress.onNext(false)
                    return Observable.just([])
                }
                .subscribe(onNext: { results in
                    self.isNetworkCallInProgress.onNext(false)

                    for result in results {
                        self.refreshSubscriptions(result.0, result.1)
                    }

                    disposeBag = nil
                    guard let _ = try? context.save() else { return }
                })
                .disposed(by: disposeBag!)
        }
    }

    private static func refreshSubscriptions(_ channel: Channel, _ response: PlaylistItemsResponse) {
        for item in response.items {
            let video = Video(context: DataController.shared.backgroundContext)
            video.channel = channel
            video.date = item.snippet.publishedAt
            video.descriptionSnippet = item.snippet.description
            video.title = item.snippet.title
            video.id = item.snippet.resourceId.videoId
            video.thumbnailUrl = item.snippet.thumbnails.low.url
        }
    }
}

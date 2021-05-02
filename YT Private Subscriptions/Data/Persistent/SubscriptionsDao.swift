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

    static func subscribeChannel(id: String) {
        var disposeBag: DisposeBag? = DisposeBag()

        channelInfoApi.call(withPayload: ChannelInfoRequest(id: id))
            .subscribe(onNext: { response in
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
}

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
}

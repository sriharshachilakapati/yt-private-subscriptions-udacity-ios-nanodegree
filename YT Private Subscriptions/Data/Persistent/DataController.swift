//
//  DataController.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 30/04/21.
//

import Foundation
import CoreData

final class DataController {
    static let shared = DataController()

    var persistentContainer = NSPersistentContainer(name: "SubscriptionsModel")

    lazy var viewContext: NSManagedObjectContext = persistentContainer.viewContext
    lazy var backgroundContext: NSManagedObjectContext = persistentContainer.newBackgroundContext()

    private init() {}

    func load() {
        persistentContainer.loadPersistentStores { _, error in
            guard error == nil else { fatalError(error!.localizedDescription) }
            self.configureContexts()
        }
    }

    private func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true

        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
}

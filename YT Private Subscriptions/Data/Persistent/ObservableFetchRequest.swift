//
//  ObservableFetchRequest.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 01/05/21.
//

import Foundation
import RxSwift
import CoreData

// Credit: Adapted from https://betterprogramming.pub/rxswift-observable-and-core-data-55ab87fc02ea
//
// Changes made:
//
//   1. The original article depends on using `NSFetchedResultsController` to listen to changes in the context object
//      and re-emit the data. However, the documentation suggests that `NSFetchedResultsController` is to be used from
//      the main thread as a data provider to table views or collection views. But since an observer can technically be
//      observed from any thread (read scheduler), I'm changing it out to use the background context and rely on the
//      notifications from context instead. This is being done as a API design measure.
//
//   2. The original article does subscription counting so as to know when to stop observing changes. This though is
//      not really required since we can delegate it to the deinit construct. We start listening in the init block.
//
//   3. I kinda feel that the `where` syntax is a bit verbose, so I reduced the usage of it whenever possible. Generic
//      out-bounds are now specified along with the type parameter itself.
//
// For interested folks, my original implementation that doesn't use RxSwift but my own Observable implementation can
// be seen at my GitHub in my Virtual Tourist project.
//
// https://github.com/sriharshachilakapati/virtual-tourist-udacity-ios-nanodegree/blob/main/Virtual%20Tourist/Virtual%20Tourist/Data/Framework/ObservableFetchRequest.swift
//
// Now, onto the actual implementation.
class ObservableFetchRequest<T: NSManagedObject>: NSObject, ObservableType {
    typealias Element = [T]

    private let results = BehaviorSubject<[T]>(value: [])

    private let fetchRequest: NSFetchRequest<T>
    private let context: NSManagedObjectContext

    init(fetchRequest: NSFetchRequest<T>, context: NSManagedObjectContext) {
        self.fetchRequest = fetchRequest
        self.context = context
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(performFetch), name: .NSManagedObjectContextDidSave, object: context)
        performFetch()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func subscribe<O: ObserverType>(_ observer: O) -> Disposable where Element == O.Element {
        let disposable = results.subscribe(
            onNext: { observer.onNext($0) },
            onError: { observer.onError($0) },
            onCompleted: { observer.onCompleted() },
            onDisposed: {}
        )

        return DelegatingDisposable(observableFR: self, originalDisposable: disposable)
    }

    @objc private func performFetch() {
        DispatchQueue.main.async {
            self.context.perform {
                guard let results = try? self.fetchRequest.execute() else { return }
                self.results.onNext(results)
            }
        }
    }

    private class DelegatingDisposable: Disposable {
        private var observableFR: ObservableFetchRequest?
        private var originalDisposable: Disposable?

        init(observableFR: ObservableFetchRequest, originalDisposable: Disposable) {
            self.observableFR = observableFR
            self.originalDisposable = originalDisposable
        }

        func dispose() {
            originalDisposable?.dispose()
            observableFR = nil
            originalDisposable = nil
        }
    }
}

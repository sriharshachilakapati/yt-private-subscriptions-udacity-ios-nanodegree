//
//  NetworkMonitor.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 03/05/21.
//

import Foundation
import Network
import RxSwift

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()

    let isConnected = BehaviorSubject<Bool>(value: true)

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected.onNext(path.status == .satisfied)
        }

        monitor.start(queue: DispatchQueue.global())
    }

    deinit {
        monitor.cancel()
    }
}

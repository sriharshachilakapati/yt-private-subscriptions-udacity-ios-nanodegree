//
//  AppDelegate.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 24/04/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    //MARK: - UIApplication Lifecycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DataController.shared.load()
        return true
    }

    //MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}


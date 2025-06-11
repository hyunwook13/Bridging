//
//  AppDelegate.swift
//  Feature
//
//  Created by 이현욱 on 5/29/25.
//

import UIKit
import Common
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        _ = AuthManager.shared
        return true
    }
}

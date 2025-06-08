//
//  AppDelegate.swift
//  Feature
//
//  Created by 이현욱 on 5/29/25.
//

import UIKit

import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("여기 들어오는거 아니야? ")
        FirebaseApp.configure()
        return true
    }
}

//
//  Logger.swift
//  Bridging
//
//  Created by 이현욱 on 4/25/25.
//

import Foundation

import FirebaseAnalytics

public struct BridgingLogger {
    public static func logEvent(_ eventName: String, parameters: [String: Any] = [:]) {
        print("---------log Event---------")
        print(eventName)
        print(parameters)
        print("--------------------------")
        Analytics.logEvent(eventName, parameters: parameters)
    }
}

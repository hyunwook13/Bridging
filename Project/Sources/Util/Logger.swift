//
//  Logger.swift
//  Bridging
//
//  Created by 이현욱 on 4/25/25.
//

import Foundation

import FirebaseAnalytics

struct BridgingLogger {
    static func logEvent(_ eventName: String, parameters: [String: Any] = [:]) {
        Analytics.logEvent(eventName, parameters: parameters)
    }
}

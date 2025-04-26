//
//  Logger.swift
//  Bridging
//
//  Created by 이현욱 on 4/25/25.
//

import Foundation

import Supabase

struct AppLogger: SupabaseLogger {
    func log(message: SupabaseLogMessage) {
        print(message.description)
    }
}

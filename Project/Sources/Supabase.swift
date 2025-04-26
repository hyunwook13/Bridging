//
//  Supabase.swift
//  Bridging
//
//  Created by 이현욱 on 4/25/25.
//

import Foundation

import Supabase

let supabase = SupabaseClient(
    supabaseURL: URL(string: SupabaseConstant.supabaseURL)!,
    supabaseKey: SupabaseConstant.ANON_API_KEY,
    options: SupabaseClientOptions(
        global: SupabaseClientOptions.GlobalOptions(
            logger: AppLogger()
        )
    )
)

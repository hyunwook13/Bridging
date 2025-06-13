//
//  enum.swift
//  Core
//
//  Created by 이현욱 on 6/9/25.
//

import Foundation

public enum Gender: String, Codable, CaseIterable{
    case man   = "남성"
    case woman = "여성"
}

public enum AgeGroup: String, Codable, CaseIterable {
    case teen = "10"
    case twenties = "20"
    case thirties = "30"
    case forties = "40"
    case fifties = "50"
    case sixties = "60"
}

public enum DiscussionState: Int, Codable {
    case none = 0
    case open = 1
    case closed = 2
}

public enum VoteType: String, Codable {
    case agree
    case disagree
}

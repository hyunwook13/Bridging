//
//  Vote.swift
//  Core
//
//  Created by 이현욱 on 5/26/25.
//

import Foundation

import FirebaseFirestore

public enum VoteType: String, Codable {
    case agree
    case disagree
}

public struct Vote: Codable {
    @DocumentID public var uuid: String?
    public let vote: VoteType
    public let ageGroup: AgeGroup
    public let createdAt: Timestamp
}

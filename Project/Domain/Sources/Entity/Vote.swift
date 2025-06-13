//
//  Vote.swift
//  Core
//
//  Created by 이현욱 on 5/26/25.
//

import Foundation

public struct Vote {
    public let uuid: String
    public let vote: VoteType
    public let ageGroup: AgeGroup
    public let createdAt: Date
    
    public init(
        uuid: String,
        vote: VoteType,
        ageGroup: AgeGroup,
        createdAt: Date
    ) {
        self.uuid = uuid
        self.vote = vote
        self.ageGroup = ageGroup
        self.createdAt = createdAt
    }
}

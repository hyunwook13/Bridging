//
//  VoteDTO.swift
//  Core
//
//  Created by 이현욱 on 6/9/25.
//

import Foundation
import Domain

import FirebaseFirestore

public struct VoteDTO: Codable {
    @DocumentID public var uuid: String?
    public let vote: VoteType
    public let ageGroup: AgeGroup
    public let createdAt: Timestamp
}

public extension VoteDTO {
    init(from entity: Vote) {
        self.uuid = entity.uuid
        self.vote = entity.vote
        self.ageGroup = entity.ageGroup
        self.createdAt = Timestamp(date: entity.createdAt)
    }
}

public extension VoteDTO {
    func toEntity() -> Vote {
        return Vote(
            uuid: uuid ?? UUID().uuidString,
            vote: vote,
            ageGroup: ageGroup,
            createdAt: createdAt.dateValue()
        )
    }
}

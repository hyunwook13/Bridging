//
//  Comment.swift
//  Core
//
//  Created by 이현욱 on 5/27/25.
//

import Foundation

public struct Comment {
    public let uuid: String
    public let authorID: String
    public let createdAt: Date
    public let authorAgeGroup: AgeGroup
    public let authorNickName: String
    public let gender: Gender
    public let content: String
    public let vote: VoteType

    public init(
        uuid: String,
        authorID: String,
        createdAt: Date,
        authorAgeGroup: AgeGroup,
        authorNickName: String,
        gender: Gender,
        content: String,
        vote: VoteType
    ) {
        self.uuid = uuid
        self.authorID = authorID
        self.createdAt = createdAt
        self.authorAgeGroup = authorAgeGroup
        self.authorNickName = authorNickName
        self.gender = gender
        self.content = content
        self.vote = vote
    }
}

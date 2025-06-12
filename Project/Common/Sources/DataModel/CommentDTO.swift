//
//  CommentDTO.swift
//  Core
//
//  Created by 이현욱 on 6/9/25.
//

import Foundation
import Domain

import FirebaseFirestore

public struct CommentDTO: Codable {
    @DocumentID public var id: String?
    public let authorID: String
    public let createdAt: Timestamp
    public let authorAgeGroup: AgeGroup
    public let authorNickName: String
    public let gender: Gender
    public let content: String
    public let vote: VoteType

    public init(
        id: String? = nil,
        authorID: String,
        createdAt: Timestamp,
        authorAgeGroup: AgeGroup,
        authorNickName: String,
        gender: Gender,
        content: String,
        vote: VoteType
    ) {
        self.id = id
        self.authorID = authorID
        self.createdAt = createdAt
        self.authorAgeGroup = authorAgeGroup
        self.authorNickName = authorNickName
        self.gender = gender
        self.content = content
        self.vote = vote
    }
}

extension CommentDTO {
    func toEntity() -> Comment? {
        guard let id = id else { return nil }

        return Comment(
            uuid: id,
            authorID: authorID,
            createdAt: createdAt.dateValue(),
            authorAgeGroup: authorAgeGroup,
            authorNickName: authorNickName,
            gender: gender,
            content: content,
            vote: vote
        )
    }
}

public extension CommentDTO {
    init(from entity: Comment) {
        self.id = entity.uuid
        self.authorID = entity.authorID
        self.createdAt = Timestamp(date: entity.createdAt)
        self.authorAgeGroup = entity.authorAgeGroup
        self.authorNickName = entity.authorNickName
        self.gender = entity.gender
        self.content = entity.content
        self.vote = entity.vote
    }
}

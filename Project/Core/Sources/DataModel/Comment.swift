//
//  Comment.swift
//  Core
//
//  Created by 이현욱 on 5/27/25.
//

import Foundation

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

public struct Comment {
    public let uuid: String
    public let authorID: String
    public let createdAt: Timestamp
    public let authorAgeGroup: AgeGroup
    public let authorNickName: String
    public let gender: Gender
    public let content: String
}


extension CommentDTO {
    func toDomain() -> Comment? {
        guard let id = id else { return nil }

        return Comment(
            uuid: id,
            authorID: authorID,
            createdAt: createdAt,
            authorAgeGroup: authorAgeGroup,
            authorNickName: authorNickName,
            gender: gender,
            content: content
        )
    }
}

//extension Comment {
//    func toDTO() -> CommentDTO {
//        return CommentDTO(
//            id: uuid, // 직접 초기화하려면 init 필요
//            authorID: authorID,
//            createdAt: createdAt,
//            authorAgeGroup: authorAgeGroup,
//            authorNickName: authorNickName,
//            gender: gender,
//            content: content
//        )
//    }
//}

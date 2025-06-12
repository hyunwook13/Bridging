//
//  UserProfileDTO.swift
//  Core
//
//  Created by 이현욱 on 6/9/25.
//

import Foundation
import Domain

import FirebaseFirestore

public struct UserProfileDTO: Codable {
    public typealias PostUUID = String
    
    @DocumentID var uuid: String?
    
    // 서버 타임스탬프(작성 시점) 자동 저장
    @ServerTimestamp var createdAt: Timestamp?
    
    public var ageGroup: AgeGroup
    public var gender: Gender
    public var nickname: String
    public var posts: [PostUUID]
    
    // createdAt, uuid는 모두 Firestore에서 채워주므로
    // 로컬에서 초기화할 필요가 없는 파라미터로 뺍니다
    public init(
        ageGroup: AgeGroup,
        gender: Gender,
        nickname: String,
        posts: [PostUUID]
    ) {
        self.ageGroup = ageGroup
        self.gender = gender
        self.nickname = nickname
        self.posts = posts
    }
}

public extension UserProfileDTO {
    func toEntity() -> UserProfile? {
        guard let uuid = uuid, let createdAt = createdAt else { return nil }

        return UserProfile(
            uuid: uuid,
            createdAt: createdAt.dateValue(),
            ageGroup: ageGroup,
            gender: gender,
            nickname: nickname,
            posts: posts
        )
    }
}

public extension UserProfileDTO {
    init(from entity: UserProfile) {
        self.uuid = entity.uuid
        self.createdAt = Timestamp(date: entity.createdAt)
        self.ageGroup = entity.ageGroup
        self.gender = entity.gender
        self.nickname = entity.nickname
        self.posts = entity.posts
    }
}

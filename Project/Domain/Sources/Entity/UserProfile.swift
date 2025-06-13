//
//  UserProfile.swift
//  Bridging
//
//  Created by 이현욱 on 4/30/25.
//

import Foundation

public struct UserProfile {
    public let uuid: String
    public let createdAt: Date
    public let ageGroup: AgeGroup
    public let gender: Gender
    public let nickname: String
    public let posts: [String]
    
    public init(
        uuid: String,
        createdAt: Date,
        ageGroup: AgeGroup,
        gender: Gender,
        nickname: String,
        posts: [String]
    ) {
        self.uuid = uuid
        self.createdAt = createdAt
        self.ageGroup = ageGroup
        self.gender = gender
        self.nickname = nickname
        self.posts = posts
    }
}


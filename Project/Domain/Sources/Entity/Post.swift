//
//  Post.swift
//  Core
//
//  Created by 이현욱 on 6/9/25.
//

import Foundation

public struct Post: Equatable {
    public let id: String
    public let content: String
    public let createdAt: Date
    public let createdUserID: String
    public let imageURL: String?
    public let likeUserIDs: [String]
    public let reportedUserIDs: [String]
    public let categories: [String]
    public let title: String
    public let authorNickName: String
    public let authorGender: Gender
    public let authorAgeGroup: AgeGroup
    public let lastModified: Date?
    public let lastComment: String?
    public let discussionState: DiscussionState
    public let votes: [Vote]
    public let comments: [Comment]
    
    public let isTemporary: Bool

    public init(
        id: String,
        content: String,
        createdAt: Date,
        createdUserID: String,
        imageURL: String?,
        likeUserIDs: [String],
        reportedUserIDs: [String],
        categories: [String],
        title: String,
        authorNickName: String,
        authorGender: Gender,
        authorAgeGroup: AgeGroup,
        lastModified: Date?,
        lastComment: String?,
        discussionState: DiscussionState,
        votes: [Vote],
        comments: [Comment],
        isTemporary: Bool = false
    ) {
        self.id = id
        self.content = content
        self.createdAt = createdAt
        self.createdUserID = createdUserID
        self.imageURL = imageURL
        self.likeUserIDs = likeUserIDs
        self.reportedUserIDs = reportedUserIDs
        self.categories = categories
        self.title = title
        self.authorNickName = authorNickName
        self.authorGender = authorGender
        self.authorAgeGroup = authorAgeGroup
        self.lastModified = lastModified
        self.lastComment = lastComment
        self.discussionState = discussionState
        self.votes = votes
        self.comments = comments
        self.isTemporary = isTemporary
    }
}

extension Post {
    public static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id
    }
}

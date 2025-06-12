//
//  PostBuilder.swift
//  Core
//
//  Created by 이현욱 on 5/19/25.
//

import Foundation
import Domain

import FirebaseFirestore

protocol Builder {
    associatedtype Output
    func build() -> Output
}

public class PostBuilder: Builder {
    public static let shared = PostBuilder()
    
    public var uuid: String = UUID().uuidString
    public var content:       String = ""
    public var createdAt:     Date = Date()
    public var createdUserID: String = ""
    public var imageURL:      String?
    public var likeUserID:    [String] = []
    public var reportedUserID:[String] = []
    public var categories:    [String] = []
    public var title:         String = ""
    public var authorNickName:String = ""
    public var authorGender:  Gender = .man
    public var authorAgeGroup:AgeGroup = .teen
    public var lastModifed:   Date? = nil
    public var lastComment:   String?
    public var comment: [Comment] = []
    public var vote: [Vote] = []
    public var state: DiscussionState = .none
    
    public func setContext(_ content: String) -> Self {
        self.content = content
        return self
    }
    
    public func setCreatedAt(_ date: Date) -> Self {
        self.createdAt = date
        return self
    }
    
    public func setCreatedUserID(_ id: String) -> Self {
        self.createdUserID = id
        return self
    }
    
    public func setImageURL(_ url: String?) -> Self {
        self.imageURL = url
        return self
    }
    
    public func setLikeUserID(_ users: [String]) -> Self {
        self.likeUserID = users
        return self
    }
    
    public func setReportedUserID(_ users: [String]) -> Self {
        self.reportedUserID = users
        return self
    }
    
    public func setCategories(_ cates: [String]) -> Self {
        self.categories = cates
        return self
    }
    
    public func setTitle(_ title: String) -> Self {
        self.title = title
        return self
    }
    
    public func setAuthorNickName(_ nickName: String) -> Self {
        self.authorNickName = nickName
        return self
    }
    
    public func setAuthorGender(_ gender: Gender) -> Self {
        self.authorGender = gender
        return self
    }
    
    public func setAuthorAgeGroup(_ group: AgeGroup) -> Self {
        self.authorAgeGroup = group
        return self
    }
    
    public func setComments(_ comments: [Comment]) -> Self {
        self.comment = comments
        return self
    }
    
    public func setVotes(_ votes: [Vote]) -> Self {
        self.vote = votes
        return self
    }
    
    public func setLastModifed(_ date: Date) -> Self {
        self.lastModifed = date
        return self
    }
    
    public func setLastComment(_ comment: String) -> Self {
        self.lastComment = comment
        return self
    }
    
    public func setDiscussionState(_ state: DiscussionState) -> Self {
        self.state = state
        return self
    }
    
    public func build() -> Post {
        return Post(
            id: uuid,
            content: content,
            createdAt: createdAt,
            createdUserID: createdUserID,
            imageURL: imageURL,
            likeUserIDs: likeUserID,
            reportedUserIDs: reportedUserID,
            categories: categories,
            title: title,
            authorNickName: authorNickName,
            authorGender: authorGender,
            authorAgeGroup: authorAgeGroup,
            lastModified: lastModifed,
            lastComment: lastComment,
            discussionState: state,
            votes: vote,
            comments: comment,
            isTemporary: true
        )
    }
}

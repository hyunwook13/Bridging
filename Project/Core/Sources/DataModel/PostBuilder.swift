//
//  PostBuilder.swift
//  Core
//
//  Created by 이현욱 on 5/19/25.
//

import Foundation

import FirebaseFirestore

protocol Builder {
    associatedtype Output
    func build() -> Output
}

public class PostBuilder: Builder {
    public static let shared = PostBuilder()
    
    @DocumentID var uuid: String? = nil
    public var content:       String = ""
    public var createdAt:     Timestamp = .init()
    public var createdUserID: String = ""
    public var imageURL:      String?
    public var likeUserID:    [String] = []
    public var reportedUserID:[String] = []
    public var categories:    [String] = []
    public var title:         String = ""
    public var authorNickName:String = ""
    public var authorGender:  Gender = .man
    public var authorAgeGroup:AgeGroup = .teen
    public var lastModifed:   Timestamp? = nil
    public var lastComment:   String?
    public var comment: [CommentDTO] = []
    public var vote: [Vote] = []
    
    public func setContext(_ content: String) -> Self {
        self.content = content
        return self
    }
    
    public func setCreatedAt(_ date: Timestamp) -> Self {
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
    
    public func setComments(_ comments: [CommentDTO]) -> Self {
        self.comment = comments
        return self
    }
    
    public func setVotes(_ votes: [Vote]) -> Self {
        self.vote = votes
        return self
    }
    
    public func setLastModifed(_ date: Timestamp) -> Self {
        self.lastModifed = date
        return self
    }
    
    public func setLastComment(_ comment: String) -> Self {
        self.lastComment = comment
        return self
    }
    
    public func build() -> Post {
        Post(
            content: content,
            createdAt: createdAt,
            createdUserID: createdUserID,
            imageURL: imageURL,
            likeUserID: likeUserID,
            reportedUserID: reportedUserID,
            comment: comment,
            vote: vote,
            categories: categories,
            title: title,
            authorNickName: authorNickName,
            authorGender: authorGender,
            authorAgeGroup: authorAgeGroup,
            lastModifed: lastModifed,
            lastComment: lastComment,
            isTemporaryFlag: false
        )
    }
}

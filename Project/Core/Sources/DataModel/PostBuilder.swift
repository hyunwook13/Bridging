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
    @DocumentID var uuid: String? = nil
    public var commentsID:    [String] = []
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
    public var authorAgeGroup:String = ""
    public var lastModifed:   Timestamp? = nil
    public var lastComment:   String?
    
    func setCommentIDs(_ ids: [String]) -> Self {
        self.commentsID = ids
        return self
    }

    func setContext(_ content: String) -> Self {
        self.content = content
        return self
    }

    func setCreatedAt(_ date: Timestamp) -> Self {
        self.createdAt = date
        return self
    }

    func setCreatedUserID(_ id: String) -> Self {
        self.createdUserID = id
        return self
    }
    
    func setImageURL(_ url: String?) -> Self {
        self.imageURL = url
        return self
    }
    
    func setLikeUserID(_ users: [String]) -> Self {
        self.likeUserID = users
        return self
    }
    
    func setReportedUserID(_ users: [String]) -> Self {
        self.reportedUserID = users
        return self
    }
    
    func setCategories(_ cates: [String]) -> Self {
        self.categories = cates
        return self
    }
    
    func setTitle(_ title: String) -> Self {
        self.title = title
        return self
    }
    
    func setAuthorNickName(_ nickName: String) -> Self {
        self.authorNickName = nickName
        return self
    }
    
    func setAuthorGender(_ gender: Gender) -> Self {
        self.authorGender = gender
        return self
    }
    
    func setAuthorAgeGroup(_ group: String) -> Self {
        self.authorAgeGroup = group
        return self
    }
    
    func setLastModifed(_ date: Timestamp) -> Self {
        self.lastModifed = date
        return self
    }
    
    func setLastComment(_ comment: String) -> Self {
        self.lastComment = comment
        return self
    }
    
    func build() -> Post {
//        Post(
//            context: context,
//            createdAt: createdAt,
//            createdUserID: createdUserID,
//            title: title,
//            authorNickName: authorNickName,
//            authorGender: authorGender,
//            authorAgeGroup:
//        )
        
        Post(
            commentsID: commentsID,
            content: content,
            createdAt: createdAt,
            createdUserID: createdUserID,
            imageURL: imageURL,
            likeUserID: likeUserID,
            reportedUserID: reportedUserID,
            categories: categories,
            title: title,
            authorNickName: authorNickName,
            authorGender: authorGender,
            authorAgeGroup: authorAgeGroup,
            lastModifed: lastModifed,
            lastComment: lastComment,
            isTemporaryFlag: false
        )
        
//        Post(commentsID: <#T##[String]#>, context: <#T##String#>, createdUserID: <#T##String#>, likeUserID: <#T##[String]#>, reportedUserID: <#T##[String]#>, categories: <#T##[String]#>, title: <#T##String#>, authorNickName: <#T##String#>, authorGender: <#T##Gender#>, authorAgeGroup: <#T##String#>)
        
//        Post(
//            uuid: nil,
//            commentsID: commentsID,
//            categories: categories,
//            likeUserID: likeUserID,
//            reportedUserID: reportedUserID,
//            context: context,
//            createdAt: createdAt,
//            createdUserID: createdUserID,
//            title: title,
//            authorNickName: authorNickName,
//            authorGender: authorGender,
//            authorAgeGroup: authorAgeGroup,
//            imageURL: imageURL,
//            lastModifed: lastModifed,
//            lastComment: lastComment,
//            isTemporaryFlag: false
//        )
        
//        return Post(
//            uuid: uuid,
//            commentsID: commentsID,
//            categories: categories, context: context,
//            createdAt: createdAt,
//            createdUserID: createdUserID,
//            likeUserID: likeUserID,
//            reportedUserID: reportedUserIDcategories: categories, context: context,
//            createdAt: createdAt,
//            createdUserID: createdUserID,
//            likeUserID: likeUserID,
//            reportedUserID: reportedUserID,
//            title: title,
//            authorNickName: authorNickName,
//            authorGender: authorGender,
//            authorAgeGroup: authorAgeGroup
//        )
    }
}

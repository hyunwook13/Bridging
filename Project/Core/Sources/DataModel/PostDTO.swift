//
//  Post.swift
//  Bridging
//
//  Created by 이현욱 on 4/28/25.
//

import Foundation

import FirebaseFirestore

public struct PostDTO: Codable {
    @DocumentID public var uuid: String?
    public var content:       String
    public var createdAt:     Timestamp
    public var createdUserID: String
    public var imageURL:      String?
    public var likeUserID:    [String]
    public var reportedUserID:[String]
    public var categories:    [String]
    public var title:         String
    public var authorNickName:String
    public var authorGender:  Gender
    public var authorAgeGroup:AgeGroup
    public var lastModifed:   Timestamp? = nil
    public var lastComment:   String? = nil
    public var discussionState: DiscussionState = .none
    public var votes       :   [VoteDTO] = []
    public var comments    :   [CommentDTO] = []
    
    public var isTemporaryFlag: Bool = false
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // 필수 키
        self.content          = try container.decode(String.self, forKey: .content)
        
        self.createdAt        = try container.decode(Timestamp.self, forKey: .createdAt)
        
        self.createdUserID    = try container.decode(String.self, forKey: .createdUserID)
        
        self.title            = try container.decode(String.self, forKey: .title)
        self.authorNickName   = try container.decode(String.self, forKey: .authorNickName)
        self.authorGender     = try container.decode(Gender.self, forKey: .authorGender)
        self.authorAgeGroup   = try container.decodeIfPresent(AgeGroup.self, forKey: .authorAgeGroup) ?? .teen

        // 선택 키(배열)
        self.comments          = try container.decodeIfPresent([CommentDTO].self, forKey: .comments)      ?? []
        self.votes             = try container.decodeIfPresent([VoteDTO].self, forKey: .votes)            ?? []
        self.categories       = try container.decodeIfPresent([String].self, forKey: .categories)     ?? []
        self.likeUserID       = try container.decodeIfPresent([String].self, forKey: .likeUserID)     ?? []
        self.reportedUserID   = try container.decodeIfPresent([String].self, forKey: .reportedUserID) ?? []

        // 나머지 optional
        self.imageURL         = try container.decodeIfPresent(String.self, forKey: .imageURL)
        self.lastModifed      = try container.decodeIfPresent(Timestamp.self, forKey: .lastModifed)
        self.lastComment      = try container.decodeIfPresent(String.self, forKey: .lastComment)
        self.discussionState  = try container.decodeIfPresent(DiscussionState.self, forKey: .discussionState) ?? .none
    }

    private enum CodingKeys: String, CodingKey {
        case uuid
        case content
        case createdAt
        case createdUserID
        case imageURL
        case likeUserID
        case reportedUserID
        case categories
        case title
        case authorNickName
        case authorGender
        case authorAgeGroup
        case lastModifed
        case lastComment
        case votes
        case discussionState
        case comments
    }
}

public extension PostDTO {
    init(
//        uuid: String? = nil,
        content: String,
        createdAt: Timestamp = Timestamp(date: Date()),
        createdUserID: String,
        imageURL: String? = nil,
        likeUserID: [String],
        reportedUserID: [String],
        comment: [CommentDTO],
        vote: [VoteDTO],
        categories: [String],
        title: String,
        authorNickName: String,
        authorGender: Gender,
        authorAgeGroup: AgeGroup,
        lastModifed: Timestamp? = nil,
        lastComment: String? = nil,
        discussionState: DiscussionState = .none,
        isTemporaryFlag: Bool = false,
    ) {
//        self._uuid = /*nil*/
        self.content = content
        self.createdAt = createdAt
        self.createdUserID = createdUserID
        self.imageURL = imageURL
        self.likeUserID = likeUserID
        self.reportedUserID = reportedUserID
        self.categories = categories
        self.title = title
        self.authorNickName = authorNickName
        self.authorGender = authorGender
        self.authorAgeGroup = authorAgeGroup
        self.lastModifed = lastModifed
        self.lastComment = lastComment
        self.discussionState = discussionState
        self.isTemporaryFlag = isTemporaryFlag
        self.votes = vote
        self.comments = comment
    }
    
    static var empty = PostDTO(content: "", createdUserID: "", likeUserID: [], reportedUserID: [], comment: [], vote: [], categories: [], title: "", authorNickName: "", authorGender: .man, authorAgeGroup: .teen)
}

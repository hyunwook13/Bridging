//
//  Post.swift
//  Bridging
//
//  Created by 이현욱 on 4/28/25.
//

import Foundation

import FirebaseFirestore

public struct Post: Codable {
    @DocumentID public var uuid: String?
    public var commentsID:    [String]
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
    public var authorAgeGroup:String
    public var lastModifed:   Timestamp? = nil
    public var lastComment:   String? = nil
    
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
        self.authorAgeGroup   = try container.decode(String.self, forKey: .authorAgeGroup)

        // 선택 키(배열)
        self.commentsID       = try container.decodeIfPresent([String].self, forKey: .commentsID)     ?? []
        self.categories       = try container.decodeIfPresent([String].self, forKey: .categories)     ?? []
        self.likeUserID       = try container.decodeIfPresent([String].self, forKey: .likeUserID)     ?? []
        self.reportedUserID   = try container.decodeIfPresent([String].self, forKey: .reportedUserID) ?? []

        // 나머지 optional
        self.imageURL         = try container.decodeIfPresent(String.self, forKey: .imageURL)
        self.lastModifed      = try container.decodeIfPresent(Timestamp.self, forKey: .lastModifed)
        self.lastComment      = try container.decodeIfPresent(String.self, forKey: .lastComment)

    }

    private enum CodingKeys: String, CodingKey {
        case uuid
        case commentsID
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
    }
}

public extension Post {
    init(
//        uuid: String? = nil,
        commentsID: [String],
        content: String,
        createdAt: Timestamp = Timestamp(date: Date()),
        createdUserID: String,
        imageURL: String? = nil,
        likeUserID: [String],
        reportedUserID: [String],
        categories: [String],
        title: String,
        authorNickName: String,
        authorGender: Gender,
        authorAgeGroup: String,
        lastModifed: Timestamp? = nil,
        lastComment: String? = nil,
        isTemporaryFlag: Bool = false
    ) {
//        self._uuid = /*nil*/
        self.commentsID = commentsID
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
        self.isTemporaryFlag = isTemporaryFlag
    }
    
    static var empty = Post(commentsID: [], content: "", createdUserID: "", likeUserID: [], reportedUserID: [], categories: [], title: "", authorNickName: "", authorGender: .man, authorAgeGroup: "")
}

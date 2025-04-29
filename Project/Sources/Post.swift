//
//  Post.swift
//  Bridging
//
//  Created by 이현욱 on 4/28/25.
//

import Foundation

import FirebaseFirestore

struct Post: Codable {
    var commentsID: [String]
    var context: String
    var createdAt: Timestamp
    var createdUserID: String
    var imageURL: String?
    var likeUserID: [String]
    var reportedUserID: [String]
    var title: String
    var authorNickName: String
    var authorGender: String
    var authorAgeGroup: String
    var lastModifed: Timestamp
}

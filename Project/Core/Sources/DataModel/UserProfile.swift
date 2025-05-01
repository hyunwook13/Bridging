//
//  UserProfile.swift
//  Bridging
//
//  Created by 이현욱 on 4/30/25.
//

import Foundation

import FirebaseFirestore

public enum Gender: String, Codable, CaseIterable{
    case man   = "남성"
    case woman = "여성"
}

public enum AgeGroup: String, CaseIterable {
    case teen = "10"
    case twenties = "20"
    case thirties = "30"
    case forties = "40"
    case fifties = "50"
    case sixties = "60"
}

public struct UserProfile: Codable {
    public typealias PostUUID = String
    
    @DocumentID var uuid: String?
    
    // 서버 타임스탬프(작성 시점) 자동 저장
    @ServerTimestamp var createdAt: Date?
    
    public var ageGroup: String
    public var gender: Gender
    public var nickname: String
    public var posts: [PostUUID]
    
    // createdAt, uuid는 모두 Firestore에서 채워주므로
    // 로컬에서 초기화할 필요가 없는 파라미터로 뺍니다
    public init(
        ageGroup: String,
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

//import Foundation
//import FirebaseFirestore
//
//public struct UserProfile: Codable {
//    // Firestore에 저장된 문서의 ID를 자동으로 매핑
//    @DocumentID var uuid: String?
//    
//    // 서버 타임스탬프(작성 시점) 자동 저장
//    @ServerTimestamp var createdAt: Date?
//    
//    public var ageGroup: String
//    public var gender: String
//    public var nickname: String
//    public var posts: [String]
//    
//    // createdAt, uuid는 모두 Firestore에서 채워주므로
//    // 로컬에서 초기화할 필요가 없는 파라미터로 뺍니다
//    public init(
//        ageGroup: String,
//        gender: String,
//        nickname: String,
//        posts: [String]
//    ) {
//        self.ageGroup = ageGroup
//        self.gender = gender
//        self.nickname = nickname
//        self.posts = posts
//    }
//}

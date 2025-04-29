//
//  FireStore.swift
//  Bridging
//
//  Created by 이현욱 on 4/27/25.
//

import Foundation

import FirebaseFirestore

class FireStore {
    static let shared = FireStore()
    
    private let db = Firestore.firestore()
    
    private init() { }
    
    func addUser(with uuid: String) async throws {
        try await db.collection("users").document(uuid).setData([
            "createdAt": FieldValue.serverTimestamp()
        ])
    }
    
    func getAllPosts() async throws -> [Post] {
        let snapshot = try await db.collection("posts").getDocuments()
        
        var result = [Post]()
        
        for document in snapshot.documents {
            let data = try document.data(as: Post.self)
            result.append(data)
        }
        
        print(result)
        return result
    }
    
    var lastDocument: DocumentSnapshot?

    func fetchPosts() async throws {
        var query = db.collection("posts")
            .order(by: "createdAt", descending: true)
            .limit(to: 10)
        
        if let lastDoc = lastDocument {
            query = query.start(afterDocument: lastDoc)
        }
        
        let snapshot = try await query.getDocuments()
        
        let posts = snapshot.documents.compactMap { document in
            try? document.data(as: Post.self)
        }
        
        lastDocument = snapshot.documents.last
    }
}

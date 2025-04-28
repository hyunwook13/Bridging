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
            "createdAt": Date().timeIntervalSince1970
        ])
    }
}

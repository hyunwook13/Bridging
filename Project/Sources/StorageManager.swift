//
//  StorageManager.swift
//  Bridging
//
//  Created by 이현욱 on 4/28/25.
//

import UIKit

import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    var storage: Storage
    lazy var storageRef = storage.reference()
    lazy var postImagesRef = storageRef.child("postImages")
    
    private init() {
        storage = Storage.storage(url:"gs://bridging-74f5e.firebasestorage.app")
    }
    
    func uploadImage(_ image: UIImage?) async throws -> (url:String, uuid:String) {
        guard let image = image else { throw NSError(domain: "No Image", code: 0) }
        
        // 1) 랜덤 UUID + 확장자
        let uuid = UUID().uuidString
        let filename = uuid + ".jpg"
        let fileRef = postImagesRef.child(filename)
        
        // 2) 이미지 데이터
        let data = image.jpegData(compressionQuality: 0.8)!
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // 3) 업로드
        //        storageRef.putFile(from: localFile, metadata: metadata)
        let savedMetadata = try await fileRef.putDataAsync(data, metadata: metadata)
        // 4) 다운로드 URL 반환
        
        let fileURL = try await fileRef.downloadURL().absoluteString
        
        return (fileURL, uuid)
    }
    
    func getImage(with uuid: String) -> UIImage? {
        
        var result: UIImage?
        // Create a reference to the file you want to download
        let postImageRef = postImagesRef.child("\(uuid).jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        postImageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                result = nil
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                result = image
            }
        }
        
        return result
    }
    
    func deleteImage(with uuid: String) async throws {
        let postImageRef = postImagesRef.child("\(uuid).jpg")
        
        try await postImageRef.delete()
    }
}


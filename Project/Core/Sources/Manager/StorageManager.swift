//
//  StorageManager.swift
//  Bridging
//
//  Created by 이현욱 on 4/28/25.
//

import UIKit

import FirebaseStorage

public final class StorageManager {
    public static let shared = StorageManager()
    
    var storage: Storage
    lazy var storageRef = storage.reference()
    lazy var postImagesRef = storageRef.child("postImages")
    
    private var processing = [String]()
    
    private var cachedImage = [String: UIImage]()
    
    private init() {
        storage = Storage.storage()
        storageRef = storage.reference(forURL: "gs://bridging-74f5e.firebasestorage.app")
    }
    
    public func uploadImage(_ image: UIImage?) async throws -> (url:String, uuid:String) {
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
    
    public func fetchPostImage(uuid: String?) async throws -> UIImage {
        guard let uuid = uuid, !uuid.isEmpty else { throw NSError(domain: "No Image", code: 0) }
        
        if let image = cachedImage[uuid] {
            return image
        }
        
        let imageRef = postImagesRef.child("\(uuid).jpg")
        let data = try await imageRef.data(maxSize: 1 * 1024 * 1024)
        
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "Image Encoding Error", code: 0)
        }
        
        cachedImage.updateValue(image, forKey: uuid)
        
        return image
    }
    
    public func deleteImage(with uuid: String) async throws {
        let postImageRef = postImagesRef.child("\(uuid).jpg")
        
        try await postImageRef.delete()
    }
}

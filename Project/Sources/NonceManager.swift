//
//  NonceManager.swift
//  Bridging
//
//  Created by 이현욱 on 4/27/25.
//

import Foundation
import CryptoKit

final class NonceManager {
    static let shared = NonceManager()
    
    private init() {}

    /// 랜덤 Nonce 문자열 생성
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }

    /// 문자열을 SHA256으로 해시
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        
        return hashedData.map { String(format: "%02x", $0) }.joined()
    }
}

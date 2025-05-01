//
//  KeyChainManager.swift
//  Core
//
//  Created by 이현욱 on 5/19/25.
//

import Foundation
import Security


public class KeyChainManager {
    public static let shared = KeyChainManager()
    
    private let key = "com.Wook.Briding.KeyChainManager"
    
    private init() { }
    
    /// Keychain에 String 저장
    @discardableResult
    public func saveToKeychain(value: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        // 기존 값 삭제
        SecItemDelete(query as CFDictionary)
        // 새 값 저장
        var attributes = query
        attributes[kSecValueData as String] = data
        let status = SecItemAdd(attributes as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    /// Keychain에서 String 불러오기
    public func loadFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess,
              let data = item as? Data,
              let value = String(data: data, encoding: .utf8)
        else {
            return nil
        }
        return value
    }
    
    @discardableResult
    public func isExistKeychain() -> Bool {
        loadFromKeychain() != nil
    }
    
    /// Keychain에서 값 삭제
    @discardableResult
    public func deleteFromKeychain() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}

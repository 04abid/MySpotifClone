//
//  KeychainManager.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 26.02.26.
//

import Foundation


protocol TokenProviding {
    var accesToken: String? {get}
    var refreshToken: String? {get}
}

protocol SecureStorage {
    func save(_ value: String, forKey key: String)
    func get(forKey key: String) -> String?
    func delete(forKey key: String)
}

final class KeychainManager:TokenProviding,SecureStorage {
    static let shared = KeychainManager()
    
    func save(_ value: String, forKey key: String) {
        let data = Data(value.utf8)
        
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data
        ]
        
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
   
    func get(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : true,
            kSecMatchLimit as String  : kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        
        guard let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    
    func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key
        ]
        SecItemDelete(query as CFDictionary)
    }
    
    var accesToken: String? {
        return get(forKey: "access_token")
    }
    
    var refreshToken: String? {
        return get(forKey: "refresh_token")
    }
}

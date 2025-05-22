//
//  KeychainManager.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/15/25.
//

import Foundation
import SCMLogger
import SCMNetwork
internal import Security

public final class KeychainManager {
    
    private let serviceName = "ScoopMe"
    
    public init() { }
    
    private func query(token: String? = nil, _ account: Keychain) -> [String: Any] {
        var data: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account.key,
            kSecAttrService as String: serviceName
        ]
        
        // 토큰 저장할 때만 데이터 추가되도록
        if let token {
            data[kSecValueData as String] = token.data(using: .utf8)
        }
        
        return data
    }
    
    /// 저장 및 업데이트
    public func setToken(token: String, for account: Keychain) throws {
        
        let query = self.query(token: nil, account)
        let updateData = [kSecValueData as String: token.data(using: .utf8) as Any] as [String: Any]
        
        let updateStatus = SecItemUpdate(query as CFDictionary, updateData as CFDictionary)
        
        switch updateStatus {
        case errSecSuccess: return
        case errSecItemNotFound:
            // 기존 항목없으면 추가하는 방향
            let addQuery = self.query(token: token, account)
            let addStatus = SecItemAdd(addQuery as CFDictionary, nil)
            
            switch addStatus {
            case errSecSuccess: return
            default:
                throw KeychainError.unhandledError(status: addStatus)
            }
        default:
            throw KeychainError.unhandledError(status: updateStatus)
        }
    }
    
    /// 불러오기
    public func getToken(for account: Keychain) throws -> String {
        
        var query = self.query(token: nil, account)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        switch status {
        case errSecSuccess:
            guard let data = dataTypeRef as? Data, let token = String(data: data, encoding: .utf8) else {
                throw KeychainError.unexpectedSavedData
            }
            
            return token
            
        case errSecItemNotFound:
            throw KeychainError.noSavedData
        default:
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    /// 삭제
    private func deleteToken(for account: Keychain) throws {
        
        let query = self.query(token: nil, account)
        let status = SecItemDelete(query as CFDictionary)
        
        switch status {
        case errSecSuccess, errSecItemNotFound: return
        default:
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    /// 전체 삭제
    public func deleteAllToken() {
        do {
            try deleteToken(for: .accessToken)
            try deleteToken(for: .refreshToken)
            try deleteToken(for: .deviceToken)
        } catch {
            Log.error("전체 토큰 삭제 실패: \(error)")
        }
    }
}

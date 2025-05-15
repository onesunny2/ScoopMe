//
//  KeychainManager.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/15/25.
//

import Foundation
import Combine
internal import SCMNetwork
internal import Security

public final class KeychainManager: ObservableObject {
    
    private let serviceName = "ScoopMe"
    
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
    
    /// 저장 및 조회
    public func setToken(token: String, for account: Keychain) -> Result<Void, KeychainError> {
        
        let query = self.query(token: nil, account)
        let updateData = [kSecValueData as String: token.data(using: .utf8) as Any] as [String: Any]
        
        let updateStatus = SecItemUpdate(query as CFDictionary, updateData as CFDictionary)
        
        switch updateStatus {
        case errSecSuccess:
            return .success(())
        case errSecItemNotFound:
            // 기존 항목없으면 추가하는 방향
            let addQuery = self.query(token: token, account)
            let addStatus = SecItemAdd(addQuery as CFDictionary, nil)
            
            switch addStatus {
            case errSecSuccess:
                return .success(())
            default:
                return .failure(.unhandledError(status: addStatus))
            }
        default:
            return .failure(.unhandledError(status: updateStatus))
        }
    }
    
    /// 불러오기
    public func getToken(for account: Keychain) -> Result<Void, KeychainError> {
        
        var query = self.query(token: nil, account)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        switch status {
        case errSecSuccess:
            guard let data = dataTypeRef as? Data, let token = String(data: data, encoding: .utf8) else {
                return .failure(.unexpectedSavedData)
            }
            
            return .success(())
            
        case errSecItemNotFound:
            return .failure(.noSavedData)
        default:
            return .failure(.unhandledError(status: status))
        }
    }
    
    /// 삭제
    private func deleteToken(for account: Keychain) -> Result<Void, KeychainError> {
        
        let query = self.query(token: nil, account)
        let status = SecItemDelete(query as CFDictionary)
        
        switch status {
        case errSecSuccess, errSecItemNotFound:
            return .success(())
        default:
            return .failure(.unhandledError(status: status))
        }
    }
    
    /// 전체 삭제
    public func deleteAllToken() {
        _ = deleteToken(for: .accessToken)
        _ = deleteToken(for: .refreshToken)
        _ = deleteToken(for: .deviceToken)
    }
}

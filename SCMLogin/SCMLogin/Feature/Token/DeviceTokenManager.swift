//
//  DeviceTokenManager.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/15/25.
//

import Foundation
import Combine
internal import SCMNetwork

public final class DeviceTokenManager: NetworkServiceProtocol {
    
    public init() {
        self.keychainManager = KeychainManager()
        self.network = SCMNetworkImpl()
    }
    
    private let keychainManager: KeychainManager
    let network: SCMNetworkImpl
    
    public func fetchToken(_ type: Keychain) -> String {
        do {
            let keychainManager = KeychainManager()
            let token = try keychainManager.getToken(for: type)
            return token
        } catch {
            print("\(type.rawValue)의 토큰 정보를 불러오는데 실패했습니다.")
            return ""
        }
    }
    
    // device Token 저장
    public func saveDeviceToken(_ device: String) {
        do {
            try keychainManager.setToken(token: device, for: .deviceToken)
        } catch {
            print("device Token 저장 실패")
        }
    }
    
    // deviceToken 업데이트
}

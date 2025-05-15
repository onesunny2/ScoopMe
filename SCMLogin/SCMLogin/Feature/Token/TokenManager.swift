//
//  TokenManager.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/15/25.
//

import Foundation
import Combine
internal import SCMNetwork

public final class TokenManager: ObservableObject {
    
    @Published var isTokenAvailable: Bool = false
    
    public init() {
        self.keychainManager = KeychainManager()
    }
    
    private let keychainManager: KeychainManager
    
    // 로그인 시 토큰 저장
    public func saveLoginTokens(access: String, refresh: String) {
        _ = keychainManager.setToken(token: access, for: .accessToken)
        _ = keychainManager.setToken(token: refresh, for: .refreshToken)
        
        isTokenAvailable = true
    }
    
    // device Token
    public func saveDeviceToken(_ device: String) {
        _ = keychainManager.setToken(token: device, for: .deviceToken)
    }
    
    // 리프레시 토큰 갱신
    
    /*
     통신 후 결과에 따라 뷰모델마다 결과에 따라 처리해줌
     
     */
    
    // 로그아웃 - 나중에 로그아웃 하면 토큰 다 삭제하도록
    public func logout() {
        keychainManager.deleteAllToken()
        isTokenAvailable = false
    }
}

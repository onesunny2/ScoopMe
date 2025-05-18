//
//  LoginTokenManager.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/15/25.
//

import Foundation
import Combine
import SCMLogger
internal import SCMNetwork

public final class LoginTokenManager: NSObject, UserServiceProtocol {
    
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    private let needLoginKey: String = "needLoginStatus"
    public var isNeedLogin: Bool {
        return UserDefaults.standard.bool(forKey: needLoginKey)
    }
    
    private let autoLoginKey: String = "autoLoginStatus"
    public var autoLoginAvailable: Bool {
        return UserDefaults.standard.bool(forKey: autoLoginKey)
    }
    
    public override init() {
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
            Log.error("\(type.rawValue)의 토큰 정보를 불러오는데 실패했습니다.")
            return ""
        }
    }
    
    // 로그인 시 토큰 저장
    public func saveLoginTokens(access: String, refresh: String) {
        do {
            try keychainManager.setToken(token: access, for: .accessToken)
            try keychainManager.setToken(token: refresh, for: .refreshToken)
        } catch {
            Log.error("로그인 토큰 저장 실패")
        }
    }
    
    @MainActor
    public func requestRefreshToken() async throws {
            let accessToken = fetchToken(.accessToken)
            let refreshToken = fetchToken(.refreshToken)
            
            let value = LoginURL.refreshToken(access: accessToken, refresh: refreshToken)
            let result = try await callRequest(value, type: RefreshTokenResponseDTO.self)
            
            Log.debug("✅ 리프레시토큰 결과: \(result.response)")
            
            // access 갱신
            saveLoginTokens(
                access: result.response.accessToken,
                refresh: result.response.refreshToken
            )
            
            // 통신 성공했으면 다시 false로 전환
            setNeedLoginStatus(false)
    }
    
    /// 로그아웃 - 나중에 로그아웃 하면 토큰 다 삭제하도록
    public func logout() {
        keychainManager.deleteAllToken()
    }
    
    // 자동로그인 유무 변경
    public func setAutoLoginAvailable(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: autoLoginKey)
    }
    
    private func setNeedLoginStatus(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: needLoginKey)
    }
}

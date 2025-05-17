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
    public func requestRefreshToken(
        onSuccess: @escaping () async -> ()
    ) async {
        do {
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
            
            // 갱신 완료 후 액션(API 재통신 or main화면 보내기)
            await onSuccess()
        } catch {
            // 리프레시 만료되면 재로그인으로 보내야 함
            Log.error("❎ 리프레시토큰 갱신 error: \(error)")
            
            guard let scmError = error as? SCMError else { return }
            
            switch scmError {
            default:
                alertTitle = "안내"
                alertMessage = "세션이 만료되었습니다.\n다시 로그인 후 사용해주세요."
                setNeedLoginStatus(true)  // true이면 로그인 화면으로 보냄!
            }
        }
    }
    
    /// 로그아웃 - 나중에 로그아웃 하면 토큰 다 삭제하도록
    public func logout() {
        keychainManager.deleteAllToken()
    }
    
    private func setNeedLoginStatus(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: needLoginKey)
    }
}

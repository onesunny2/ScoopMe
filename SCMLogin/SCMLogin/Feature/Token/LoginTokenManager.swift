//
//  LoginTokenManager.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/15/25.
//

import Foundation
import Combine
internal import SCMNetwork

public final class LoginTokenManager: UserServiceProtocol {
    
    @Published var isTokenAvailable: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var needLogin: Bool = false
    
    public init() {
        self.keychainManager = KeychainManager()
        self.network = SCMNetworkImpl()
    }
    
    private let keychainManager: KeychainManager
    let network: SCMNetworkImpl
    
    // 로그인 시 토큰 저장
    public func saveLoginTokens(access: String, refresh: String) {
        do {
            try keychainManager.setToken(token: access, for: .accessToken)
            try keychainManager.setToken(token: refresh, for: .refreshToken)
            isTokenAvailable = true
        } catch {
            print("로그인 토큰 저장 실패")
        }
    }
    
    // 리프레시 토큰 갱신
    @MainActor
    public func refreshAccessToken() async -> Bool {
        do {
            let refreshToken = try keychainManager.getToken(for: .refreshToken)
            let accessToken = try keychainManager.getToken(for: .accessToken)
            
            guard refreshToken.count > 0 else {
                // refresh 값 없으면 알럿창 띄우고 로그인 화면으로 고고
                return false
            }
            
            // 리프레시 통신 진행
            await requestRefreshToken(accessToken, refreshToken)
            
            return true  // true이면 다시 재통신 진행
        } catch {
            print("리프레시 토큰 갱신")
            return false
        }
    }
    
    @MainActor
    private func requestRefreshToken(_ access: String, _ refresh: String) async {
        do {
            let value = LoginURL.refreshToken(access: access, refresh: refresh)
            let result = try await callRequest(value, method: .get, type: RefreshTokenResponseDTO.self)
            
            print("✅ 리프레시토큰 결과: \(result.response)")
            saveLoginTokens(
                access: result.response.accessToken,
                refresh: result.response.refreshToken
            )
        } catch {
            // 여기 에러에 따라서 처리해야 함!!!!
            print("❎ 리프레시토큰 갱신 error: \(error)")
            
            guard let scmError = error as? SCMError else { return }
            
            switch scmError {
            case .serverError:
                alertTitle = "안내"
                alertMessage = "세션이 만료되었습니다.\n다시 로그인 후 사용해주세요."
                needLogin = true
            default:
                alertTitle = "오류"
                alertMessage = scmError.localizedDescription
            }
        }
    }
    
    // 로그아웃 - 나중에 로그아웃 하면 토큰 다 삭제하도록
    public func logout() {
        keychainManager.deleteAllToken()
        isTokenAvailable = false
    }
}

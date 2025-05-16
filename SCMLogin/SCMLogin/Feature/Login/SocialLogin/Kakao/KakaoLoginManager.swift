//
//  KakaoLoginManager.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/12/25.
//

internal import KakaoSDKUser
import SCMLogger

public final class KakaoLoginManager {
    
    public static let shared = KakaoLoginManager()
    private init() { }
    
    @MainActor
    public func kakaoLogin() async throws -> String {
        if UserApi.isKakaoTalkLoginAvailable() {
            Log.debug("카카오톡으로 로그인 시도")
            return try await loginWithKakaoTalk()
        } else {
            Log.debug("카카오계정으로 로그인 시도")
            return try await loginWithKakaoAccount()
        }
    }
    
    /// kakaoTalk으로 로그인
    @MainActor
    private func loginWithKakaoTalk() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                
                if let error {
                    Log.error("❎ loginWithKakaoTalk Error: \(error)")
                    continuation.resume(throwing: KakaoError.loginFailed(error.localizedDescription))
                }
                
                guard let accessToken = oauthToken?.accessToken else {
                    continuation.resume(throwing: KakaoError.noAccessToken)
                    return
                }
                
                Log.debug("✅ 카카오톡 로그인 success")
                continuation.resume(returning: accessToken)
            }
        }
    }
    
    /// kakao 계정으로 로그인
    @MainActor
    private func loginWithKakaoAccount() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                
                if let error {
                    Log.error("❎ loginWithKakaoAccount Error: \(error)")
                    continuation.resume(throwing: KakaoError.loginFailed(error.localizedDescription))
                    return
                }
                
                guard let accessToken = oauthToken?.accessToken else {
                    continuation.resume(throwing: KakaoError.noAccessToken)
                    return
                }
                
                Log.debug("✅ 카카오 계정 로그인 success")
                continuation.resume(returning: accessToken)
            }
        }
    }
}

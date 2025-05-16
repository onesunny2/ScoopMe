//
//  LoginManager.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/13/25.
//

import Foundation
import Combine
internal import SCMNetwork

public final class LoginManager: UserServiceProtocol {

    @Published public var loginFalied: Bool = false
    @Published public var alertMessage: String = ""
    public var alertTitle: String = "로그인 실패"
    
    public init() {
        self.loginTokenManager = LoginTokenManager()
        self.deviceTokenManager = DeviceTokenManager()
        self.network = SCMNetworkImpl()
    }
    
    private let loginTokenManager: LoginTokenManager
    private let deviceTokenManager: DeviceTokenManager
    let network: SCMNetworkImpl
    
    @MainActor
    public func postAppleLogin(id token: String) async {
        do {
            let value = LoginURL.appleLogin(id: token, device: nil, nick: "sunny")
            let result = try await callRequest(value, type: LoginDTO.self)
            
            //            Log.debug("✅ 애플로그인 결과: \(result.response)")
            print("✅ 애플로그인 결과: \(result.response)")
            await setTokens(result: result)
        } catch {
            //            Log.error("❎ 애플 login error: \(error)")
            print("❎ 애플 login error: \(error)")
            loginFalied = true
            handleError(error, &alertMessage)
        }
    }
    
    @MainActor
    public func postKakaoLogin(oauth token: String) async {
        do {
            let value = LoginURL.kakaoLogin(oauth: token, device: nil)
            let result = try await callRequest(value, type: LoginDTO.self)
            
            //            Log.debug("✅ 카카오로그인 결과: \(result.response)")
            print("✅ 카카오로그인 결과: \(result.response)")
            await setTokens(result: result)
        } catch {
            //            Log.error("❎ 카카오 login error: \(error)")
            print("❎ 카카오 login error: \(error)")
            loginFalied = true
            handleError(error, &alertMessage)
        }
    }
    
    @MainActor
    public func postEmailLogin(_ email: String, _ password: String) async {
        do {
            let value = LoginURL.emailLogin(email: email, pw: password, device: nil)
            let result = try await callRequest(value, type: LoginDTO.self)
            
            //            Log.debug("✅ 이메일로그인 결과: \(result.response)")
            print("✅ 이메일로그인 결과: \(result.response)")
            await setTokens(result: result)
        } catch {
            //            Log.error("❎ 이메일 login error: \(error)")
            print("❎ 이메일 login error: \(error)")
            loginFalied = true
            handleError(error, &alertMessage)
        }
    }
    
    // 디바이스토큰 달라질 시 update, 로그인 시 토큰 저장
    private func setTokens(result: HTTPResponse<LoginDTO>) async {
        let deviceToken = deviceTokenManager.fetchToken(.deviceToken)
        await deviceTokenManager.updateDeviceToken(deviceToken)
        
        loginTokenManager.saveLoginTokens(
            access: result.response.accessToken,
            refresh: result.response.refreshToken
        )
    }
}
